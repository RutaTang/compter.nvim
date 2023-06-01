# Compter.nvim

<p align="center">
<a href="./i18n/zh.md">[简体中文]</a>
<a href="./i18n/fr.md">[Français]</a>
</p>

Compter.nvim provides an easy way to customize and power the ability of `<C-a>` and `<C-x>`. 

<p align="center">
  <img src="./art/showcase.gif">
</p>

By default, Neovim enable you to use `<C-a>` and `<C-x>` to increase and descrease value of numbers. But with support of compter.nvim, you can customize `<C-a>` and `<C-x>` to not only increase and decrease value of numbers but also to enable you to do more powerful things, such as increase and descrease alphabet value (e.g. increase from a to b) and increase and decrease date value (e.g. increase from 01/01/2020 to 02/01/2020). 

1. [Installnation](#installnation)
2. [Usage](#usage)
3. [Configuration](#configuration)
4. [Templates](#templates)
    1. [Useful template](#useful-templates)
    2. [Provide your own template](#provide-your-own-template)
5. [How to contribute](#how-to-contribute)

## Installnation

Use any plugin managers you like, here is an example using lazy.nvim:

```lua
require("lazy").setup({
  { "RutaTang/compter.nvim", config = function()
        require("compter").setup({})
    end,
  }
})
```

## Configuration

```lua

require("lazy").setup({
  { "RutaTang/compter.nvim", config = function()
        require("compter").setup({
            -- Provide and customize templates
            templates = {
            },
            -- Whether fallback to nvim-built-in increase and decrease operation, default to false
            fallback = false 
        })
    end,
  }
})
```

Compter.nvim **does not embed built-in templates**, you can choose and add provided templates from [Useful template](#useful-templates) or [Provide your own template](#provide-your-own-template)

## Usage 

Compter.nvim has already overrided `<C-a>` and `<C-x>` keymappings. What you need to do to use this plugin is just to use `<C-a>` and `<C-x>` as usual. Both `<C-a>` and `<C-x>` support intergation with count, which means you can use like `100<C-a>` and `100<C-x>`.

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

After you choose or wirte templates, add templates to the `templates` like this:

```lua
require("lazy").setup({
  { "RutaTang/compter.nvim", config=function()
        require("compter").setup(
            {
                templates = {
                    -- example template
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
            }
        )
    end
  },
})
```

### Useful templates

I may continuely add more templates later:

<details>
    <summary>Show all templates</summary>

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

3. For date format, dd/mm/YYYY:

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

4. For emoji ⭐:

```lua
-- for emoji ⭐
{
    pattern = [[⭐\{1,5}]],
    priority = 0,
    increase = function(content)
        local l = #content / 3 + 1
        if l > 5 then
            l = 1
        end
        return string.rep("⭐", l), true
    end,
    decrease = function(content)
        local l = #content / 3 - 1
        if l < 1 then
            l = 5
        end
        return string.rep("⭐", l), true
    end,
}

```

5. For circle degree:

```lua
-- for circle degree
{
    pattern = [[\d\{1,3}°]],
    priority = 0,
    increase = function(content)
        local l = tonumber(content:sub(1, -3)) + 1
        if l >= 360 then
            l = 0
        end
        return string.format("%d°", l), true
    end,
    decrease = function(content)
        local l = tonumber(content:sub(1, -3)) - 1
        if l < 0 then
            l = 359
        end
        return string.format("%d°", l), true
    end,
}
```

6. For boolean:

```lua
-- for boolean
{
    pattern = [[\<\(true\|false\|TRUE\|FALSE\|True\|False\)\>]],
    priority = 100,
    increase = function(content)
        local switch = {
            ["true"] = "false",
            ["false"] = "true",
            ["True"] = "False",
            ["False"] = "True",
            ["TRUE"] = "FALSE",
            ["FALSE"] = "TRUE",
        }
        return switch[content], true
    end,
    decrease = function(content)
        local switch = {
            ["true"] = "false",
            ["false"] = "true",
            ["True"] = "False",
            ["False"] = "True",
            ["TRUE"] = "FALSE",
            ["FALSE"] = "TRUE",
        }
        return switch[content], true
    end,
}
```

</details>


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

## How to contribute

Since the plugin is in its very early stage, I do not accpet PRs to **plugin codes** and **templates** for now and still very appreciate for your willing to contribute. I may accpet PRs later when it's ready. 

If you found any bugs or enhancements, please open an issue first and we can the discuss.
