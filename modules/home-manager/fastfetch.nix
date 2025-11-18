{myLib, ...}: {
  programs.bash.shellAliases = {
    neofetch = "fastfetch";
  };
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "auto";
        padding.top = 4;
      };
      display = {
        size = {
          ndigits = 1;
          binaryPrefix = "si";
        };
        key = {
          type = "both";
          paddingLeft = 2;
        };
        constants = [
          "───────────────────────────"
        ];
      };
      modules = let
        colors = {
          hardware = "#16A085";
          software = "#3DAEE9";
          state = "#D670D6";
        };
        pad = myLib.padRight 9 " ";
      in [
        # ---------------------------------- Hardware ----------------------------------
        {
          type = "custom";
          # bold_white used for the bold component
          # https://github.com/fastfetch-cli/fastfetch/wiki/Color-Format-Specification
          format = "┌─{$1}{#bold_white}{#${colors.hardware}} Hardware {#}{$1}─┐";
        }
        {
          key = pad "OS";
          type = "os";
          keyColor = colors.hardware;
        }
        {
          key = pad "Kernel";
          type = "kernel";
          keyColor = colors.hardware;
        }
        {
          key = pad "CPU"; # Find a way to combine this with CPU usage
          type = "cpu";
          format = "{name} {temperature}";
          temp = true;
          keyColor = colors.hardware;
        }
        {
          key = pad "GPU";
          type = "gpu";
          keyColor = colors.hardware;
        }
        {
          key = pad "Display";
          type = "display";
          compactType = "original-with-refresh-rate";
          keyColor = colors.hardware;
        }
        "break"
        {
          key = pad "CPU Usage";
          type = "cpuusage";
          keyColor = colors.hardware;
        }
        {
          key = pad "Battery";
          type = "battery";
          temp = true;
          keyColor = colors.hardware;
        }
        {
          key = pad "Disk";
          type = "disk";
          keyColor = colors.hardware;
        }
        {
          key = pad "Memory";
          type = "memory";
          keyColor = colors.hardware;
        }
        {
          key = pad "Swap";
          type = "swap";
          keyColor = colors.hardware;
        }
        # ---------------------------------- Software ----------------------------------
        {
          type = "custom";
          format = "├─{$1}{#bold_white}{#${colors.software}} Software {#}{$1}─┤";
        }
        {
          key = pad "DE";
          type = "de";
          keyColor = colors.software;
        }
        {
          key = pad "WM";
          type = "wm";
          keyColor = colors.software;
        }
        {
          key = pad "LM";
          type = "lm";
          keyColor = colors.software;
        }
        {
          key = pad "Packages";
          type = "packages";
          keyColor = colors.software;
        }
        {
          key = pad "Shell";
          type = "shell";
          keyColor = colors.software;
        }
        {
          key = pad "Terminal";
          type = "terminal";
          keyColor = colors.software;
        }
        # ---------------------------------- State ----------------------------------
        {
          type = "custom";
          format = "├──{$1}{#bold_white}{#${colors.state}} State {#}{$1}───┤";
        }
        {
          key = pad "WiFi";
          type = "wifi";
          keyColor = colors.state;
        }
        {
          key = pad "Local IP";
          type = "localip";
          keyColor = colors.state;
          compact = true;
          showSpeed = true;
        }
        {
          key = pad "Public IP";
          type = "publicip";
          keyColor = colors.state;
          timeout = 500;
        }
        {
          key = pad "Processes";
          type = "processes";
          keyColor = colors.state;
        }
        {
          key = pad "Uptime";
          type = "uptime";
          keyColor = colors.state;
        }
        {
          type = "custom";
          format = "└──────{$1}{$1}──────┘";
        }
        {
          type = "colors";
          paddingLeft = 26;
          symbol = "circle";
        }
        # "bios"
        # "bluetooth"
        # "bluetoothradio"
        # "board"
        # "bootmgr"
        # "break"
        # "brightness"
        # "btrfs"
        # "camera"
        # "chassis"
        # "cpucache"
        # "command"
        # "cursor"
        # "datetime"
        # "diskio"
        # "dns"
        # "editor"
        # "font"
        # "gamepad"
        # "host" # ?
        # "icons"
        # "initsystem"
        # "keyboard"
        # "loadavg"
        # "locale"
        # "media"
        # "monitor"
        # "mouse"
        # "netio"
        # "opencl"
        # "opengl"
        # "physicaldisk"
        # "physicalmemory"
        # "player"
        # "poweradapter"
        # "sound"
        # "terminalfont"
        # "terminalsize"
        # "terminaltheme"
        # "title"
        # "theme"
        # "tpm"
        # "users"
        # "version"
        # "vulkan"
        # "wallpaper"
        # "weather"
        # "wmtheme"
        # "zpool"
      ];
    };
  };
}
# Inspiration: https://github.com/fastfetch-cli/fastfetch/blob/dev/presets/examples/
# 12 Fixed width, icons & dividers
# 20 (progress bars)
# 24 Cool coloration
# 25 OS Age :
# {
#     "condition": {                                    // Conditional module: only show on non-macOS
#         "!system": "macOS"
#     },
#     "type": "disk",
#     "keyIcon": "",
#     "key": "│{#magenta}│ {icon}  OS Age    │{$4}│{#keys}│{$2}",
#     "folders": "/",                                   // Check root filesystem
#     "format": "{create-time:10} [{days} days]"        // Show creation time and age in days
# },

