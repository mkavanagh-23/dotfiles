return {
  'goolord/alpha-nvim',
  dependencies = { 'echasnovski/mini.icons' },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.startify")

    dashboard.section.header.val = {
      [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
      [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⡶⠞⠛⠉⠉⠉⠉⠉⠉⠛⠷⣦⣀⠀⠀⠀⠀ ]],
      [[⠀⠀⠀⠀⠀⠀ NEOVIM⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢷⡀⠀⠀ ]],
      [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⡄⠀ ]],
      [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⠀ ]],
      [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇ ]],
      [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡄⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⢸⡇ ]],
      [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⡴⠶⠶⢤⣤⣀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠰⣿⣿⡷⠀⠀⠀⠀⠀⠀⠀⢸⠇ ]],
      [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡾⠛⠁⠀⠀⠀⠀⠈⣹⣷⣄⠀⠀⠀⣷⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠁⠀⠀⠀⠀⠀⠀⢠⡟⠀ ]],
      [[⠀⠀⠀⠀⠀⠀⠀⠀⣴⠟⠻⣦⣀⠀⠀⠀⣠⡾⠋⠀⠙⢷⡄⠀⠸⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣰⠟⠀⠀ ]],
      [[⠀⠀⠀⠀⠀⠀⢀⣾⠃⠀⠀⣼⠛⠛⠛⠛⣿⠀⠀⠀⠀⠀⢻⣄⠀⢿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠠⢦⣤⣤⠶⠟⠁⠀⠀⠀ ]],
      [[⠀⠀⠀⠀⠀⠀⣼⣃⣀⣀⣠⡟⠀⠀⠀⠀⠘⢷⣄⠀⢀⣠⡴⢿⡄⢸⣇⠀⠀⠀⢴⣤⣄⣀⣤⡴⠞⠋⠀⠀⠀⠀⠀⠀⠀ ]],
      [[⠀⠀⠀⠀⠀⢸⠏⠉⠉⠉⠻⣇⠀⠀⠀⠀⠀⠀⣩⣿⠟⠁⠀⠀⢿⣸⡏⠀⠀⠀⠀⢀⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
      [[⠀⠀⠀⢠⣴⣿⡄⠀⠀⠀⠀⠹⣆⠀⠀⠀⣠⡾⠋⣿⠀⠀⢀⣤⠾⠛⣷⠀⠀⠀⣰⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
      [[⠀⠀⠀⣸⣧⠀⠙⢶⣄⠀⠀⢠⡿⠛⠛⠉⠉⠀⢀⣯⣤⠶⠛⠁⣀⡾⠋⠀⣠⡾⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
      [[⢸⣷⠿⠋⣿⠻⣦⣀⠉⠛⠶⠿⢦⣤⣤⠴⠶⠞⠛⠉⠀⣀⣤⠾⠋⣀⣴⡾⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
      [[⠀⠙⠛⠺⣿⠀⠀⠉⠛⠶⢦⣤⣤⣀⣀⣀⣀⣤⡤⠶⠞⠋⠁⠀⣾⠋⠙⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
      [[⠀⠀⠀⠀⣿⠀⠀⠀⠀⢀⣦⣤⣀⣈⣉⣉⣀⣀⣠⣀⠀⠀⠀⠀⣿⡶⠟⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
      [[⠀⠀⠀⠀⠻⢷⣤⣤⣤⣼⣷⣬⠟⠉⠉⠉⠉⠉⠀⠉⠻⢶⠶⠾⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]]
    }
    require 'alpha'.setup(require 'alpha.themes.startify'.config)
  end
};
