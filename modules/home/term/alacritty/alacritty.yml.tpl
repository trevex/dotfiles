window:
  opacity: 1.0
  padding:
    x: 5
    y: 5
  dynamic_padding: false
  decorations: none
  startup_mode: Windowed
  dynamic_title: true

scrolling:
  history: 10000
  multiplier: 3

font:
  normal:
    family: SFMono Nerd Font Mono
    style: Regular
  bold:
    family: SFMono Nerd Font Mono
    style: Bold
  italic:
    family: SFMono Nerd Font Mono
    style: Italic
  size: @fontSize@

draw_bold_text_with_bright_colors: true

hints:
  enabled:
   - regex: "(mailto:|gemini:|gopher:|https:|http:|news:|file:|git:|ssh:|ftp:)\
             [^\u0000-\u001F\u007F-\u009F<>\"\\s{-}\\^⟨⟩`]+"
     command: xdg-open
     post_processing: true
     mouse:
       enabled: true
       mods: None
     binding:
       key: U
       mods: Control|Shift

@colorScheme@
