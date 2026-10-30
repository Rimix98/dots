hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "1",   -- set your monitor scale
})

hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("QT_QPA_PLATFORMTHEME", "kde")
hl.env("GTK_THEME", "Adwaita-dark")

hl.config({
    general = {
        gaps_in     = 4,
        gaps_out    = 8,
        border_size = 4,
        col = {
              active_border   = "rgba(9f78bdff)",
              inactive_border = "rgba(333333ff)",
},
        resize_on_border = true,
        allow_tearing    = false,
        layout           = "dwindle",
        snap = {
            enabled       = true,
            window_gap    = 4,
            monitor_gap   = 8,
            respect_gaps  = true,
            border_overlap = false,
        },
    },

    decoration = {
        rounding         = 0,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        shadow = { enabled = false },
        blur   = { enabled = false },
    },

    animations = { enabled = false },

    dwindle = { preserve_split = true },

    binds = {
        drag_threshold = 8,
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },
})
