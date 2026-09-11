-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
--
-- install plugins
lvim.plugins = {
  {
  "folke/tokyonight.nvim",
  "mfussenegger/nvim-dap-python",
  "nvim-neotest/neotest",
  "nvim-neotest/nvim-nio",
  "nvim-neotest/neotest-python"},
  "aserowy/tmux.nvim",
  -- Legacy
  "preservim/vimux",
  "janko/vim-test",
  -- AI
    "nvim-lua/plenary.nvim", -- Required for git operations
  {
  "greggh/claude-code.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required for git operations
  },
  config = function()

require("claude-code").setup({
  -- Terminal window settings
  window = {
    split_ratio = 0.3,      -- Percentage of screen for the terminal window (height for horizontal, width for vertical splits)
    position = "botright",  -- Position of the window: "botright", "topleft", "vertical", "float", etc.
    enter_insert = true,    -- Whether to enter insert mode when opening Claude Code
    hide_numbers = true,    -- Hide line numbers in the terminal window
    hide_signcolumn = true, -- Hide the sign column in the terminal window

    -- Floating window configuration (only applies when position = "float")
    float = {
      width = "80%",        -- Width: number of columns or percentage string
      height = "80%",       -- Height: number of rows or percentage string
      row = "center",       -- Row position: number, "center", or percentage string
      col = "center",       -- Column position: number, "center", or percentage string
      relative = "editor",  -- Relative to: "editor" or "cursor"
      border = "rounded",   -- Border style: "none", "single", "double", "rounded", "solid", "shadow"
    },
  },
  -- File refresh settings
  refresh = {
    enable = true,           -- Enable file change detection
    updatetime = 100,        -- updatetime when Claude Code is active (milliseconds)
    timer_interval = 1000,   -- How often to check for file changes (milliseconds)
    show_notifications = true, -- Show notification when files are reloaded
  },
  -- Git project settings
  git = {
    use_git_root = true,     -- Set CWD to git root when opening Claude Code (if in git project)
  },
  -- Shell-specific settings
  shell = {
    separator = '&&',        -- Command separator used in shell commands
    pushd_cmd = 'pushd',     -- Command to push directory onto stack (e.g., 'pushd' for bash/zsh, 'enter' for nushell)
    popd_cmd = 'popd',       -- Command to pop directory from stack (e.g., 'popd' for bash/zsh, 'exit' for nushell)
  },
  -- Command settings
  command = "claude",        -- Command used to launch Claude Code
  -- Command variants
  command_variants = {
    -- Conversation management
    continue = "--continue", -- Resume the most recent conversation
    resume = "--resume",     -- Display an interactive conversation picker

    -- Output options
    verbose = "--verbose",   -- Enable verbose logging with full turn-by-turn output
  },
  -- Keymaps
  keymaps = {
    toggle = {
      normal = "<C-,>",       -- Normal mode keymap for toggling Claude Code, false to disable
      terminal = "<C-,>",     -- Terminal mode keymap for toggling Claude Code, false to disable
      variants = {
        continue = "<leader>cC", -- Normal mode keymap for Claude Code with continue flag
        verbose = "<leader>cV",  -- Normal mode keymap for Claude Code with verbose flag
      },
    },
    use_which_key = false,
    window_navigation = true, -- Enable window navigation keymaps (<C-h/j/k/l>)
    scrolling = true,         -- Enable scrolling keymaps (<C-f/b>) for page up/down
  }
})

  end

}
}

lvim.colorscheme = "tokyonight-night"
-- automatically install python syntax highlighting
lvim.builtin.treesitter.ensure_installed = {
  "python",
}

-- setup debug adapter
lvim.builtin.dap.active = true
local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
pcall(function()
  require("dap-python").setup(mason_path .. "packages/debugpy/venv/bin/python")
end)

vim.g["test#strategy"] = "vimux"
-- add `pyright` to `skipped_servers` list
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "jedi_language_server, pyright" })
-- remove `jedi_language_server` from `skipped_servers` list
-- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
--   return server ~= "jedi_language_server"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- setup formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup { 
  { name = "ruff" },
  {name = "prettier"},
}
lvim.format_on_save.enabled = true
lvim.format_on_save.pattern = { "*.tsx", "*.js", "*.jsx", "*.ts" }
lvim.format_on_save.timeout = 5

-- setup linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup { { name = "ruff" } }


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

lvim.builtin.which_key.mappings["v"] = {
  name = "Vimux",
  p = { ":VimuxPromptCommand<cr>", "Run vimux"},
}

lvim.builtin.which_key.mappings["r"] = {
  name = "Vimux Tests",
  l = { ":VimuxRunLastCommand<cr>", "Run last command" },
  b = { ":TestFile<cr>", "Run test buffer" },
  f = { ":TestNearest<cr>", "Run nearest file" },
}

-- -- binding for switching
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

-- gitsigns: reduce git diff frequency on large repos
lvim.builtin.gitsigns.opts.update_debounce = 3000
lvim.builtin.gitsigns.opts.watch_gitdir = {
  enable = false,
  follow_files = true,
}

vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.list = false
