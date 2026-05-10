return {
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        -- Fix telescope for long paths
        path_display = { "filename_first" },
        -- Telescope uses Lua patterns, so we use % to escape the dot
        -- and $ to indicate the end of the file name.
        file_ignore_patterns = { "%.class$" },
      },
    },
  },
}
