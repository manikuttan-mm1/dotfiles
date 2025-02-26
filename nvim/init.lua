-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = false
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 20

-- Tabsetup
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Set the GUI font for Neovim or Vim
vim.opt.guifont = 'JetBrainsMono Nerd Font:style=Thin Italic:h12'

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- buffer keymaps
vim.keymap.set('n', '<leader>q', ':bd<CR>', { desc = 'Deletes the current buffer', silent = true })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup {
  spec = {
    -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
    'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
    -- NOTE: Plugins can also be added by using a table,
    -- with the first argument being the link and the following
    -- keys can be used to configure plugin behavior/loading/etc.
    --
    -- Use `opts = {}` to force a plugin to be loaded.
    --
    --  This is equivalent to:
    --    require('Comment').setup({})

    -- "gc" to comment visual regions/lines
    { 'numToStr/Comment.nvim', opts = {} },

    -- Here is a more advanced example where we pass configuration
    -- options to `gitsigns.nvim`. This is equivalent to the following Lua:
    --    require('gitsigns').setup({ ... })
    --
    -- See `:help gitsigns` to understand what the configuration keys do
    { -- Adds git related signs to the gutter, as well as utilities for managing changes
      'lewis6991/gitsigns.nvim',
      opts = {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
      },
    },

    -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
    --
    -- This is often very useful to both group configuration, as well as handle
    -- lazy loading plugins that don't need to be loaded immediately at startup.
    --
    -- For example, in the following configuration, we use:
    --  event = 'VimEnter'
    --
    -- which loads which-key before all the UI elements are loaded. Events can be
    -- normal autocommands events (`:help autocmd-events`).
    --
    -- Then, because we use the `config` key, the configuration only runs
    -- after the plugin has been loaded:
    --  config = function() ... end

    { -- Useful plugin to show you pending keybinds.
      'folke/which-key.nvim',
      event = 'VimEnter', -- Sets the loading event to 'VimEnter'
      config = function() -- This is the function that runs, AFTER loading
        require('which-key').setup()

        -- Document existing key chains
        require('which-key').add {
          { '<leader>c', group = '[C]ode' },
          { '<leader>c_', hidden = true },
          { '<leader>d', group = '[D]ocument' },
          { '<leader>d_', hidden = true },
          { '<leader>h', group = 'Git [H]unk', mode = 'v' },
          { '<leader>h_', hidden = true },
          { '<leader>r', group = '[R]ename' },
          { '<leader>r_', hidden = true },
          { '<leader>s', group = '[S]earch' },
          { '<leader>s_', hidden = true },
          { '<leader>w', group = '[W]orkspace' },
          { '<leader>w_', hidden = true },
        }

        -- {
        --   ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
        --   ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
        --   ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
        --   ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
        --   ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
        --   ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
        --   ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
        -- }
        -- -- visual mode
        -- require('which-key').add {
        --   { '<leader>h', desc = 'Git [H]unk', mode = 'v' },
        -- }
      end,
    },

    -- NOTE: Plugins can specify dependencies.
    --
    -- The dependencies are proper plugin specifications as well - anything
    -- you do for a plugin at the top level, you can do for a dependency.
    --
    -- Use the `dependencies` key to specify the dependencies of a particular plugin

    { -- Fuzzy Finder (files, lsp, etc)
      'nvim-telescope/telescope.nvim',
      event = 'VimEnter',
      branch = '0.1.x',
      dependencies = {
        'nvim-lua/plenary.nvim',
        { -- If encountering errors, see telescope-fzf-native README for installation instructions
          'nvim-telescope/telescope-fzf-native.nvim',

          -- `build` is used to run some command when the plugin is installed/updated.
          -- This is only run then, not every time Neovim starts up.
          build = 'make',

          -- `cond` is a condition used to determine whether this plugin should be
          -- installed and loaded.
          cond = function()
            return vim.fn.executable 'make' == 1
          end,
        },
        { 'nvim-telescope/telescope-ui-select.nvim' },

        -- Useful for getting pretty icons, but requires a Nerd Font.
        { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
        {
          'nvim-telescope/telescope-frecency.nvim',
          config = function()
            require('telescope').load_extension 'frecency'
          end,
        },
      },
      config = function()
        -- Telescope is a fuzzy finder that comes with a lot of different things that
        -- it can fuzzy find! It's more than just a "file finder", it can search
        -- many different aspects of Neovim, your workspace, LSP, and more!
        --
        -- The easiest way to use Telescope, is to start by doing something like:
        --  :Telescope help_tags
        --
        -- After running this command, a window will open up and you're able to
        -- type in the prompt window. You'll see a list of `help_tags` options and
        -- a corresponding preview of the help.
        --
        -- Two important keymaps to use while in Telescope are:
        --  - Insert mode: <c-/>
        --  - Normal mode: ?
        --
        -- This opens a window that shows you all of the keymaps for the current
        -- Telescope picker. This is really useful to discover what Telescope can
        -- do as well as how to actually do it!

        -- [[ Configure Telescope ]]
        -- See `:help telescope` and `:help telescope.setup()`
        require('telescope').setup {
          -- You can put your default mappings / updates / etc. in here
          --  All the info you're looking for is in `:help telescope.setup()`
          --
          -- defaults = {
          --   mappings = {
          --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
          --   },
          -- },
          -- pickers = {}
          extensions = {
            ['ui-select'] = {
              require('telescope.themes').get_dropdown(),
            },
          },
        }

        -- Enable Telescope extensions if they are installed
        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'ui-select')

        -- See `:help telescope.builtin`
        local builtin = require 'telescope.builtin'
        vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
        vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
        vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
        vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
        vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
        vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
        vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
        -- vim.keymap.set('n', '<leader>sp', require('telescope.builtin').registers, { desc = '[S]earch [S]tored Registers' })

        -- Updated Remaps
        local extension = require('telescope').extensions
        vim.keymap.set('n', '<leader>ff', function()
          extension.frecency.frecency {
            workspace = 'CWD',
          }
        end, { desc = '[F]ind [F]iles' })
        vim.keymap.set('n', '<leader><leader>', function()
          builtin.buffers {
            ignore_current_buffer = true,
            only_cwd = true,
            sort_mru = true,
          }
        end, { desc = '[ ] Find existing buffers' })
        vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[F]ind current [W]ord' })

        -- Slightly advanced example of overriding default behavior and theme
        vim.keymap.set('n', '<leader>/', function()
          -- You can pass additional configuration to Telescope to change the theme, layout, etc.
          builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
          })
        end, { desc = '[/] Fuzzily search in current buffer' })

        -- It's also possible to pass additional configuration options.
        --  See `:help telescope.builtin.live_grep()` for information about particular keys
        vim.keymap.set('n', '<leader>s/', function()
          builtin.live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
          }
        end, { desc = '[S]earch [/] in Open Files' })

        -- Shortcut for searching your Neovim configuration files
        vim.keymap.set('n', '<leader>sn', function()
          builtin.find_files { cwd = vim.fn.stdpath 'config' }
        end, { desc = '[S]earch [N]eovim files' })
      end,
    },

    { -- Autoformat
      'stevearc/conform.nvim',
      lazy = false,
      keys = {
        {
          '<leader>fb',
          function()
            require('conform').format { async = true, lsp_fallback = true }
          end,
          mode = '',
          desc = '[F]ormat buffer',
        },
      },
      opts = {
        notify_on_error = false,
        format_on_save = function(bufnr)
          -- Disable "format_on_save lsp_fallback" for languages that don't
          -- have a well standardized coding style. You can add additional
          -- languages here or re-enable it for the disabled ones.
          local disable_filetypes = { c = true, cpp = true }
          return {
            timeout_ms = 500,
            lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
          }
        end,
        formatters_by_ft = {
          lua = { 'stylua' },
          go = { 'goimports' },
          sh = { 'shfmt' },
          proto = { 'buf' },
          -- Conform can also run multiple formatters sequentially
          -- python = { "isort", "black" },
          --
          -- You can use a sub-list to tell conform to run *until* a formatter
          -- is found.
          javascript = { { 'prettierd', 'prettier' } },
          svelte = { 'prettier' },
        },
      },
    },
    -- setup must be called before loading
    { 'rebelot/kanagawa.nvim' },
    -- Catppuccin colorscheme configuration
    {
      'catppuccin/nvim',
      name = 'catppuccin',
      lazy = false,
      priority = 1000, -- Load this before other start plugins
      opts = {
        -- transparent_background = t"::rue, -- Enable transparent background for Catppuccin
        transparent_background = false, -- Enable transparent background for Catppuccin
      },
      -- init = function()
      --   -- Default colorscheme is catppuccin
      --   -- vim.cmd.colorscheme 'catppuccin'
      -- end,
    },

    -- Dracula colorscheme configuration
    {
      'Mofiqul/dracula.nvim',
      lazy = false,
      priority = 1000, -- Load this before other start plugins
      opts = {
        -- transparent_bg = true, -- Enable transparent background for Dracula
        transparent_bg = false, -- Enable transparent background for Dracula
      },
      init = function()
        -- Load Dracula colorscheme by calling: `vim.cmd.colorscheme 'dracula'`
        vim.cmd.colorscheme 'dracula'
      end,
    },
    -- Add Gruvbox theme
    { 'morhetz/gruvbox', lazy = false, priority = 1000 }, -- Lazy-load disabled, so it loads on startup

    -- Add TokyoNight theme
    { 'folke/tokyonight.nvim', lazy = false, priority = 1000 },
    -- Highlight todo, notes, etc in comments
    -- TODO:
    {
      'folke/todo-comments.nvim',
      event = 'VimEnter',
      dependencies = { 'nvim-lua/plenary.nvim' },
      opts = {
        signs = false,
      },
    },
    {
      'zbirenbaum/copilot.lua',
      cmd = 'Copilot',
      event = 'InsertEnter',
      config = function()
        require('copilot').setup {}
      end,
    },
    -- The follow  ing two comments only work if you have downloaded the kickstart repo, not just copy pasted the
    -- init.lua. If you want these files, they are in the repository, so you can just download them and
    -- place them in the correct locations.

    -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
    --
    --  Here are some example plugins that I've included in the Kickstart repository.
    --  Uncomment any of the lines below to enable them (you will need to restart nvim).
    --
    -- require 'kickstart.plugins.debug',
    require 'kickstart.plugins.indent_line',
    -- require 'kickstart.plugins.lint',
    require 'kickstart.plugins.autopairs',
    require 'kickstart.plugins.neo-tree',
    require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

    -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
    --    This is the easiest way to modularize your config.
    --
    --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
    --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
    { import = 'custom.plugins' },
    -- Add the Nightfox colorscheme plugin
    {
      'EdenEast/nightfox.nvim',
    }, -- lazy

    {
      'mg979/vim-visual-multi',
      branch = 'master',
    },
    {
      'jiaoshijie/undotree',
      dependencies = 'nvim-lua/plenary.nvim',
      config = true,
      keys = { -- load the plugin only when using it's keybinding:
        { '<leader>u', "<cmd>lua require('undotree').toggle()<cr>" },
      },
    },
    -- lazy
    {
      'askfiy/visual_studio_code',
      priority = 100,
      config = function()
        require('visual_studio_code').setup {
          mode = 'light', -- `dark` or `light`
          preset = true, -- Load all color schemes
          transparent = false, -- Background transparency
          expands = {
            hop = true,
            dbui = true,
            lazy = true,
            aerial = true,
            null_ls = true,
            nvim_cmp = true,
            gitsigns = true,
            which_key = true,
            nvim_tree = true,
            lspconfig = true,
            telescope = true,
            bufferline = true,
            nvim_navic = true,
            nvim_notify = true,
            vim_illuminate = true,
            nvim_treesitter = true,
            nvim_ts_rainbow = true,
            nvim_scrollview = true,
            nvim_ts_rainbow2 = true,
            indent_blankline = true,
            vim_visual_multi = true,
          },
          hooks = {
            before = function(conf, colors, utils) end,
            after = function(conf, colors, utils) end,
          },
        }
        -- vim.cmd [[colorscheme visual_studio_code]]
      end,
    },
  },
  change_detection = {
    notify = false,
  },
}
--   {
--   ui = {
--     -- If you are using a Nerd Font: set icons to an empty table which will use the
--     -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
--     icons = vim.g.have_nerd_font and {} or {
--       cmd = '⌘',
--       config = '🛠',
--       event = '📅',
--       ft = '📂',
--       init = '⚙',
--       keys = '🗝',
--       plugin = '🔌',
--       runtime = '💻',
--       require = '🌙',
--       source = '📄',
--       start = '🚀',
--       task = '📌',
--       lazy = '💤 ',
--     },
--   },
-- })

