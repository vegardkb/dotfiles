vim.wo.number = true
vim.wo.relativenumber = true
vim.opt["tabstop"] = 4
vim.opt["shiftwidth"] = 4
vim.cmd([[vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>]])

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
  {"rose-pine/neovim", name = "rose-pine"},
  {"MortenStabenau/matlab-vim"}	
})

vim.cmd("colorscheme rose-pine")
