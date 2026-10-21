return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install && git checkout -- yarn.lock",
    ft = { "markdown" },
  },
}
