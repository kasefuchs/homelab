[[ define "cinny_config" -]]
[[- $config := var "config" . -]]
{
  "allowCustomHomeservers": [[ var "allow_custom_homeservers" . ]],
  "defaultHomeserver": [[ var "default_homeserver_index" . ]],
  "homeserverList": [[ var "homeserver_list" .  | toStringList ]]
}
[[- end ]]

[[ define "httpd_config" -]]
H:[[ var "home_path" . ]]
I:index.html
E404:index.html
[[- end ]]
