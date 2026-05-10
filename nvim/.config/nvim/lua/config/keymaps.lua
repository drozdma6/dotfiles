-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- SPOTLESS
vim.api.nvim_create_user_command("Spotless", function()
  -- 1. Notify the user that the job has started
  vim.notify("Running Gradle Spotless...", vim.log.levels.INFO)

  -- 2. Run the gradle wrapper asynchronously so Neovim doesn't freeze
  vim.fn.jobstart("./gradlew spotlessApply -x test --no-watch-fs", {
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        -- 3. If successful, notify and instantly reload the current buffer to show changes
        vim.notify("Spotless applied successfully!", vim.log.levels.INFO)
        vim.cmd("checktime") 
      else
        -- 4. If it fails (e.g., compile error), show an error notification
        vim.notify("Spotless failed! Check your code or Gradle logs.", vim.log.levels.ERROR)
      end
    end,
  })
end, { desc = "Run Gradle spotlessApply asynchronously" })

-------------------------------------------------------------------------------------------------------

-- TESTS
--
local wk = require("which-key")

wk.add({
  { "<leader>t", group = "test" }, -- This labels the <leader>t prefix as "test"
})

local function run_gradle_test(scope)
  local file_path = vim.api.nvim_buf_get_name(0)
  local root_dir = vim.fn.getcwd()
  local relative_path = file_path:sub(#root_dir + 2)

  -- 1. Calculate Module Path
  local module_path = relative_path:match("(.-)/src/")
  local gradle_task = module_path and (":" .. module_path:gsub("/", ":") .. ":test") or "test"

  -- 2. Get Package and Class Name
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local package_name = ""
  for _, line in ipairs(lines) do
    local pkg = string.match(line, "^%s*package%s+([%w%.]+)%s*;")
    if pkg then package_name = pkg break end
  end
  local class_name = vim.fn.expand("%:t:r")
  local fqn = package_name ~= "" and (package_name .. "." .. class_name) or class_name

  -- 3. Handle "Nearest Method" via Tree-sitter
  local filter = fqn
  if scope == "nearest" then
    local node = vim.treesitter.get_node()
    while node do
      if node:type() == "method_declaration" then
        local method_name = vim.treesitter.get_node_text(node:child(2), 0) -- usually index 2 is name
        filter = fqn .. "." .. method_name
        break
      end
      node = node:parent()
    end
  end

  -- 4. Construct and Run
  local gradle_cmd = string.format("./gradlew %s --tests '%s'; echo; echo 'Done. Enter to close...'; read", gradle_task, filter)
  local tmux_cmd = string.format("tmux new-window -n 'Gradle-Test' \"%s\"", gradle_cmd)
  
  os.execute(tmux_cmd)
  vim.notify("Testing: " .. filter, vim.log.levels.INFO)
end

vim.keymap.set("n", "<leader>ta", function()
  local file_path = vim.api.nvim_buf_get_name(0)
  local root_dir = vim.fn.getcwd()
  local module_path = file_path:sub(#root_dir + 2):match("(.-)/src/")
  local gradle_task = module_path and (":" .. module_path:gsub("/", ":") .. ":test") or "test"
  
  os.execute(string.format("tmux new-window -n 'All-Tests' \"./gradlew %s; read\"", gradle_task))
end, { desc = "Gradle: Run All Module Tests" })

-- Keybindings
vim.keymap.set("n", "<leader>tc", function() run_gradle_test("class") end, { desc = "Gradle: Run Current Class" })
vim.keymap.set("n", "<leader>tt", function() run_gradle_test("nearest") end, { desc = "Gradle: Run Nearest Method" })

-------------------------------------------------------------------------------------------------------
