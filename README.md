# Compter.nvim

Compter.nvim provides an easy way to customize and power the ability of `<C-a>` and `<C-x>`. 

By default, Neovim enable you to use `<C-a>` and `<C-x>` to increase and descrease value of numbers. But with support of compter.nvim, you can customize `<C-a>` and `<C-x>` to not only increase and decrease value of numbers but also to enable you to do more powerful things, such as increase and descrease alphabet value (e.g. increase from a to b) and increase and decrease date value (e.g. increase from 01/01/2020 to 02/01/2020). 


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

Compter.nvim does not embed built-in template, you can choose and add provided templates from [Useful template](#useful-templates) or [Provide your own template](#provide-your-own-template)

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

## Templates

You can use provided templates or add your own.

1. [Useful template](#useful-templates): use provided template
2. [Provide your own template](#provide-your-own-template): provide your own template

### Useful templates

1. For number:

```lua
{
    pattern = [[-\?\d\+]],
    priority = 0,
    increase = function(content)
        content = tonumber(content)
        return content + 1, true
    end,
    decrease = function(content)
        content = tonumber(content)
        return content - 1, true
    end,
}
```

2. For alphabet:

```lua
-- for lowercase alphabet
{
    pattern = [[\l]],
    priority = 0,
    increase = function(content)
        local ansiCode = string.byte(content) + 1
        if ansiCode > string.byte("z") then
            ansiCode = string.byte("a")
        end
        local char = string.char(ansiCode)
        return char, true
    end,
    decrease = function(content)
        local ansiCode = string.byte(content) - 1
        if ansiCode < string.byte("a") then
            ansiCode = string.byte("z")
        end
        local char = string.char(ansiCode)
        return char, true
    end,
}
```

```lua
-- for uppercase alphabet
{
    pattern = [[\u]],
    priority = 0,
    increase = function(content)
        local ansiCode = string.byte(content) + 1
        if ansiCode > string.byte("Z") then
            ansiCode = string.byte("A")
        end
        local char = string.char(ansiCode)
        return char, true
    end,
    decrease = function(content)
        local ansiCode = string.byte(content) - 1
        if ansiCode < string.byte("A") then
            ansiCode = string.byte("Z")
        end
        local char = string.char(ansiCode)
        return char, true
    end,
}
```

3. For date format: dd/mm/YYYY

```lua
-- for date format: dd/mm/YYYY
{
    pattern = [[\d\{2}/\d\{2}/\d\{4}]],
    priority = 100,
    increase = function(content)
        local ts = vim.fn.strptime("%d/%m/%Y", content)
        if ts == 0 then
            return content, false
        else
            ts = ts + 24 * 60 * 60
            return vim.fn.strftime("%d/%m/%Y", ts), true
        end
    end,
    decrease = function(content)
        local ts = vim.fn.strptime("%d/%m/%Y", content)
        if ts == 0 then
            return content, false
        else
            ts = ts - 24 * 60 * 60
            return vim.fn.strftime("%d/%m/%Y", ts), true
        end
    end,
}
```

### Provide your own template

A template must be as following structure:

```lua
{
    pattern = ..., -- regex pattern to be matched, e.g. [[\d]]
    priority = 0, -- priority, template with higher priority will be matched first
    -- How to increase content (<C-a>)
    -- @param content: content is the matched text
    -- @return newContent, handled: handled means whether continue to matche other templates 
    increase = function(content) 
        ...
        return newContent, true
    end,
    -- How to decrease content (<C-x>)
    -- param and return is same as `increase` above
    decrease = function(content)
        ...
        return newContent, true
    end,
},

```

A simple example is like:

```lua
-- this template match numbers
{
    pattern = [[-\?\d\+]],
    priority = 0,
    increase = function(content)
        content = tonumber(content)
        return content + 1, true
    end,
    decrease = function(content)
        content = tonumber(content)
        return content - 1, true
    end,
}
```

You should include your template in `config.templates` like this:

```lua
require("lazy").setup({
  { "RutaTang/compter.nvim", config={
    templates = {
        -- provide and customize your own template
        {
            pattern = [[-\?\d\+]],
            priority = 0,
            increase = function(content)
                content = tonumber(content)
                return content + 1, true
            end,
            decrease = function(content)
                content = tonumber(content)
                return content - 1, true
            end,
        },
        -- more templates
    }      
  }},
})
```
