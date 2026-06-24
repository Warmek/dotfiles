vim.pack.add {
  'https://github.com/goolord/alpha-nvim',
}
local dashboard = require 'alpha.themes.dashboard'

dashboard.section.header.val = {
  [[*@@@m   *@@@*                   *@@@@*   *@@@**@@@@**@@@@m     m@@@*]],
  [[  @@@m    @                       *@@     m@    @@    @@@@    @@@@  ]],
  [[  @ @@@   @    mm@*@@   m@@*@@m    @@m   m@     @@    @ @@   m@ @@  ]],
  [[  @  *@@m @   m@*   @@ @@*   *@@    @@m  @*     @@    @  @!  @* @@  ]],
  [[  @   *@@m!   !@****** @@     @@    *!@ !*      @!    !  @!m@*  @@  ]],
  [[  !     !@!   !@m    m @@     !@     !@@m       @!    !  *!@*   @@  ]],
  [[  !   *!!!!   !!****** !@     !!     !! !*      !!    !  !!!!*  !!  ]],
  [[  !     !!!   :!!      !!!   !!!     !!::       :!    :  *!!*   !!  ]],
  [[: : :    :!!   : : ::   : : : :       :       :!: : : ::: :   : ::: ]],
}

dashboard.section.buttons.val = {
  dashboard.button('e', '  New file', ':ene <BAR> startinsert <CR>'),
  dashboard.button('q', '  Quit NVIM', ':qa<CR>'),
}

require('alpha').setup(dashboard.config)
