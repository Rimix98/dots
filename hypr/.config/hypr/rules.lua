hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class = "^$", title = "^$",
        xwayland = true, float = true, fullscreen = false, pin = false,
    },
    no_focus = true,
})

-- Tearing (как в end-4): immediate только для игр и wine/Proton-окон.
-- Требует general.allow_tearing = true (см. appearance.lua).
hl.window_rule({ match = { title = ".*\\.exe" },        immediate = true })
hl.window_rule({ match = { class = "^(steam_app).*" },  immediate = true })
hl.window_rule({ match = { title = ".*minecraft.*" },   immediate = true })
