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
# 
#   # Raycast script so that "Run Emacs" is available and uses Emacs daemon
#   "${xdg_dataHome}/bin/emacsclient" = {
#     executable = true;
#     text = ''
#       #!/bin/zsh
#       #
#       # Required parameters:
#       # @raycast.schemaVersion 1
#       # @raycast.title Run Emacs
#       # @raycast.mode silent
#       #
#       # Optional parameters:
#       # @raycast.packageName Emacs
#       # @raycast.icon ${xdg_dataHome}/img/icons/Emacs.icns
#       # @raycast.iconDark ${xdg_dataHome}/img/icons/Emacs.icns
# 
#       if [[ $1 = "-t" ]]; then
#         # Terminal mode
#         ${pkgs.emacs}/bin/emacsclient -t $@
#       else
#         # GUI mode
#         ${pkgs.emacs}/bin/emacsclient -c -n $@
#       fi
#     '';
#   };
}
 