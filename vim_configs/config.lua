-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
--
--
lvim.plugins = {
  "williamboman/mason.nvim",
  "mfussenegger/nvim-dap-python",
  "nvim-neotest/neotest",
  "nvim-neotest/nvim-nio",
  "nvim-neotest/neotest-python",
  "aserowy/tmux.nvim",
  -- Legacy
  "preservim/vimux",
  "janko/vim-test",
}


lvim.builtin.dap.active = true
local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
pcall(function()
 require("dap-python").setup(mason_path .. "packages/debugpy/venv/bin/python")
end)

vim.opt.mouse = ""

vim.g["test#strategy"] = "vimux"

lvim.format_on_save.enabled = true
lvim.format_on_save.pattern = { "*" }

lvim.builtin.dap.active = true

lvim.builtin.which_key.mappings["dm"] = { "<cmd>lua require('neotest').run.run()<cr>", "Test Method" }
lvim.builtin.which_key.mappings["dM"] = { "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", "Test Method DAP" }
lvim.builtin.which_key.mappings["df"] = { "<cmd>lua require('neotest').run.run({vim.fn.expand('%')})<cr>", "Test Class" }
lvim.builtin.which_key.mappings["dF"] = { "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>", "Test Class DAP" }
lvim.builtin.which_key.mappings["dS"] = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Test Summary" }

lvim.builtin.which_key.mappings["v"] = {
  name = "Vimux",
  p = { ":VimuxPromptCommand<cr>", "Run Vimux Command"},
}
lvim.builtin.which_key.mappings["r"] = {
  name = "Vimux Test",
  l = { ":VimuxRunLastCommand<cr>", "Run last command" },
  b = { ":TestFile<cr>", "Run test buffer" },
  f = { ":TestNearest<cr>", "Run nearest test" },
}
