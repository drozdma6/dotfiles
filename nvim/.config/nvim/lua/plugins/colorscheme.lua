return {
  -- Add the nightfox plugin
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000, -- Ensure it loads before other plugins
    config = function()
      -- Optional: Add specific configurations for carbonfox here
      require("nightfox").setup({
        options = {
          transparent = false, -- Set to true if you want a transparent background
          styles = {
            comments = "italic",
          },
        },
      })
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "carbonfox",
    },
  },
}
