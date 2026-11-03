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

## Publish on GitHub Pages

1. Commit and push the website and workflow to the `main` branch of `ahmedabroug00/web-test`.
2. Open **[Repository Settings → Pages](https://github.com/ahmedabroug00/web-test/settings/pages)**.
3. Under **Build and deployment → Source**, select **GitHub Actions**. This is a one-time repository setting; adding the workflow alone does not enable Pages.
4. Open **[Actions → Deploy website to GitHub Pages](https://github.com/ahmedabroug00/web-test/actions/workflows/deploy-pages.yml)** and select **Run workflow** if the initial push ran before Pages was enabled. If GitHub Actions is disabled for this repository, enable it in repository settings first.
5. After the deployment succeeds, visit **https://ahmedabroug00.github.io/web-test/**. The deployment job also provides the published URL.

Later changes to the website files on `main` publish automatically. Pull requests do not deploy. The workflow pins official GitHub actions to immutable commit hashes, grants write permissions only to the deployment job, and publishes only the four public website files (plus an empty `.nojekyll` file). Review and refresh action pins periodically for upstream security and compatibility updates.

GitHub Pages must be available for the repository's visibility and account plan. No custom domain, backend, package installation, or API key is required.

## Local preview

Open [index.html](index.html) directly in a modern browser, or serve this folder with any static web server. A local HTTP server most closely matches GitHub Pages behavior. There is no build step or npm dependency.

The site uses Google Fonts for DM Sans and Space Grotesk. Browsers request those fonts from Google; system font fallbacks keep the site usable if that service is unavailable. All artwork is original CSS or SVG; there are no external scripts, tracking services, or analytics.

## Edit the site

| File | Purpose |
| --- | --- |
| [index.html](index.html) | Page layout, guides, learning path, and external resource links |
| [styles.css](styles.css) | Theme variables, layout, responsive breakpoints, and reduced-motion behavior |
| [app.js](app.js) | Search, filtering, theme preferences, and deep links to expanded guides |
| [favicon.svg](favicon.svg) | Website icon |
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

## Existing podcast material

The original [feed.yaml](feed.yaml), [README-feed.md](README-feed.md), audio recordings, and artwork are preserved unchanged. They describe **The Future in Tech**, a separate series attributed to its original creators. They are not republished as part of this site's Pages artifact, and the website does not imply affiliation with that series or LinkedIn Learning.