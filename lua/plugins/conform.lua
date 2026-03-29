return {
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    lazy = true,
    cmd = "ConformInfo",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format" },
        tex = { "tex-fmt" },
        c = { "clang-format" },
        cpp = { "clang-format" },
      },
    },
  },
}
