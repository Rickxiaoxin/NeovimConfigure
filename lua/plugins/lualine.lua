return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "echasnovski/mini.icons" },
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      -- mini.icons
      require("mini.icons").setup()

      -- mock nvim-web-devicons to use mini.icons instead
      require("mini.icons").mock_nvim_web_devicons()

      require("lualine").setup(opts)
    end,
  },
}
