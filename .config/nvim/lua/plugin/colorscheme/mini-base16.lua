return {
  'echasnovski/mini.base16',
  config = function()
    require('mini.base16').setup({
      palette = {
        -- Default Background
        base00 = '#edece8',
        -- Lighter Background (Used for status bars, line number and folding marks)
        base01 = '#e6e6e6',
        -- Selection Background
        base02 = '#babab6',
        -- Comments, Invisible, Line Highlighting
        base03 = '#848089',
        -- Dark Foreground (Used for status bars)
        base04 = '#000000',
        -- Default Foreground, Caret, Delimiters, Operators
        base05 = '#2b2b2b',
        -- Light Foreground (Not often used)
        base06 = '#40403e',
        -- Light Background (Not often used)
        base07 = '#ffffff',
        -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
        base08 = '#b00c0c',
        -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
        base09 = '#eda60c',
        -- Classes, Markup Bold, Search Text Background
        base0A = '#2b17e6',
        -- Strings, Inherited Class, Markup Code, Diff Inserted
        base0B = '#057a47',
        -- Support, Regular Expressions, Escape Characters, Markup Quotes
        base0C = '#0cb9ed',
        -- Functions, Methods, Attribute IDs, Headings
        base0D = '#1fc70c',
        -- Keywords, Storage, Selector, Markup Italic, Diff Changed
        base0E = '#0cd3ed',
        -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
        base0F = '#000000',
      },
      use_cterm = true,
    })
  end,
}
