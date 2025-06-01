const { execSync } = require("child_process");

function fetchIndexers(baseUrl, apiKey, tag) {
  const buffer = execSync(
    `curl -fsSL "${baseUrl}/api/v1/tag/detail?apikey=${apiKey}"`,
  );
  const response = JSON.parse(buffer.toString("utf8"));
  const indexerIds =
    response.filter((t) => t.label === tag)[0]?.indexerIds ?? [];
  const indexers = indexerIds.map(
    (i) => `${baseUrl}/${i}/api?apikey=${apiKey}`,
  );
  console.log(`Loaded ${indexers.length} indexers from Prowlarr`);
  return indexers;
}

module.exports = {
  action: "inject",
  apiKey: process.env.CROSS_SEED_API_KEY,
  linkCategory: "cross-seed",
  linkDirs: ["/downloads/complete/cross-seed"],
  linkType: "hardlink",
  matchMode: "partial",
  port: 2468,
  skipRecheck: true,
  radarr: [
    "http://radarr.radarr.svc.cluster.local/?apikey=" +
      process.env.RADARR_API_KEY,
    "http://anime-radarr.anime-radarr.svc.cluster.local/?apikey=" +
      process.env.RADARR_API_KEY,
  ],
  sonarr: [
    "http://sonarr.sonarr.svc.cluster.local:8989/?apikey=" +
      process.env.SONARR_API_KEY,
    "http://anime-sonarr.anime-sonarr.svc.cluster.local:8989/?apikey=" +
      process.env.SONARR_API_KEY,
  ],
  torrentClients: ["qbittorrent:http://qbittorrent.nas.g4v.dev"],
  torznab: fetchIndexers(
    "http://prowlarr.prowlarr.svc.cluster.local:9696",
    process.env.PROWLARR_API_KEY,
    "cross-seed",
  ),
  useClientTorrents: true,
};
