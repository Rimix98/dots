hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "1",   -- поставь свой масштаб
})

hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("QT_QPA_PLATFORMTHEME", "kde")
hl.env("GTK_THEME", "Adwaita-dark")

-- Wayland-нативно для Qt и Electron (как в end-4): меньше XWayland = меньше лага
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

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
        allow_tearing    = true, -- включает immediate-правила для игр (см. rules.lua)
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
        force_default_wallpaper  = 0,
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
        -- Включаем экран по движению мыши / нажатию клавиш (экономия батареи)
        mouse_move_enables_dpms  = true,
        key_press_enables_dpms   = true,
        -- VRR отключен: переключение adaptive sync при переходе в fullscreen
        -- давало кратковременное гашение экрана на этой панели.
        -- Хочешь VRR — поставь 2 (только fullscreen) или 1 (всегда); может мерцать/менять яркость.
        vrr = 0,
    },

    -- Принудительно аппаратные курсоры: авто-режим (2) на этой сборке выбрал
    -- программные, из-за чего Hyprland перерисовывал композитор на каждое движение мыши.
    -- Если курсор пропадёт/поглючит: hyprctl keyword cursor:no_hardware_cursors 2
    cursor = {
        no_hardware_cursors = 0,
    },
})
