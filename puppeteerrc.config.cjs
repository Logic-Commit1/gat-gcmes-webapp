/**
 * @type {import("puppeteer").Configuration}
 */
module.exports = {
  // Download Chrome (default `skipDownload: false`).
  chrome: {
    skipDownload: false,
  },
  cacheDirectory: "/opt/render/.cache/puppeteer",
}
