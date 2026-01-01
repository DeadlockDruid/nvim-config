return {
  'echasnovski/mini.ai',
  version = false,
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    local ai = require 'mini.ai'
    local gen = ai.gen_spec

    ai.setup {
      n_lines = 200,
      custom_textobjects = {
        a = gen.treesitter { a = '@parameter.outer', i = '@parameter.inner' },
        m = gen.treesitter { a = '@function.outer', i = '@function.inner' },
        c = gen.treesitter { a = '@class.outer', i = '@class.inner' },
        f = gen.treesitter { a = '@call.outer', i = '@call.inner' },
        i = gen.treesitter { a = '@conditional.outer', i = '@conditional.inner' },
        l = gen.treesitter { a = '@loop.outer', i = '@loop.inner' },

        ['='] = gen.treesitter { a = '@assignment.outer', i = '@assignment.inner' },
        L = gen.treesitter { a = '@assignment.lhs', i = '@assignment.lhs' },
        R = gen.treesitter { a = '@assignment.rhs', i = '@assignment.rhs' },

        [':'] = gen.treesitter { a = '@property.outer', i = '@property.inner' },
        H = gen.treesitter { a = '@property.lhs', i = '@property.lhs' },
        T = gen.treesitter { a = '@property.rhs', i = '@property.rhs' },
      },
    }
  end,
}
