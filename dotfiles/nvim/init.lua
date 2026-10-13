-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "~/Documents/Notes/*",
  callback = function()
    vim.bo.filetype = "markdown"
  end,
})
