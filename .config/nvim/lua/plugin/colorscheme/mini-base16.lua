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
        base08 = '#a72817',
        -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
        base09 = '#476857',
        -- Classes, Markup Bold, Search Text Background
        base0A = '#575807',
        -- Strings, Inherited Class, Markup Code, Diff Inserted
        base0B = '#477817',
        -- Support, Regular Expressions, Escape Characters, Markup Quotes
        base0C = '#972867',
        -- Functions, Methods, Attribute IDs, Headings
        base0D = '#472877',
        -- Keywords, Storage, Selector, Markup Italic, Diff Changed
        base0E = '#773817',
        -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
        base0F = '#000000',
      },
      use_cterm = true,
    })

    -- 検索結果の色だけ変える
    vim.api.nvim_set_hl(0, 'Search', {
      bg = 11330557,
      ctermbg = 214,
      ctermfg = 7,
      fg = 0,
    })
  end,
}
