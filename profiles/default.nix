{ isLinux ? !isDarwin, isDarwin ? !isLinux }:

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

  mkProfile = imports: { ... }: { inherit imports; };

  profiles = self:
    {
      base = mkProfile [ ./base ];
      alacritty = mkProfile [ ./alacritty ];
      zsh = mkProfile [ ./zsh ];
      neovim = mkProfile [ ./neovim ];
      # ...
    }
    // optionalAttrs isLinux {
      bspwm = mkProfile [ ./bspwm ];
      desktop = mkProfile [ ./desktop ];
      polybar = mkProfile [ ./polybar ];
    }
    // optionalAttrs isDarwin {
      # ...
      # yabai = mkProfile [ ./yabai ];
    };
in
  fix profiles
