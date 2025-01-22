const { join } = require("path")

/**
 * @type {import("puppeteer").Configuration}
 */
module.exports = {
  // Changes the cache location for Puppeteer.
  cacheDirectory: join(__dirname, ".cache", "puppeteer"),
  downloadBaseUrl: "https://storage.googleapis.com/chrome-for-testing-public",
}
