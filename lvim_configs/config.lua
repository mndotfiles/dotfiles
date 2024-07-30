-- Read the docs: https://www.lunarvim.org/docs/configuration
--
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
--
-- install plugins
lvim.plugins = {
  {
  "folke/tokyonight.nvim",
  "dracula/vim",
  "ChristianChiarulli/swenv.nvim",
  "stevearc/dressing.nvim",
  "mfussenegger/nvim-dap-python",
  "rcarriga/nvim-dap-ui",
  "nvim-neotest/neotest",
  "nvim-neotest/neotest-python"},
{
  "echasnovski/mini.map",
  branch = "stable",
  config = function()
    require('mini.map').setup()
    local map = require('mini.map')
    map.setup({
      integrations = {
        map.gen_integration.builtin_search(),
        map.gen_integration.diagnostic({
          error = 'DiagnosticFloatingError',
          warn  = 'DiagnosticFloatingWarn',
          info  = 'DiagnosticFloatingInfo',
          hint  = 'DiagnosticFloatingHint',
        }),
      },
      symbols = {
        encode = map.gen_encode_symbols.dot('4x2'),
      },
      window = {
        side = 'right',
        width = 20, -- set to 1 for a pure scrollbar :)
        winblend = 15,
        show_integration_count = false,
      },
    })
  end
}
}

lvim.colorscheme = "tokyonight-night"
-- automatically install python syntax highlighting
lvim.builtin.treesitter.ensure_installed = {
  "python",
}

-- setup formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup { { name = "black" }, }
lvim.format_on_save.enabled = true
lvim.format_on_save.pattern = { "*.py" }

-- setup linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup { { command = "flake8", args = { "--ignore=E203,F812,H101,H202,H233,H301,H306,H401,H403,H404,H405,H501 --max-complexity=18 --select=B,C,E,F,W,T4,B9" }, filetypes = { "python" } } }

-- setup debug adapter
lvim.builtin.dap.active = true
local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
pcall(function()
  require("dap-python").setup(mason_path .. "packages/debugpy/venv/bin/python")
end)

-- setup testing
require("neotest").setup({
  adapters = {
    require("neotest-python")({
      -- Extra arguments for nvim-dap configuration
      -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
      dap = {
        justMyCode = false,
        console = "integratedTerminal",
      },
      args = { "--log-level", "DEBUG", "--quiet" },
      runner = "pytest",
    })
  }
})

lvim.builtin.which_key.mappings["dm"] = { "<cmd>lua require('neotest').run.run()<cr>",
  "Test Method" }
lvim.builtin.which_key.mappings["dM"] = { "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>",
  "Test Method DAP" }
lvim.builtin.which_key.mappings["df"] = {
  "<cmd>lua require('neotest').run.run({vim.fn.expand('%')})<cr>", "Test Class" }
lvim.builtin.which_key.mappings["dF"] = {
  "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>", "Test Class DAP" }
lvim.builtin.which_key.mappings["dS"] = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Test Summary" }


-- binding for switching
lvim.builtin.which_key.mappings["C"] = {
  name = "Python",
  c = { "<cmd>lua require('swenv.api').pick_venv()<cr>", "Choose Env" },
}


local get_python_path = function()
  local venv_path = os.getenv('VIRTUAL_ENV')
  if venv_path then
    return venv_path .. '/bin/python'
  end
end

local enrich_config = function(config, on_config)
  if not config.pythonPath and not config.python then
    config.pythonPath = get_python_path()
  end
  on_config(config)
end

local dap = require('dap')
-- local adapter_python_path = vim.fn.expand(vim.fn.trim(adapter_python_path)) or 'python3'
dap.adapters.python = function(cb, config)
  if config.request == 'attach' then
    --@diagnostic disable-next-line: undefined-field
    local port = (config.connect or config).port
    --@diagnostic disable-next-line: undefined-field
    local host = (config.connect or config).host or '127.0.0.1'
    cb({
      type = 'server',
      port = assert(port, '`connect.port` is required for a python `attach` configuration'),
      host = host,
      enrich_config = enrich_config,
      options = {
        source_filetype = 'python',
      },
    })
  else
    cb({
      type = 'executable',
      command = 'python3',
      args = { '-m', 'debugpy.adapter' },
      enrich_config = enrich_config,
      options = {
        source_filetype = 'python',
      },
    })
  end
end

vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.list = false
