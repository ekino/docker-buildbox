const Axios = require("axios")
const fsPromises = require('fs').promises
const PercyScript = require("@percy/script");
const parseUrl = require("url-parse")
const xml = require("xml2json")

/**
 * Parse an XML sitemap and return a JSON array of location objects.
 * @param {string} url
 * @returns {Array}
 */
async function loadSitemap(url) {

  let sitemapXML;
  if (url.match(/^http/g)) {
    let response = await Axios.get(url, {
      responseType: "text",
    })
    sitemapXML = response.data
  } else {
    sitemapXML = await fsPromises.readFile(url, 'utf8')
  }

  if (!sitemapXML) {
    console.log('[WARNING] Unable to load any data from URL: %s', url);
    return []
  }

  return xml.toJson(sitemapXML, {
    object: true,
  }).urlset.url
}


(async() => {
  console.log('[INFO] Fetching sitemap');
  const pageReferences = await loadSitemap(process.env.SITEMAP_URL)

  console.log('[INFO] Found %d page references', pageReferences.length);
  const maxPages = parseInt(process.env.MAX_PAGES || 100, 10)
  const pageLoadDelay = parseInt(process.env.PAGE_LOAD_DELAY || 5000, 10)
  for (const i in pageReferences) {
    if (maxPages && parseInt(i, 10) >= maxPages) {
      console.log('[INFO] Reached maximum pages (%d), finishing.', maxPages);
      break
    }

    if (maxPages && i >= maxPages) {
      console.log('[INFO] Reached maximum pages (%d), finishing.', maxPages);
      break
    }

    if (maxPages && i >= maxPages) {
      console.log('[INFO] Reached maximum pages (%d), finishing.', maxPages);
      break
    }

    const url = parseUrl(pageReferences[i].loc)
    console.log('[INFO] Processing %s', url.href);

    await PercyScript.run(async (page, percySnapshot) => {
        await page.goto(url.href);
        // ensure the page has loaded before capturing a snapshot
        await page.waitForTimeout(pageLoadDelay);
        await percySnapshot(url.pathname);
    });
  }

  console.log('[INFO] Finished!');
})();
