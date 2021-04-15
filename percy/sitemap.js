const Axios = require("axios")
const PercyScript = require("@percy/script");
const parseUrl = require("url-parse")
const xml = require("xml2json")

async function loadSitemap(url) {
  const response = await Axios.get(url, {
    responseType: "text",
  })

  return xml.toJson(response.data, {
    object: true,
  }).urlset.url
}


(async() => {

  console.log('[INFO] Fetching sitemap');
  const pageReferences = await loadSitemap(process.env.SITEMAP_URL)

  console.log('[INFO] Found %d page references', pageReferences.length);
  for (const i in pageReferences) {

    const url = parseUrl(pageReferences[i].loc)
    console.log('[INFO] Processing %s', url.href);

    await PercyScript.run(async (page, percySnapshot) => {
        await page.goto(url.href);
        // ensure the page has loaded before capturing a snapshot
        // await page.waitForSelector("body");
        await percySnapshot(url.pathname);
    });
  }

  console.log('[INFO] Finished!');
})();
