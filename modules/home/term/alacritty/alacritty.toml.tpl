[colors]
draw_bold_text_with_bright_colors = true

[colors.bright]
black = "0x928374"
blue = "0x83a598"
cyan = "0x8ec07c"
green = "0xb8bb26"
magenta = "0xd3869b"
red = "0xfb4934"
white = "0xebdbb2"
yellow = "0xfabd2f"

[colors.normal]
black = "0x282828"
blue = "0x458588"
cyan = "0x689d6a"
green = "0x98971a"
magenta = "0xb16286"
red = "0xcc241d"
white = "0xa89984"
yellow = "0xd79921"

[colors.primary]
background = "0x282828"
foreground = "0xebdbb2"

[font]
size = @fontSize@

[font.bold]
family = "SFMono Nerd Font Mono"
style = "Bold"

[font.italic]
family = "SFMono Nerd Font Mono"
style = "Italic"

[font.normal]
family = "SFMono Nerd Font Mono"
style = "Regular"

[[hints.enabled]]
command = "xdg-open"
post_processing = true
regex = "(mailto:|gemini:|gopher:|https:|http:|news:|file:|git:|ssh:|ftp:)[^\u0000-\u001F\u007F-\u009F<>\"\\s{-}\\^⟨⟩`]+"

[hints.enabled.binding]
key = "U"
mods = "Control|Shift"

[hints.enabled.mouse]
enabled = true
mods = "None"

[scrolling]
history = 10000
multiplier = 3

[window]
decorations = "none"
dynamic_padding = false
dynamic_title = true
opacity = 1.0
startup_mode = "Windowed"

[window.padding]
x = 5
y = 5

[keyboard]
bindings = [
  { key = "Right", mods = "Alt", chars = "\u001BF" },
  { key = "Left",  mods = "Alt", chars = "\u001BB" },
]
