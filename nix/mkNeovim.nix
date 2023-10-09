# Function for creating a Neovim derivation
{
  pkgs,
  lib,
}:
with lib;
  {
    appName ? null, # NVIM_APPNAME - Defaults to 'nvim'
    plugins ? [], # List of plugins
    devPlugins ? [], # List of dev plugins (will be bootstrapped)
    extraPackages ? [], # Extra runtime dependencies (e.g. ripgrep, ...)
    # The below arguments can typically be left as their defaults
    wrapRc ? true, # Wrap the init.lua?
    resolvedExtraLuaPackages ? [], # Additional lua packages (not plugins)
    extraPython3Packages ? p: [], # Additional python 3 packages
    withPython3 ? true,
    withSqlite ? true,
    withRuby ? false,
    withNodeJs ? false,
    viAlias ? true,
    vimAlias ? true,
  }: let
    defaultPlugin = {
      plugin = null; # e.g. nvim-lspconfig
      config = null; # plugin config
      optional = false;
      runtime = {};
    };

    externalPackages = extraPackages ++ (optionals withSqlite [pkgs.sqlite]);

    normalizedPlugins = map (x:
      defaultPlugin
      // (
        if x ? plugin
        then x
        else {plugin = x;}
      ))
    plugins;

    neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
      inherit extraPython3Packages withPython3 withRuby withNodeJs viAlias vimAlias;
      plugins = normalizedPlugins;
    };

    customRC =
      ''
        vim.loader.enable()
        vim.opt.rtp:prepend('${../nvim/lua}')
      ''
      + (builtins.readFile ../nvim/init.lua)
      + neovimConfig.neovimRcContent
      + optionalString (devPlugins != []) (
        ''
          local dev_pack_path = vim.fn.stdpath('data') .. '/site/pack/dev'
          local dev_plugins_dir = dev_pack_path .. '/opt'
          local dev_plugin_path
        ''
        + strings.concatMapStringsSep
        "\n"
        (plugin: ''
          dev_plugin_path = dev_plugins_dir .. '/${plugin.name}'
          if vim.fn.empty(vim.fn.glob(dev_plugin_path)) > 0 then
            vim.notify('Bootstrapping dev plugin ${plugin.name} ...', vim.log.levels.INFO)
            vim.cmd('!${pkgs.git}/bin/git clone ${plugin.url} ' .. dev_plugin_path)
          end
          vim.cmd('packadd! ${plugin.name}')
        '')
        devPlugins
      )
      + ''
        vim.opt.rtp:append('${../nvim}')
      '';

    extraMakeWrapperArgs = builtins.concatStringsSep " " (
      (optional (appName != "nvim" && appName != null && appName != "")
        ''--set NVIM_APPNAME "${appName}"'')
      ++ (optional (externalPackages != [])
        ''--prefix PATH : "${makeBinPath externalPackages}"'')
      ++ (optional wrapRc
        ''--add-flags -u --add-flags "${pkgs.writeText "init.lua" customRC}"'')
      ++ (optional withSqlite 
        ''--set LIBSQLITE_CLIB_PATH "${pkgs.sqlite.out}/lib/libsqlite3.so"'')
      ++ (optional withSqlite 
        ''--set LIBSQLITE "${pkgs.sqlite.out}/lib/libsqlite3.so"'')
    );

    extraMakeWrapperLuaCArgs = optionalString (resolvedExtraLuaPackages != []) ''
      --suffix LUA_CPATH ";" "${
        lib.concatMapStringsSep ";" pkgs.luaPackages.getLuaCPath
        resolvedExtraLuaPackages
      }"'';

    extraMakeWrapperLuaArgs =
      optionalString (resolvedExtraLuaPackages != [])
      ''
        --suffix LUA_PATH ";" "${
          concatMapStringsSep ";" pkgs.luaPackages.getLuaPath
          resolvedExtraLuaPackages
        }"'';
  in
    pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped (neovimConfig
      // {
        wrapperArgs =
          escapeShellArgs neovimConfig.wrapperArgs
          + " "
          + extraMakeWrapperArgs
          + " "
          + extraMakeWrapperLuaCArgs
          + " "
          + extraMakeWrapperLuaArgs;
        wrapRc = false;
      })
