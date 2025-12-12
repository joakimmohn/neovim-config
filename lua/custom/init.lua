-- lua/custom/keymaps.lua
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Fast saving with <Leader>w
keymap("n", "<Leader>w", ":w<CR>", opts)

-- Quit with <Leader>q
keymap("n", "<Leader>q", ":q<CR>", opts)

-- Clear search highlighting with <Esc>
keymap("n", "<Esc>", ":nohlsearch<CR>", opts)

-- Better window navigation
-- Instead of Ctrl-w + h, just use Ctrl-h
keymap("n", "<C-h>", "<C-w>h", opts) -- Left
keymap("n", "<C-j>", "<C-w>j", opts) -- Down
keymap("n", "<C-k>", "<C-w>k", opts) -- Up
keymap("n", "<C-l>", "<C-w>l", opts) -- Right

-- lua/custom/options.lua
local opt = vim.opt

-- Line numbers
opt.number = true           -- Show absolute line number
opt.relativenumber = true   -- Show relative line numbers (great for jumps)

-- Indentation
opt.tabstop = 4             -- Number of spaces tabs count for
opt.shiftwidth = 4          -- Size of an indent
opt.expandtab = true        -- Use spaces instead of tabs
opt.smartindent = true      -- Insert indents automatically

-- UI Config
opt.termguicolors = true    -- True color support
opt.cursorline = true       -- Highlight the current line
opt.scrolloff = 8           -- Keep 8 lines above/below cursor when scrolling
opt.signcolumn = "yes"      -- Always show the sign column (prevents text shift)

-- Search
opt.ignorecase = true       -- Ignore case when searching...
opt.smartcase = true        -- ...unless you type a capital letter

-- Clipboard
-- Sync with system clipboard (requires xclip or wl-clipboard on Linux)
opt.clipboard:append("unnamedplus")

-- lua/custom/plugins.lua

-- 1. Bootstrap Lazy.nvim (Download if missing)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 2. Define Plugins
require("lazy").setup({

    -- Theme: Gruvbox
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme gruvbox]])
        end
    },

    -- File Finder (Telescope)
    -- This uses the 'ripgrep' you installed via Ansible
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.find_files, {}) -- Find files
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})  -- Grep text (using ripgrep)
            vim.keymap.set('n', '<leader>fb', builtin.buffers, {})    -- Find buffers
        end
    },

    -- Syntax Highlighting (Treesitter)
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python", "yaml" },
                highlight = { enable = true },
            })
        end
    }
})