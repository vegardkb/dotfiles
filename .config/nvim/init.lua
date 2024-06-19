vim.wo.number = true
vim.wo.relativenumber = true
vim.opt["tabstop"] = 4
vim.opt["shiftwidth"] = 4
vim.cmd([[vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>]])

vim.g.mapleader = ';'
vim.g.maplocalleader = ';'

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {"sainnhe/sonokai", name = "sonokai"},
  {"MortenStabenau/matlab-vim"},
  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
  {"nvim-telescope/telescope.nvim", tag = "0.1.6", dependencies = {"nvim-lua/plenary.nvim"}},
  {"nvim-telescope/telescope-fzf-native.nvim", build = "make"},
})

 vim.cmd("colorscheme sonokai")

require('nvim-treesitter.configs').setup {
  ensure_installed = {"c", "lua", "vim", "vimdoc", "query", "matlab", "python"},
  higlight = {
	  enable = true,
  }
}

require('telescope').setup {
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		}
	}
}

require('telescope').load_extension('fzf')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
