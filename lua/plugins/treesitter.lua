---@param callback fun()
local function build(callback)
  if vim.fn.executable("tree-sitter") == 1 then
    return callback()
  end

  local mr = require("mason-registry")
  if mr.is_installed("tree-sitter-cli") then
    return callback()
  end

  mr.refresh(function()
    local p = mr.get_package("tree-sitter-cli")
    p:install(
      nil,
      vim.schedule_wrap(function()
        callback()
      end)
    )
  end)
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    version = false, -- last release is way too old and doesn't work on Windows
    event = "VeryLazy",
    build = function()
      build(function()
        local ts = require("nvim-treesitter")
        ts.update(nil, { summary = true })
      end)
    end,
    opts = {
      ensure_installed = {
        "c",
        "lua",
        "markdown",
        "markdown_inline",
        "query",
        "vim",
        "vimdoc",
        "python",
      },
    },
    config = function(_, opts)
      local ts = require("nvim-treesitter")
      local installed = ts.get_installed("parsers")
      local need_installed = vim
        .iter(opts.ensure_installed)
        :filter(function(parser)
          return not vim.tbl_contains(installed, parser)
        end)
        :totable()
      if #need_installed > 0 then
        build(function()
          ts.install(need_installed, { summary = true })
        end)
      end
    end,
  },
}
