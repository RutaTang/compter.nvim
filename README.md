# Compter.nvim

Compter.nvim provides an easy way to customize and power the ability of `<C-a>` and `<C-x>`. By default, Neovim enable you to use `<C-a>` and `<C-x>` to increase and descrease value of numbers. But with support of compter.nvim, you can customize `<C-a>` and `<C-x>` to not only increase and decrease value of numbers but also to enable you to do more powerful things, such as increase and descrease alphabet value (e.g. increase from a to b) and increase and decrease date value (e.g. increase from 01/01/2020 to 02/01/2020). While compter.nvim provide some built-in abilities, you can easily provide your own.


## Installnation

Use any plugin managers you like, here is an example using lazy.nvim:

```lua
require("lazy").setup({
  { "RutaTang/compter.nvim", config={
    templates = {
        -- provide and customize your own template
    }      
  }},
})
```

## Usage 

Compter.nvim has already overrided `<C-a>` and `<C-x>` keymappings. What you need to do to use this plugin is just to use `<C-a>` and `<C-x>` as usual.

For example:

1. Cursor is on 1

```
1
^
```

2. Press `<C-a>`
3. The value increase to 2

```
2
^
```

## Provide your own template


