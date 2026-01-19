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

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          local filetype = vim.api.nvim_get_option_value("filetype", { buf = ev.buf })
          local lang = vim.treesitter.language.get_lang(filetype)
          if not vim.tbl_contains(opts.ensure_installed, lang) then
            return
          end

          -- syntax highlighting, provided by Neovim
          vim.treesitter.start(ev.buf)
          -- folds, provided by Neovim
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo.foldmethod = "expr"
          -- indentation, provided by nvim-treesitter
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
