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

require("lazy").setup {
    { "williamboman/mason.nvim", config = true },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/nvim-cmp",
        },
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-path" }, --optional
        },
        opts = {
            sources = {
                { name = "nvim_lsp" },
                { name = "path" }, --optional
            },
        },
    },
	{
      'sainnhe/sonokai',
      lazy = false,
      priority = 1000,
      config = function()
        -- Optionally configure and load the colorscheme
        -- directly inside the plugin declaration.
        vim.g.sonokai_enable_italic = true
		vim.g.sonokai_style = "atlantis"
        vim.cmd.colorscheme('sonokai')
      end
  },
  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
  {"nvim-telescope/telescope.nvim", tag = "0.1.6", dependencies = {"nvim-lua/plenary.nvim"}},
  {"nvim-telescope/telescope-fzf-native.nvim", build = "make"},
  {"VonHeikemen/lsp-zero.nvim"},
  {"williamboman/mason.nvim"},
  {"williamboman/mason-lspconfig.nvim"},
}

-- Mappings
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local buffer = args.buf
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = buffer, desc = "Hover" })
        vim.keymap.set("n", "ga", vim.lsp.buf.code_action, { buffer = buffer, desc = "Code action" })
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = buffer, desc = "Go to declaration" })
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buffer, desc = "Go to definition" })
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = buffer, desc = "Go to inplementation" })
        vim.keymap.set("n", "gr", vim.lsp.buf.rename, { buffer = buffer, desc = "Rename" })
        vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = buffer, desc = "Type definition" })
        vim.keymap.set("n", "gR", vim.lsp.buf.references, { buffer = buffer, desc = "References" })
        vim.keymap.set("n", "gk", vim.lsp.buf.signature_help, { buffer = buffer, desc = "Signature help" })
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = buffer, desc = "Next diagnostic" })
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = buffer, desc = "Prev diagnostic" })
        vim.keymap.set("n", "gf", function()
            vim.lsp.buf.format {
                timeout_ms = 5000,
            }
        end, { buffer = 0, desc = "Format buffer" })
    end,
})
require('nvim-treesitter.configs').setup {
  ensure_installed = {"c", "lua", "vim", "vimdoc", "query", "matlab", "python"},
  higlight = {
	  enable = true,
  }
}

local lsp = require('lsp-zero')
lsp.on_attach(function(clinet,bufnr)
	lsp.default_keymaps({buffer = bufnr})
end)

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		'matlab_ls'
	},
	handlers = {
		lsp.default_setup,
		matlab_ls = function()
			require('lspconfig').matlab_ls.setup({
				filetypes = {"matlab"},
				settings = {
					matlab = {
						installPath = "/Applications/"
					},
				},
				single_file_support = true
			})
		end,
	},
})
require("lspconfig").matlab_ls.setup{}

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
