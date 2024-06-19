{ user, config, pkgs, ... }:
 
let
   xdg_configHome = "${config.users.users.${user}.home}/.config";
   xdg_dataHome   = "${config.users.users.${user}.home}/.local/share";
   xdg_stateHome  = "${config.users.users.${user}.home}/.local/state"; in
{
   ".ssh/config" = {
      text = builtins.readFile ../darwin/config/ssh_config;
   };

   "${xdg_configHome}/1Password/ssh/agent.toml" = {
      text = builtins.readFile ../darwin/config/1Password_ssh_agent.toml;
   };

   "${config.users.users.${user}.home}/Library/Application Support/Rectangle/RectangleConfig.json" = {
      text = builtins.readFile ../darwin/config/RectangleConfig.json;
   };

   "${xdg_configHome}/alacritty/alacritty.toml" = {
      text = builtins.readFile ../darwin/config/alacritty.toml;
   };
}
 