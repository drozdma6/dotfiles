-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd({ "FocusLost", "BufLeave", "WinLeave", "InsertLeave" }, {
  group = augroup("auto_save_all", { clear = true }),
  callback = function()
    -- ':wa' (write all) saves every modified buffer instantly.
    -- It completely bypasses the need to track individual buffer IDs.
    vim.cmd("silent! wa")
  end,
})