-- require('lazy').setup('custom.plugins', {
--   change_detection = false,
-- })
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

--- Set by manikuttan
vim.api.nvim_set_keymap('n', 'G', 'Gzz', { noremap = true })
vim.api.nvim_set_keymap('n', 'N', 'Nzz', { noremap = true })
vim.api.nvim_set_keymap('n', '.', 'f.l', { noremap = true })
vim.api.nvim_set_keymap('n', '?', '.', { noremap = true })
-- Use indentation for folding
-- Set foldmethod to 'manual' to prevent automatic folding
vim.o.foldmethod = 'indent'

-- Set foldlevel to a large number to ensure all folds are unfolded
vim.o.foldlevel = 99

-- Disable default suspend action
vim.api.nvim_set_keymap('', '<C-z>', '<Nop>', { noremap = true, silent = true })

-- Map <C-z> for undo in Normal and Insert mode
vim.api.nvim_set_keymap('n', '<C-z>', 'u', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-z>', '<Esc>u', { noremap = true, silent = true })

-- Map <C-S-z> (Control + Shift + Z) for redo in Normal and Insert mode
vim.api.nvim_set_keymap('n', '<C-S-z>', '<C-r>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-S-z>', '<Esc><C-r>', { noremap = true, silent = true })

-- Map <leader>o to 'o' followed by <Esc> in Normal mode
vim.api.nvim_set_keymap('n', '<leader>o', 'o<Esc>', { noremap = true, silent = true })

-- Map <leader>o to 'o' followed by <Esc> in Insert mode (to mimic the same behavior)
vim.api.nvim_set_keymap('i', '<leader>o', '<Esc>o', { noremap = true, silent = true })
-- Map <leader>O to 'O' followed by <Esc> in Normal mode (to select all text)
vim.api.nvim_set_keymap('n', '<C-a>', 'ggVG', { noremap = true, silent = true })
-- Map '*' to search for the word under the cursor without moving the cursor position
vim.api.nvim_set_keymap('n', '*', ':keepjumps normal! mi*`i<CR>', { noremap = true, silent = true })

-- NOP arrow keys
vim.api.nvim_set_keymap('n', '<Up>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Down>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Left>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Right>', '<Nop>', { noremap = true, silent = true })

-- vim.api.nvim_set_keymap('n', '<C-c><C-c>', ':qa!<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '/', '/\\v', { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', 'H', '^', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'L', '$', { noremap = true, silent = true })

-- For init.lua (Lua-based config)
vim.api.nvim_set_keymap('n', '<Leader>90', [[:lua vim.cmd('vertical resize ' .. math.floor(vim.o.columns * 0.9))<CR>]], { noremap = true, silent = true })

local auto_resize_enabled = false
local autocmd_id = nil

-- Function to resize the current window to 90%
local function resize_current_to_90()
  vim.cmd('vertical resize ' .. math.floor(vim.o.columns * 0.9))
end

-- Function to make all windows equal width
local function make_windows_equal()
  vim.cmd 'wincmd ='
end

-- Function to enable auto-resizing
local function enable_auto_resize()
  if not auto_resize_enabled then
    autocmd_id = vim.api.nvim_create_autocmd('WinEnter', {
      pattern = '*',
      callback = resize_current_to_90,
      desc = 'Automatically resize current window to 90% width on focus',
    })
    auto_resize_enabled = true
    resize_current_to_90() -- Ensure the current window is resized immediately
    print 'Auto-resize enabled'
  end
end

-- Function to disable auto-resizing
local function disable_auto_resize()
  if auto_resize_enabled and autocmd_id then
    vim.api.nvim_del_autocmd(autocmd_id)
    autocmd_id = nil
    auto_resize_enabled = false
    make_windows_equal() -- Reset all windows to equal width
    print 'Auto-resize disabled'
  end
end

-- Function to toggle auto-resizing
_G.toggle_auto_resize = function()
  if auto_resize_enabled then
    disable_auto_resize()
  else
    enable_auto_resize()
  end
end

-- Key binding to toggle the feature
vim.api.nvim_set_keymap('n', '<Leader>ar', ':lua toggle_auto_resize()<CR>', { noremap = true, silent = true })

-- always enable spell check
vim.opt.spell = true

-- map Ctrl + / () to gcc
vim.api.nvim_set_keymap('n', '<C-/>', 'gcc', { noremap = true, silent = true })
