hl.config({
    input = {
        touchpad = {
        	natural_scroll = true,
        },
        kb_layout    = "us, ru",
        kb_options   = "grp:alt_shift_toggle",
        follow_mouse = 1,
        sensitivity  = 0,
    },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
