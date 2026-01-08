return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    version = false, -- last release is way too old and doesn't work on Windows
    event = "VeryLazy",
    build = function()
      local mr = require("mason-registry")
      if not mr.is_installed("tree-sitter-cli") then
        local p = mr.get_package("tree-sitter-cli")
        p:install()
      end
      local TS = require("nvim-treesitter")
      TS.update(nil, { summary = true })
    end,
    opts = {},
  },
}
