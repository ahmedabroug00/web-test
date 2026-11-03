# GitHub's ubuntu-latest runner includes Ruby. Only standard libraries are used.
require 'yaml'
require 'cgi'
require 'fileutils'

ROOT = File.expand_path(__dir__)
OUTPUT = File.join(ROOT, '_site')

def escape(value)
  CGI.escapeHTML(value.to_s)
end

def asset_path(value, directory)
  # Feed paths are repository-relative, even when written with a leading slash.
  relative = value.to_s.sub(%r{\A/}, '')
  parts = relative.split('/')
  unless parts.first == directory && parts.length > 1 && parts.none? { |part| part.empty? || part == '.' || part == '..' } && !relative.include?('\\') && !relative.match?(/[?#:]/)
    raise "Invalid #{directory} asset path: #{value.inspect}"
  end
  path = File.realpath(File.join(ROOT, relative))
  allowed = File.realpath(File.join(ROOT, directory)) + File::SEPARATOR
  raise "Asset outside #{directory}: #{relative}" unless path.start_with?(allowed) && File.file?(path)
  './' + relative.split('/').map { |part| CGI.escape(part).gsub('+', '%20') }.join('/')
end

feed = YAML.safe_load(File.read(File.join(ROOT, 'feed.yaml')), aliases: false)
raise 'Feed must be a mapping with an item list' unless feed.is_a?(Hash) && feed['item'].is_a?(Array)
%w[title author description image].each do |key|
  raise "Missing feed #{key}" if feed[key].to_s.strip.empty?
end

artwork = asset_path(feed['image'], 'images')
episodes = feed['item'].map.with_index do |episode, index|
  raise "Episode #{index + 1} must be a mapping" unless episode.is_a?(Hash)
  %w[title description file published duration].each do |key|
    raise "Episode #{index + 1} is missing #{key}" if episode[key].to_s.strip.empty?
  end
  audio = asset_path(episode['file'], 'audio')
  <<~HTML
    <article class="podcast-episode">
      <p class="eyebrow">EPISODE #{format('%02d', index + 1)} · #{escape(episode['duration'])}</p>
      <h3>#{escape(episode['title'])}</h3>
      <p>#{escape(episode['description'])}</p>
      <p class="episode-date">Published: #{escape(episode['published'])}</p>
      <audio controls preload="none" aria-label="Listen to #{escape(episode['title'])}" src="#{escape(audio)}"></audio>
      <a class="text-link" href="#{escape(audio)}">Open audio file ↗</a>
    </article>
  HTML
end.join

podcast = <<~HTML
  <div class="podcast-intro">
    <img src="#{escape(artwork)}" alt="#{escape(feed['title'])} artwork" width="180" height="180" loading="lazy">
    <div><p class="eyebrow">#{escape(feed['subtitle'])}</p><h3>#{escape(feed['title'])}</h3>
    <p>#{escape(feed['description'])}</p><p>Hosted by #{escape(feed['author'])}.</p>
    <p class="podcast-attribution">Original series credited to its creators; this independent site is not affiliated with LinkedIn Learning.</p>
    <a class="text-link" href="./feed.yaml">View the source YAML feed ↗</a></div>
  </div>
  <div class="podcast-grid">#{episodes}</div>
HTML

html = File.read(File.join(ROOT, 'index.html'))
marker = /<!-- PODCAST:START -->.*?<!-- PODCAST:END -->/m
raise 'Missing podcast template markers' unless html.scan(marker).length == 1
html = html.sub(marker) { "<!-- PODCAST:START -->\n#{podcast}<!-- PODCAST:END -->" }

# Validate all content before staging; never publish the repository itself.
FileUtils.mkdir_p(OUTPUT)
File.write(File.join(OUTPUT, 'index.html'), html)
%w[styles.css app.js favicon.svg feed.yaml].each { |file| FileUtils.cp(File.join(ROOT, file), OUTPUT) }
%w[audio images].each { |directory| FileUtils.cp_r(File.join(ROOT, directory), OUTPUT) }
FileUtils.touch(File.join(OUTPUT, '.nojekyll'))
puts "Built #{feed['item'].length} podcast episodes from feed.yaml into _site/"