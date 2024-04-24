[[ define "config" -]]
[[- $service := var "service" . -]]
[[- $config := var "config" . -]]
server:
  address: 0.0.0.0
  port: {{ env "NOMAD_HOST_PORT_[[ $service.port ]]" }}

lavalink:
  plugins:
    - dependency: com.github.topi314.lavasrc:lavasrc-plugin:4.0.1
      repository: https://maven.lavalink.dev/releases

  server:
    password: [[ $config.password ]]
    sources:
      youtube: [[ $config.source.youtube.enabled ]]
      bandcamp: [[ $config.source.bandcamp.enabled ]]
      soundcloud: [[ $config.source.soundcloud.enabled ]]
      twitch: [[ $config.source.twitch.enabled ]]
      vimeo: [[ $config.source.vimeo.enabled ]]
      http: [[ $config.source.http.enabled ]]
      local: [[ $config.source.local.enabled ]]

plugins:
  lavasrc:
    sources:
      spotify: [[ $config.source.spotify.enabled ]]
      applemusic: [[ $config.source.apple_music.enabled ]]
      deezer: [[ $config.source.deezer.enabled ]]
      yandexmusic: [[ $config.source.yandex_music.enabled ]]
      flowerytts: [[ $config.source.flowery_tts.enabled ]]
      youtube: [[ $config.source.youtube.enabled ]]

    [[ if $config.source.yandex_music.enabled -]]
    yandexmusic:
      accessToken: [[ $config.source.yandex_music.access_token ]]
    [[ end -]]

    [[ if $config.source.apple_music.enabled -]]
    applemusic:
      countryCode: [[ $config.source.apple_music.country_code ]]
      mediaAPIToken: [[ $config.source.apple_music.media_api_token ]]
    [[ end -]]

    [[ if $config.source.spotify.enabled -]]
    spotify:
      countryCode: [[ $config.source.spotify.country_code ]]
      clientId: [[ $config.source.spotify.client_id ]]
      clientSecret: [[ $config.source.spotify.client_secret ]]
    [[ end -]]

[[- end ]]
