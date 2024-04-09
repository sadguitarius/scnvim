--- Default configuration.
--- Provides fallback values not specified in the user config.
-- ---@module scnvim.config

--- table
---@class default
---@field ensure_installed boolean (default: true) If installed once, this can be set to false to improve startup time.
local default = {
  ensure_installed = true,

  --- table
  ---@class default.sclang
  ---@field cmd string|nil Path to the sclang executable. Not needed if sclang is already in your $PATH.
  ---@field args table Comma separated arguments passed to the sclang executable.
  sclang = {
    cmd = nil,
    args = {},
  },

  --- table (empty by default)
  ---@class default.keymaps
  ---@field keymap table scnvim.map
  ---@usage keymaps = {
  ---    ['<M-e>'] = map('editor.send_line', {'i', 'n'}),
  ---    ['<C-e>'] = {
  ---      map('editor.send_block', {'i', 'n'}),
  ---      map('editor.send_selection', 'x'),
  ---    },
  ---    ['<leader>st'] = map('sclang.start'),
  ---    ['<leader>sk'] = map('sclang.recompile'),
  ---  }
  keymaps = {},

  --- table
  ---@class default.documentation
  ---@field cmd string|nil Absolute path to the render program (e.g. /opt/homebrew/bin/pandoc)
  ---@field args table (default: `{ '$1', '--from', 'html', '--to', 'plain', '-o', '$2' }`)
  ---
  --- Arguments given to the render program. The default args are for
  ---`pandoc`. Any program that can convert html into plain text should work. The
  --- string $1 will be replaced with the input file path and $2 will be replaced
  --- with the output file path.
  ---
  ---@field horizontal boolean (default: true) Open the help window as a horizontal split
  ---@field direction 'top'|'right'|'bot'|'left' (default: 'top') Direction of the split: 'top', 'right', 'bot', 'left'
  ---@field keymaps boolean (default: true) If true apply user keymaps to the help
  --- window. Use a table value for explicit mappings.
  documentation = {
    cmd = nil,
    args = { '$1', '--from', 'html', '--to', 'plain', '-o', '$2' },
    horizontal = true,
    direction = 'top',
    keymaps = true,
  },

  --- table
  ---@class default.postwin
  ---@field highlight boolean (default: true) Use syntax colored post window output.
  ---@field auto_toggle_error boolean (default: true) Auto-toggle post window on errors.
  ---@field scrollback number (default: 5000) The number of lines to save in the post window history.
  ---@field horizontal boolean (default: false) Open the post window as a horizontal split
  ---@field direction 'top'|'right'|'bot'|'left' (default: 'right') Direction of the split: 'top', 'right', 'bot', 'left'
  ---@field size table|nil Use a custom initial size
  ---@field fixed_size table|nil Use a fixed size for the post window. The window will always use this size if closed.
  ---@field keymaps boolean|table|nil (default: true) If true apply user keymaps to the help
  --- window. Use a table value for explicit mappings.
  postwin = {
    highlight = true,
    auto_toggle_error = true,
    scrollback = 5000,
    horizontal = false,
    direction = 'right',
    size = nil,
    fixed_size = nil,
    keymaps = nil,

    --- table
    ---@class default.postwin.float
    ---@field enabled boolean (default: false) Use a floating post window.
    ---@field row number|function (default: 0) The row position, can be a function.
    ---@field col number|function (default: vim.o.columns) The column position, can be a function.
    ---@field width number|function (default: 64) The width, can be a function.
    ---@field height number|function (default: 14) The height, can be a function.
    ---@field callback function (default: `function(id) vim.api.nvim_win_set_option(id, 'winblend', 10) end`)
    --- Callback that runs whenever the floating window was opened.
    --- Can be used to set window local options.
    float = {
      enabled = false,
      row = 0,
      col = function()
        return vim.o.columns
      end,
      width = 64,
      height = 14,
      --- table
      ---@class default.postwin.float.config
      ---@field border 'none'|'single'|'double'|'rounded'|'solid'|'shadow'|string[] (default: 'single')
      --- ... See `:help nvim_open_win` for possible values
      config = {
        border = 'single',
      },
      callback = function(id)
        vim.api.nvim_win_set_option(id, 'winblend', 10)
      end,
    },
  },

  --- table
  ---@class default.editor
  ---@field force_ft_supercollider boolean (default: true) Treat .sc files as supercollider.
  --- If false, use nvim's native ftdetect.
  editor = {
    force_ft_supercollider = true,

    --- table
    ---@class editor.highlight
    ---@field color string|table (default: `TermCursor`) Highlight group for the flash color.
    --- Use a table for custom colors:
    --- `color = { guifg = 'black', guibg = 'white', ctermfg = 'black', ctermbg = 'white' }`
    ---@field type 'flash'|'fade'|'none' (default: 'flash') Highligt flash type: 'flash', 'fade' or 'none'

    --- table
    ---@class editor.highlight.flash
    ---@field duration number (default: 100) The duration of the flash in ms.
    ---@field repeats number (default: 2) The number of repeats.

    --- table
    ---@class editor.highlight.fade
    ---@field duration number (default: 375) The duration of the flash in ms.
    highlight = {
      color = 'TermCursor',
      type = 'flash',
      flash = {
        duration = 100,
        repeats = 2,
      },
      fade = {
        duration = 375,
      },
    },

    --- table
    ---@class editor.signature
    ---@field float boolean (default: true) Show function signatures in a floating window
    ---@field auto boolean (default: true) Show function signatures while typing in insert mode
    ---@field config table
    signature = {
      float = true,
      auto = true,
      config = {}, -- TODO: can we use vim.diagnostic instead..?
    },
  },


  ---@class snippet
  snippet = {
  ---@class snippet.engine
  ---@field name string Name of the snippet engine
  ---@field options table Table of engine specific options (note, currently not in use)
    engine = {
      name = 'luasnip',
      options = {
        descriptions = true,
      },
    },
    -- mul_add = false, -- Include mul/add arguments for UGens
    -- style = 'default', -- 'compact' = do not put spaces between args, etc.
  },

  --- table
  ---@class statusline
  ---@field poll_interval number (default: 1) The interval to update the status line widgets in seconds.
  statusline = {
    poll_interval = 1,
  },

  --- table
  ---@table extensions
  extensions = {},
}

local M = {}

setmetatable(M, {
  __index = function(self, key)
    local config = rawget(self, 'config')
    if config then
      return config[key]
    end
    return default[key]
  end,
})

--- Merge the user configuration with the default values.
---@param config table The user configuration
function M.resolve(config)
  config = config or {}
  M.config = vim.tbl_deep_extend('keep', config, default)
end

return M
