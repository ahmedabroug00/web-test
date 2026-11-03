# Dev / Notes

A responsive technology and software-development knowledge hub, published as a static website on GitHub Pages.

**Website (after deployment):** https://ahmedabroug00.github.io/web-test/

## What's included

- Six original, expandable guides covering software engineering, AI-assisted development, web fundamentals, CI/CD, Git, and API security.
- Topic filters, full-text search, result announcements, and an empty-state reset.
- A three-step learning path and links to authoritative learning resources.
- Dark and light themes, system-preference detection, and a saved theme preference when browser storage is available.
- Responsive layouts, keyboard-visible focus, reduced-motion support, and a skip link.
- Useful content and native expandable guides even when JavaScript is disabled.
- A podcast section generated directly from [feed.yaml](feed.yaml), including series attribution, episode descriptions, artwork, and native audio players.

## Publish on GitHub Pages

1. Commit and push the website and workflow to the `main` branch of `ahmedabroug00/web-test`.
2. Open **[Repository Settings → Pages](https://github.com/ahmedabroug00/web-test/settings/pages)**.
3. Under **Build and deployment → Source**, select **GitHub Actions**. This is a one-time repository setting; adding the workflow alone does not enable Pages.
4. Open **[Actions → Deploy website to GitHub Pages](https://github.com/ahmedabroug00/web-test/actions/workflows/deploy-pages.yml)** and select **Run workflow** if the initial push ran before Pages was enabled. If GitHub Actions is disabled for this repository, enable it in repository settings first.
5. After the deployment succeeds, visit **https://ahmedabroug00.github.io/web-test/**. The deployment job also provides the published URL.

Later changes to the website files, YAML feed, audio, artwork, or build script on `main` publish automatically. Pull requests do not deploy. The workflow pins official GitHub actions to immutable commit hashes and grants write permissions only to the deployment job. It uses Ruby's standard YAML parser to render the podcast section, then publishes the generated website, feed, audio, and images (plus an empty `.nojekyll` file). Review and refresh action pins periodically for upstream security and compatibility updates.

GitHub Pages must be available for the repository's visibility and account plan. No custom domain, backend, package installation, or API key is required.

## Local preview

Open [index.html](index.html) directly in a modern browser to preview the developer guides and design. To preview the podcast content too, run `ruby build.rb` from the repository root and open the generated website in the output directory `_site/`, or serve that directory with any static web server. The source template deliberately shows a build-preview message instead of duplicating episode data.

Ruby 3 or newer is required for the build; the GitHub-hosted Ubuntu runner includes it. No third-party gems or npm packages are required. The build validates required feed fields and local media paths, escapes YAML text before inserting it into HTML, and renders native audio players that work without JavaScript. Feed media paths beginning with `/audio/` or `/images/` are converted to relative URLs so they work under the GitHub Pages project path.

The site uses Google Fonts for DM Sans and Space Grotesk. Browsers request those fonts from Google; system font fallbacks keep the site usable if that service is unavailable. All artwork is original CSS or SVG; there are no external scripts, tracking services, or analytics.

## Edit the site

| File | Purpose |
| --- | --- |
| [index.html](index.html) | Page layout, guides, learning path, and external resource links |
| [styles.css](styles.css) | Theme variables, layout, responsive breakpoints, and reduced-motion behavior |
| [app.js](app.js) | Search, filtering, theme preferences, and deep links to expanded guides |
| [favicon.svg](favicon.svg) | Website icon |
| [feed.yaml](feed.yaml) | Source of truth for podcast metadata and episodes |
| [build.rb](build.rb) | Parse YAML, validate media, and render the public website |
| [.github/workflows/deploy-pages.yml](.github/workflows/deploy-pages.yml) | Static artifact preparation and GitHub Pages deployment |

To add a guide, copy an existing `article.note-card`, give it a unique `id`, and use one of the existing `data-category` values: `engineering`, `ai`, `devops`, or `tools`. Add its content inside the native `details` element. Update the displayed note number and the **All notes** count when adding or removing guides. Reading times are editorial estimates.

Use relative paths for website assets so the site works under the `/web-test/` project path. If you fork or rename this repository, update the repository links in [index.html](index.html) and the website URL in this readme.

## Validation checklist

- Confirm all six guides appear on initial load.
- Select each topic and combine it with a search query.
- Search for a nonexistent phrase, then reset the filters.
- Follow the featured guide and learning-path links while a different topic is selected; the target guide should appear and expand.
- Switch themes and reload; the preference should persist when storage is available.
- Check a narrow mobile viewport, keyboard navigation, and reduced-motion settings.
- Disable JavaScript and confirm the guides remain readable and expandable.
- Verify the GitHub Actions deployment is successful after publishing.
- Build the website and confirm each YAML episode has its title, description, publication date, duration, and playable audio in the podcast section.
- Change an episode in the YAML feed and rebuild; verify the generated page reflects the change without editing the HTML template.

## Existing podcast material

The original [feed.yaml](feed.yaml), audio recordings, and artwork describe **The Future in Tech**, a separate series attributed to its original creators. The YAML is now used to generate the podcast section on every build, and the feed and media are included in the Pages artifact. Existing feed values and media are not modified by the build. The website preserves the author and subtitle from the feed and explicitly states that this independent site is not affiliated with LinkedIn Learning. Confirm the necessary redistribution rights for these recordings and artwork before publishing them.