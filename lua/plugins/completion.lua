return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "super-tab",
      },
      completion = {
        -- Still provide help automatically, but avoid querying/showing instantly on every keystroke.
        -- Press <C-Space> for immediate completion and <C-k> for signature help.
        menu = {
          auto_show = true,
          auto_show_delay_ms = 250,
        },
        trigger = {
          prefetch_on_insert = false,
          show_on_keyword = true,
          show_on_trigger_character = true,
          show_on_insert = false,
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
      sources = {
        min_keyword_length = 2,
      },
      signature = {
        enabled = true,
        trigger = {
          enabled = false,
        },
      },
    },
  },
}
