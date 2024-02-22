# This is a function that can be used to generate a .luarc.json
# containing the Neovim API all plugins in the workspace directory.
{
  pkgs,
  lib,
  stdenv,
}: {
  # list of plugins that have a /lua directory
  plugins ? [],
}: let
  plugin-lib-dirs = lib.lists.map (plugin:
    if
      builtins.hasAttr "vimPlugin" plugin
      && plugin.vimPlugin
      || plugin.pname == "nvim-treesitter"
    then "${plugin}/lua"
    else "${plugin}/lib/lua/5.1")
  plugins;
  luarc = {
    runtime.version = "LuaJIT";
    Lua = {
      globals = [
        "vim"
      ];
      workspace = {
        library =
          [
            "${pkgs.neovim-unwrapped}/share/nvim/runtime/lua"
            "${pkgs.vimPlugins.neodev-nvim}/types/stable"
            "\${3rd}/busted/library"
            "\${3rd}/luassert/library"
          ]
          ++ plugin-lib-dirs;
        ignoreDir = [
          ".git"
          ".github"
          ".direnv"
          "result"
          "nix"
          "doc"
        ];
      };
      diagnostics = {
        libraryFiles = "Disable";
        disable = [];
      };
    };
  };
in
  pkgs.runCommand ".luarc.json" {
    buildInputs = [
      pkgs.jq
    ];
    passAsFile = ["rawJSON"];
    rawJSON = builtins.toJSON luarc;
  } ''
    {
      jq . <"$rawJSONPath"
    } >$out
  ''
