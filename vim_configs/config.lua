-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
--
--
lvim.colorscheme = "solarized"

AI_INTEGRATION = true
TRAINING_WHEELS = true
vim.g.claude_use_bedrock = 1
vim.fn.setenv("AWS_REGION", "us-east-1")
vim.g.claude_helper_program = "~/.local/share/claude_helpers/claude_bedrock_helper.py"
vim.g.claude_system_prompt = "~/.local/share/claude_helpers/claude_system_prompt.md"

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
  { "ishan9299/nvim-solarized-lua" },

  --disabled builtins
  { "hrsh7th/nvim-cmp",            enabled = not AI_INTEGRATION },
  { "hrsh7th/cmp-nvim-lsp",        enabled = not AI_INTEGRATION },
  { "hrsh7th/cmp-buffer",          enabled = not AI_INTEGRATION },
  { "hrsh7th/cmp-path",            enabled = not AI_INTEGRATION },
  { "hrsh7th/cmp-cmdline",         enabled = not AI_INTEGRATION },
  { "saadparwaiz1/cmp_luasnip",    enabled = not AI_INTEGRATION },
  { "L3MON4D3/LuaSnip",            enabled = not AI_INTEGRATION },

  --UI
  {
    'wfxr/minimap.vim',
    build = "cargo install --locked code-minimap",
    lazy = false,
    cmd = { "Minimap", "MinimapClose", "MinimapToggle", "MinimapRefresh", "MinimapUpdateHighlight" },
    config = function()
      vim.cmd("let g:minimap_width = 10")
      vim.cmd("let g:minimap_auto_start_win_enter = 1")
    end,
  },
  {
    "itchyny/vim-cursorword",
    event = { "BufEnter", "BufNewFile" },
    config = function()
      vim.api.nvim_command("augroup user_plugin_cursorword")
      vim.api.nvim_command("autocmd!")
      vim.api.nvim_command("autocmd FileType NvimTree,lspsagafinder,dashboard,vista let b:cursorword = 0")
      vim.api.nvim_command("autocmd WinEnter * if &diff || &pvw | let b:cursorword = 0 | endif")
      vim.api.nvim_command("autocmd InsertEnter * let b:cursorword = 0")
      vim.api.nvim_command("autocmd InsertLeave * let b:cursorword = 1")
      vim.api.nvim_command("augroup END")
    end
  },
  { "mrjones2014/nvim-ts-rainbow" },
  { "stevearc/dressing.nvim" },
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup()
    end,
  },
  {
    "epwalsh/pomo.nvim",
    version = "*", -- Recommended, use latest release instead of latest commit
    lazy = false,
    cmd = { "TimerStart", "TimerRepeat", "TimerSession" },
  },

  --functionality/navigation
  {
    "tris203/precognition.nvim",
    --event = "VeryLazy",
    enabled = TRAINING_WHEELS,
    opts = {
      startVisible = true,
      showBlankVirtLine = false,
      highlightColor = { link = "Comment" },
      hints = {
        Caret = { text = "^", prio = 2 },
        Dollar = { text = "$", prio = 1 },
        MatchingPair = { text = "%", prio = 5 },
        Zero = { text = "0", prio = 1 },
        w = { text = "w", prio = 10 },
        b = { text = "b", prio = 9 },
        e = { text = "e", prio = 8 },
        W = { text = "W", prio = 7 },
        B = { text = "B", prio = 6 },
        E = { text = "E", prio = 5 },
      },
      gutterHints = {
        G = { text = "G", prio = 10 },
        gg = { text = "gg", prio = 9 },
        PrevParagraph = { text = "{", prio = 8 },
        NextParagraph = { text = "}", prio = 8 },
      },
      disabled_fts = {
        --     "startify",
      },
    },
  },
  { "chentoast/marks.nvim" },

  {
    "Pocco81/auto-save.nvim",
    config = function()
      require("auto-save").setup()
    end,
  },
  {
    "AlejandroSuero/freeze-code.nvim",
    config = function()
      require("freeze-code").setup({
        opts = {
          freeze_path = vim.fn.exepath("freeze"), -- where is freeze installed
          copy_cmd = "",                          -- the default copy command is native to your OS (see below)
          copy = false,                           -- copy after screenshot option
          open = false,                           -- open after screenshot option
          dir = vim.env.PWD .. "/Documents",      -- where is the image going to be saved "." as default
          freeze_config = {                       -- configuration options for `freeze` command
            output = "freeze.png",
            config = "base",
            theme = "dracula",
          },
        }
      })
    end,
  },
  {
    'ChuufMaster/buffer-vacuum',
    opts = {
      max_buffers = 6,
      enable_messages = false,
    }
  },
  --git
  {
    'SuperBo/fugit2.nvim',
    opts = {
      width = 70,
      external_diffview = true, -- tell fugit2 to use diffview.nvim instead of builtin implementation.
    },
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
      'nvim-lua/plenary.nvim',
      {
        'chrisgrieser/nvim-tinygit', -- optional: for Github PR view
        dependencies = { 'stevearc/dressing.nvim' }
      },
    },
    cmd = { 'Fugit2', 'Fugit2Blame', 'Fugit2Diff', 'Fugit2Graph' },
    keys = {
      { '<leader>F', mode = 'n', '<cmd>Fugit2<cr>' }
    }
  },
  {
    "f-person/git-blame.nvim",
    event = "BufRead",
    config = function()
      vim.cmd "highlight default link gitblame SpecialComment"
      require("gitblame").setup { enabled = true }
    end,
  },
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    -- lazy, only load diffview by these commands
    cmd = {
      'DiffviewFileHistory', 'DiffviewOpen', 'DiffviewToggleFiles', 'DiffviewFocusFiles', 'DiffviewRefresh'
    }
  },
}
ai_plugins = {
  {
    'ggml-org/llama.vim',
    lazy = false,
    config = function()
      vim.g.llama_config.keymap_accept_full = "<M-Tab"
      vim.g.llama_config.auto_fim = false
    end
  },
  {
    "pasky/claude.vim",
    lazy = false,
    config = function()
      -- Add keymaps (the default conflict with NVChad.  Skip if you want)
      vim.keymap.set("v", "<leader>Ci", ":'<,'>ClaudeImplement ", { noremap = true, desc = "Claude Implement" })
      vim.keymap.set("n", "<leader>Cc", ":ClaudeChat<CR>", { noremap = true, silent = true, desc = "Claude Chat" })
    end,
  },
}
if AI_INTEGRATION then
  for _, ai_plugin in ipairs(ai_plugins) do
    table.insert(lvim.plugins, ai_plugin)
  end
  --autocomplete text
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
      vim.api.nvim_set_hl(0, "llama_hl_hint", { fg = "#67777c", bg = "#073642" })
      vim.api.nvim_set_hl(0, "llama_hl_info", { fg = "#d1ee42", bg = "#073642" })
    end,
  })

  vim.g.claude_use_bedrock = 1
  vim.fn.setenv("AWS_REGION", "us-east-1")
  vim.g.claude_helper_program = "~/.local/share/claude_helpers/claude_bedrock_helper.py"
  vim.g.claude_system_prompt = "~/.local/share/claude_helpers/claude_system_prompt.md"
  --vim.g.llama_config.endpoint= "http://127.0.0.1:8012"
