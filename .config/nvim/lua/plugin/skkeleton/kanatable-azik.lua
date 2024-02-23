local stream = require('util/stream')

local M = {}

local function create_kanatable()
  local vowel_i = { a = 1, i = 2, u = 3, e = 4, o = 5 }

  local matrixes = {
    normal = {
      [''] = { 'あ', 'い', 'う', 'え', 'お' },
      ['k'] = { 'か', 'き', 'く', 'け', 'こ' },
      ['s'] = { 'さ', 'し', 'す', 'せ', 'そ' },
      ['t'] = { 'た', 'ち', 'つ', 'て', 'と' },
      ['n'] = { 'な', 'に', 'ぬ', 'ね', 'の' },
      ['h'] = { 'は', 'ひ', 'ふ', 'へ', 'ほ' },
      ['m'] = { 'ま', 'み', 'む', 'め', 'も' },
      ['y'] = { 'や', 'い', 'ゆ', 'いぇ', 'よ' },
      ['r'] = { 'ら', 'り', 'る', 'れ', 'ろ' },
      ['w'] = { 'わ', 'うぃ', 'う', 'うぇ', 'を' },
      ['f'] = { 'ふぁ', 'ふぃ', 'ふ', 'ふぇ', 'ふぉ' },
      ['v'] = { 'ゔぁ', 'ゔぃ', 'ゔ', 'ゔぇ', 'ゔぉ' },
      ['g'] = { 'が', 'ぎ', 'ぐ', 'げ', 'ご' },
      ['z'] = { 'ざ', 'じ', 'ず', 'ぜ', 'ぞ' },
      ['j'] = { 'じゃ', 'じ', 'じゅ', 'じぇ', 'じょ' },
      ['d'] = { 'だ', 'ぢ', 'づ', 'で', 'ど' },
      ['b'] = { 'ば', 'び', 'ぶ', 'べ', 'ぼ' },
      ['p'] = { 'ぱ', 'ぴ', 'ぷ', 'ぺ', 'ぽ' },
      ['sh'] = { 'しゃ', 'し', 'しゅ', 'しぇ', 'しょ' },
      ['x'] = { 'しゃ', 'し', 'しゅ', 'しぇ', 'しょ' },
      ['ch'] = { 'ちゃ', 'ち', 'ちゅ', 'ちぇ', 'ちょ' },
      ['c'] = { 'ちゃ', 'ち', 'ちゅ', 'ちぇ', 'ちょ' },
      ['th'] = { 'てぁ', 'てぃ', 'てゅ', 'てぇ', 'てょ' },
      ['dh'] = { 'でゃ', 'でぃ', 'でゅ', 'でぇ', 'でょ' },
    },
    y = {
      ['ky'] = { 'きゃ', 'きぃ', 'きゅ', 'きぇ', 'きょ' },
      ['sy'] = { 'しゃ', 'しぃ', 'しゅ', 'しぇ', 'しょ' },
      ['ty'] = { 'ちゃ', 'ちぃ', 'ちゅ', 'ちぇ', 'ちょ' },
      ['cy'] = { 'ちゃ', 'ちぃ', 'ちゅ', 'ちぇ', 'ちょ' },
      ['ny'] = { 'にゃ', 'にぃ', 'にゅ', 'にぇ', 'にょ' },
      ['hy'] = { 'ひゃ', 'ひぃ', 'ひゅ', 'ひぇ', 'ひょ' },
      ['fy'] = { 'ふゃ', 'ふぃ', 'ふゅ', 'ふぇ', 'ふょ' },
      ['my'] = { 'みゃ', 'みぃ', 'みゅ', 'みぇ', 'みょ' },
      ['ry'] = { 'りゃ', 'りぃ', 'りゅ', 'りぇ', 'りょ' },
      ['gy'] = { 'ぎゃ', 'ぎぃ', 'ぎゅ', 'ぎぇ', 'ぎょ' },
      ['jy'] = { 'じゃ', 'じぃ', 'じゅ', 'じぇ', 'じょ' },
      ['zy'] = { 'じゃ', 'じぃ', 'じゅ', 'じぇ', 'じょ' },
      ['dy'] = { 'ぢゃ', 'ぢぃ', 'ぢゅ', 'ぢぇ', 'ぢょ' },
      ['by'] = { 'びゃ', 'びぃ', 'びゅ', 'びぇ', 'びょ' },
      ['py'] = { 'ぴゃ', 'ぴぃ', 'ぴゅ', 'ぴぇ', 'ぴょ' },
    },
  }

  matrixes.g = stream
    .start(matrixes.y)
    .map(function(results, constant)
      return { constant:sub(1, -2) .. 'g', results }
    end)
    .from_pairs()
    .terminate()

  local kanatable = {}
  local function add(table)
    kanatable = vim.tbl_extend('force', kanatable, table)
  end

  add(stream
    .start({ matrixes.normal, matrixes.y, matrixes.g })
    .flat_map(function(matrix)
      return stream.flat_map(matrix, function(results, constant)
        local by_vowels = stream.flat_map(stream.keys(vowel_i), function(vowel)
          local i = vowel_i[vowel]
          local default = { constant .. vowel, { results[i], '' } }
          local plus_n = { constant .. ({ 'z', 'k', 'j', 'd', 'l' })[i], { results[i] .. 'ん' } }
          return { default, plus_n }
        end)
        local extras = {
          { constant .. 'q', { results[vowel_i.a] .. 'い', '' } },
          { constant .. 'w', { results[vowel_i.e] .. 'い', '' } },
          { constant .. 'h', { results[vowel_i.u] .. 'う', '' } },
          { constant .. 'p', { results[vowel_i.o] .. 'う', '' } },
        }
        return stream.flat_map({ by_vowels, extras }, function(pair)
          return pair
        end)
      end)
    end)
    .from_pairs()
    .terminate())

  vim.fn['skkeleton#register_keymap']('henkan', '@', 'henkanForward')
  vim.fn['skkeleton#register_keymap']('henkan', '`', 'henkanBackward')
  add({
    ['@'] = 'henkanFirst',
    ['`'] = 'katakana',
    ['/'] = 'abbrev',
    [';'] = 'henkanPoint',
    ['\\'] = 'purgeCandidate',

    [' '] = { ' ', '' },
    [':'] = { 'ー', '' },
    ['l'] = { 'っ', '' },
    ['q'] = { 'ん', '' },

    ['xxa'] = { 'ぁ', '' },
    ['xxi'] = { 'ぃ', '' },
    ['xxu'] = { 'ぅ', '' },
    ['xxe'] = { 'ぇ', '' },
    ['xxo'] = { 'ぉ', '' },
    ['xxya'] = { 'ゃ', '' },
    ['xxyu'] = { 'ゅ', '' },
    ['xxyo'] = { 'ょ', '' },

    ['xwi'] = { 'ゐ', '' },
    ['xwe'] = { 'ゑ', '' },
    ['tgi'] = { 'てぃ', '' },
    ['tgu'] = { 'とぅ', '' },
    ['dci'] = { 'でぃ', '' },
    ['dcu'] = { 'どぅ', '' },
    ['wso'] = { 'うぉ', '' },

    ['kt'] = { 'こと', '' },
    ['st'] = { 'した', '' },
    ['tt'] = { 'たち', '' },
    ['ht'] = { 'ひと', '' },
    ['wt'] = { 'わた', '' },
    ['mn'] = { 'もの', '' },
    ['ms'] = { 'ます', '' },
    ['ds'] = { 'です', '' },
    ['km'] = { 'かも', '' },
    ['tm'] = { 'ため', '' },
    ['dm'] = { 'でも', '' },
    ['kr'] = { 'から', '' },
    ['sr'] = { 'する', '' },
    ['tr'] = { 'たら', '' },
    ['nr'] = { 'なる', '' },
    ['yr'] = { 'よる', '' },
    ['rr'] = { 'られ', '' },
    ['zr'] = { 'ざる', '' },
    ['mt'] = { 'また', '' },
    ['tb'] = { 'たび', '' },
    ['nb'] = { 'ねば', '' },
    ['bt'] = { 'びと', '' },
    ['gr'] = { 'がら', '' },
    ['gt'] = { 'ごと', '' },
    ['nt'] = { 'にち', '' },
    ['dt'] = { 'だち', '' },
    ['wr'] = { 'われ', '' },

    ['z;'] = { '゛', '' },
    ['z:'] = { '゜', '' },
    ['xxh'] = { '←', '' },
    ['xxj'] = { '↓', '' },
    ['xxk'] = { '↑', '' },
    ['xxl'] = { '→', '' },
    ['xxL'] = { '⇒', '' },
    ['!'] = { '！', '' },
    [','] = { '、', '' },
    ['-'] = { 'ー', '' },
    ['.'] = { '。', '' },
    ['?'] = { '？', '' },
    ['['] = { '「', '' },
    [']'] = { '」', '' },
    ['z('] = { '（', '' },
    ['z)'] = { '）', '' },
    ['z,'] = { '‥', '' },
    ['z-'] = { '～', '' },
    ['z.'] = { '・・・', '' },
    ['z/'] = { '・', '' },
    ['z '] = { '　', '' },
  })
  return kanatable
end

function M.register_kanatable()
  vim.fn['skkeleton#register_kanatable']('azik', create_kanatable(), true)
end

return M
