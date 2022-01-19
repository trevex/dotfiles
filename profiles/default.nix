{ isLinux ? !isDarwin, isDarwin ? !isLinux, isHomeManager }:

# Inlined `assertMsg`
assert (
  if isLinux != isDarwin then
    true
  else
    builtins.trace "profiles: isLinux and isDarwin are mutually exclusive" false
);

let
  # Inlined lib.optionalAttrs
  optionalAttrs = x: y: if x then y else { };
  # Inlined lib.fix
  fix = f: let x = f x; in x;

  # Let's define several helper functions to define in which environments the profiles work:
  # Profile - Works everywhere and takes care of the necessary steps itself
  # HomeProfile - Works everywhere, profile is home-manager module, so it is imported accordingly
  # LinuxHomeProfile - Works on every linux, profile is home-manager module
  # NixosProfile - Works only on NixOS
  # DarwinProfile - Works only on Darwin
  mkProfile = imports: { ... }: { inherit imports; };
  mkHomeProfile = imports: { ... }:
    if isHomeManager then { inherit imports; }
    else { my.home = { inherit imports; }; };
  mkLinuxHomeProfile = imports: { ... }:
    if isLinux then
      (if isHomeManager then { inherit imports; }
      else { my.home = { inherit imports; }; })
    else { };
  mkNixosProfile = imports: { ... }:
    if !isHomeManager && isLinux then {
      inherit imports;
    } else { };
  mkDarwinProfile = imports: { ... }: if !isHomeManager && isDarwin then { inherit imports; } else { };
  mkNixosDarwinProfile = imports: { ... }: if !isHomeManager && (isDarwin || isLinux) then { inherit imports; } else { };


  profiles = self:
    {
      base = mkProfile [ ./base ];
      alacritty = mkHomeProfile [ ./alacritty ];
      zsh = mkHomeProfile [ ./zsh ];
      neovim = mkHomeProfile [ ./neovim ];
      bspwm = mkProfile [ ./bspwm ];
      dunst = mkLinuxHomeProfile [ ./dunst ];
      polybar = mkLinuxHomeProfile [ ./polybar ];
      rofi = mkLinuxHomeProfile [ ./rofi ];
      urxvt = mkLinuxHomeProfile [ ./urxvt ];
      x11 = mkNixosProfile [ ./x11 ];
      desktop = mkNixosProfile [ ./desktop ];
      pipewire = mkNixosProfile [ ./pipewire ];
      pulseaudio = mkNixosProfile [ ./pulseaudio ];
      # yabai = mkDarwinProfile [ ./yabai ];
      gpg = mkNixosDarwinProfile [ ./gpg ];
    };
in
fix profiles