end
-- end plugins


vim.opt.fillchars = { eob = " " }


vim.g.minimap_auto_start = 1


lvim.builtin.which_key.mappings["sa"] = {
  "<cmd>:Telescope live_grep<CR>", "Live grep"
}
lvim.builtin.dap.active = true
local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
pcall(function()
  require("dap-python").setup(mason_path .. "packages/debugpy/venv/bin/python")
end)


vim.g["test#strategy"] = "vimux"
vim.g["test#python#runner"] = "pytest"
--lvim.format_on_save.enabled = true
--lvim.format_on_save.pattern = { "*" }

lvim.builtin.dap.active = true

lvim.builtin.which_key.mappings["dm"] = { "<cmd>lua require('neotest').run.run()<cr>", "Test Method" }
lvim.builtin.which_key.mappings["dM"] = { "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>",
  "Test Method DAP" }
lvim.builtin.which_key.mappings["df"] = { "<cmd>lua require('neotest').run.run({vim.fn.expand('%')})<cr>", "Test Class" }
lvim.builtin.which_key.mappings["dF"] = {
  "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>", "Test Class DAP" }
lvim.builtin.which_key.mappings["dS"] = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Test Summary" }

lvim.builtin.which_key.mappings["v"] = {
  name = "Vimux",
  p = { ":VimuxPromptCommand<cr>", "Run Vimux Command" },
}
lvim.builtin.which_key.mappings["r"] = {
  name = "Vimux Test",
  l = { ":VimuxRunLastCommand<cr>", "Run last command" },
  b = { ":TestFile<cr>", "Run test buffer" },
  f = { ":TestNearest<cr>", "Run nearest test" },
}
local augroup = vim.api.nvim_create_augroup("DisableLlamaVimInFloating", { clear = true })
-- Detect floating windows on BufEnter
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup,
  pattern = "*",
  callback = function()
    -- Check if the buffer is in a floating window
    local buftype = vim.bo.buftype
    local is_floating = vim.api.nvim_win_get_config(0).relative ~= ""
    if is_floating or buftype == "prompt" or buftype == "nofile" or buftype == "popup" then
      -- Disable completion (affects plugins like llama.vim if they use completion)
      vim.opt_local.completeopt = { "menu", "menuone", "noselect" }
      vim.opt_local.complete = "" -- Disable completion sources
      vim.cmd("LlamaDisable")

      -- Hypothetical: Disable specific plugins using buffer-local variables
      -- Optionally, remove plugin-specific keymaps (e.g., if plugin uses <Tab>)
    else
      -- Restore settings for non-floating windows
      vim.opt_local.completeopt = { "menu", "menuone", "noselect", "noinsert" }
      vim.opt_local.complete = ".,w,b,u,t,i"
      vim.cmd("LlamaEnable")
    end
  end,
})
