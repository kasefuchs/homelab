[[ define "cinny_config" -]]
[[- $config := var "config" . -]]
{
  "allowCustomHomeservers": [[ $config.allow_custom_homeservers ]],
  "defaultHomeserver": [[ $config.default_homeserver_index ]],
  "homeserverList": [[ $config.homeservers | toStringList ]]
}
[[- end ]]

[[ define "httpd_config" -]]
H:[[ var "home_path" . ]]
I:index.html
E404:index.html
[[- end ]]
