# autumn256.vim

A 256bit colorscheme for vim or neovim, including customization for
[lightline](https://github.com/itchyny/lightline.vim) or [lualine](https://github.com/nvim-lualine/lualine.nvim).

## Installation

Install the colorscheme as a plugin, e.g. using [vim-plug](https://github.com/junegunn/vim-plug):
```viml
Plug 'Luminiscental/autumn256.vim'
```

Once installed, you can set the colorscheme in `.vimrc` or `init.vim`:
```viml
" If necessary, set gui colors
if (has("termguicolors"))
  set termguicolors
else
  set t_Co=256
endif

syntax enable
colorscheme autumn256
```

and include it in your lightline config:
```viml
let g:lightline = {
      \ 'colorscheme': 'autumn256',
      \ ...
      \ }
```

or in your lualine config:
```lua
require'lualine'.setup {
  options = {
    theme = require'autumn256.lualine_theme',
    ...
  },
  ...
}
```

## Screenshots

![Example screenshot (viml)](https://github.com/Luminiscental/autumn256.vim/raw/main/screenshots/vim.png?raw=true)
![Example screenshot (rust)](https://github.com/Luminiscental/autumn256.vim/raw/main/screenshots/rust.png?raw=true)
![Example screenshot (vimdiff)](https://github.com/Luminiscental/autumn256.vim/raw/main/screenshots/vimdiff.png?raw=true)
![Example screenshot (viml/lua)](https://github.com/Luminiscental/autumn256.vim/raw/main/screenshots/lua.png?raw=true)
