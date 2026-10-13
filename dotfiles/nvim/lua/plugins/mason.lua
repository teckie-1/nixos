-- LSP servers/formatters/linters are provided as Nix packages (see common.nix)
-- instead of Mason-downloaded binaries, which aren't linked for NixOS.
-- mason.nvim uses opts_extend for ensure_installed, so a plain opts table
-- here would just get appended to LazyVim's defaults - use a function to
-- actually clear it.
return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = {}
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = { ensure_installed = {} },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = { ensure_installed = {} },
  },
  -- mason=false tells LazyVim these servers are provided by a Nix package
  -- on PATH, not Mason, so it enables them directly instead of waiting on
  -- a Mason-tracked install that will never happen.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = { mason = false },
        marksman = { mason = false },
      },
    },
  },
}
