# homelab

My homelab configs and scripts.

Each subdirectory contains a service (or stack) with its own `docker-compose.yml` / `compose.yaml`.

## Port Mapping

Sorted by host port, ascending.

| Host Port | Service | Container | Container Port | Protocol | Compose File |
|---|---|---|---|---|---|
| 80 | Homepage | homepage | 3000 | TCP | `homepage/compose.yaml` |
| 2283 | Immich | immich | 2283 | TCP | `immich/compose.yaml` |
| 3000 | Open WebUI | open-webui | 8080 | TCP | `ai/compose.yaml` |
| 6881 | qBittorrent (BitTorrent) | qbittorrent | 6881 | TCP | `media/compose.yaml` |
| 6881 | qBittorrent (BitTorrent) | qbittorrent | 6881 | UDP | `media/compose.yaml` |
| 7200 | KOReader Sync | kosync | 17200 | TCP | `koreader-sync-server/docker-compose.yml` |
| 7878 | Radarr | radarr | 7878 | TCP | `media/compose.yaml` |
| 8080 | qBittorrent | qbittorrent | 8080 | TCP | `media/compose.yaml` |
| 8083 | Calibre-Web | calibre-web | 8083 | TCP | `calibre-web/compose.yaml` |
| 8096 | Jellyfin | jellyfin | 8096 | TCP | `media/compose.yaml` |
| 8191 | Flaresolverr | flaresolverr | 8191 | TCP | `media/compose.yaml` |
| 8888 | SearXNG | searxng-core | 8080 | TCP | `searxng/docker-compose.yml` |
| 8920 | Jellyfin (HTTPS) | jellyfin | 8920 | TCP | `media/compose.yaml` |
| 8989 | Sonarr | sonarr | 8989 | TCP | `media/compose.yaml` |
| 9696 | Prowlarr | prowlarr | 9696 | TCP | `media/compose.yaml` |
| 11434 | Ollama | ollama | 11434 | TCP | `ai/compose.yaml` |

