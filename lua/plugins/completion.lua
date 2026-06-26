return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "super-tab",
      },
      completion = {
        -- Keep completion manual so LSP doesn't query/show suggestions on every keystroke.
        -- Press <C-Space> when you want the menu.
        menu = {
          auto_show = false,
        },
        trigger = {
          prefetch_on_insert = false,
          show_on_keyword = false,
          show_on_trigger_character = false,
        },
        documentation = {
          auto_show = false,
        },
        accept = {
          auto_brackets = {
            enabled = false,
          },
        },
      },
      signature = {
        enabled = false,
      },
    },
  },
}
