-- manually loading since we don't go through lazy plugin load
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.usercmds")

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- override colors post theme
require("config.colors")
