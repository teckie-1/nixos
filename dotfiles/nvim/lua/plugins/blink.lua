return {
  "saghen/blink.cmp",
  dependencies = { "saghen/blink.lib" },
  opts = {
    keymap = {
      preset = "default",

      -- Enter always makes a new line
      ["<CR>"] = { "fallback" },

      -- Tab accepts autocomplete
      ["<Tab>"] = { "select_and_accept", "fallback" },

      -- Shift-Tab goes backward
      ["<S-Tab>"] = { "select_prev", "fallback" },
    },
  },
}
