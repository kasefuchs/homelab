[[ define "config" -]]
[[- $config := . -]]
{
  "allowCustomHomeservers": [[ $config.allow_custom_homeservers ]],
  "defaultHomeserver": [[ $config.default_homeserver_index ]],
  "homeserverList": [[ $config.homeservers | toStringList ]]
}
[[- end ]]
