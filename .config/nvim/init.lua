-- ======================
-- BASIC SETTINGS
-- ======================

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = false
vim.g.mapleader = " "


-- ======================
-- vim-plug
-- ======================

vim.cmd([[
call plug#begin()

Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'neovim/nvim-lspconfig'

" completion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

call plug#end()
]])

-- ======================
-- SAFE TREESITTER CONFIG
-- ======================

local ts_ok, ts = pcall(require, "nvim-treesitter.configs")
if ts_ok then
  ts.setup({
    ensure_installed = { "rust" },
    highlight = { enable = true },
  })
end

-- ======================
-- SAFE LSP (Neovim 0.11)
-- ======================

if vim.lsp then
  vim.lsp.enable("rust_analyzer")

  vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      },
      check = {
        command = "clippy",
      },
    },
  },
})

end

-- Format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rs",
  callback = function()
    vim.lsp.buf.format()
  end,
})

-- ======================
-- Telescope keymaps
-- ======================

vim.keymap.set("n", "<leader>ff", function()
  local ok, telescope = pcall(require, "telescope.builtin")
  if ok then telescope.find_files() end
end)

vim.keymap.set("n", "<leader>fg", function()
  local ok, telescope = pcall(require, "telescope.builtin")
  if ok then telescope.live_grep() end
end)


vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
-- Close floating windows with Esc
vim.keymap.set("n", "<Esc>", function()
  -- Close any floating window
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then
      vim.api.nvim_win_close(win, false)
    end
  end
end, { silent = true })

local cmp = require'cmp'

cmp.setup({
  completion = {
    autocomplete = { cmp.TriggerEvent.TextChanged }
  },

  mapping = {
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
  },

  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
  }
})
