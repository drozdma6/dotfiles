local themes = {
  { text = "Carbonfox",            nvim = "carbonfox",            ghostty = "Carbonfox" },
  { text = "Nightfox",             nvim = "nightfox",             ghostty = "Nightfox" },
  { text = "Nordfox",              nvim = "nordfox",              ghostty = "Nordfox" },
  { text = "Dawnfox",              nvim = "dawnfox",              ghostty = "Dawnfox" },
  { text = "Dayfox",               nvim = "dayfox",               ghostty = "Dayfox" },
  { text = "Duskfox",              nvim = "duskfox",              ghostty = "Duskfox" },
  { text = "Terafox",              nvim = "terafox",              ghostty = "Terafox" },
  { text = "Catppuccin Latte",     nvim = "catppuccin-latte",     ghostty = "catppuccin-latte" },
  { text = "Catppuccin Frappe",    nvim = "catppuccin-frappe",    ghostty = "catppuccin-frappe" },
  { text = "Catppuccin Macchiato", nvim = "catppuccin-macchiato", ghostty = "catppuccin-macchiato" },
  { text = "Catppuccin Mocha",     nvim = "catppuccin-mocha",     ghostty = "catppuccin-mocha" },
}

local function write_ghostty_theme(name)
  local path = vim.fn.expand("~/.config/ghostty/config")
  local lines = vim.fn.readfile(path)
  local out = {}
  local found = false
  for _, line in ipairs(lines) do
    if line:match("^theme%s*=") then
      table.insert(out, "theme = " .. name)
      found = true
    else
      table.insert(out, line)
    end
  end
  if not found then
    table.insert(out, "theme = " .. name)
  end
  vim.fn.writefile(out, path)
end

return {
  { "catppuccin/nvim", name = "catppuccin", lazy = false, priority = 1000 },
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>uT",
        function()
          Snacks.picker.select(
            vim.tbl_map(function(t) return { text = t.text, data = t } end, themes),
            { prompt = "Theme" },
            function(item)
              if not item then return end
              vim.cmd.colorscheme(item.data.nvim)
              write_ghostty_theme(item.data.ghostty)
            end
          )
        end,
        desc = "Theme Picker",
      },
    },
  },
}
