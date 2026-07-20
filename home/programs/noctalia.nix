{ lib, pkgs, ... }:
{
  programs.noctalia = {
    enable = true;
    settings = {
      bar = {
        default = {
          capsule = false;
          center = [ "workspaces" ];
          end = [ "tray" "caffeine" "battery" "session" "clock" ];
          margin_ends = 0;
          padding = 10;
          position = "top";
          start = [ "control-center" "network" "bluetooth" "active_window" ];
          thickness = 32;
          widget_spacing = 8;
        };
      };

      calendar = {
        enabled = true;
        account = {
          personal_google = {
            type = "google";
          };
        };
      };

      dock = {
        background_opacity = 1.0;
        enabled = false;
      };

      idle = {
        behavior_order = [ "lock" "screen-off" "lock-and-suspend" ];
        pre_action_fade_seconds = 3;
        behavior = {
          lock = {
            action = "lock";
            enabled = true;
            timeout = 600.0;
          };
          "lock-and-suspend" = {
            action = "lock_and_suspend";
            enabled = false;
            timeout = 900.0;
          };
          "screen-off" = {
            action = "screen_off";
            enabled = true;
            timeout = 660.0;
          };
        };
      };

      location = {
        address = "Würzburg, Germany";
      };

      lockscreen_widgets = {
        enabled = false;
        schema_version = 2;
        widget_order = [ "lockscreen-login-box@eDP-1" ];
        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };
        widget = {
          "lockscreen-login-box@eDP-1" = {
            box_height = 70.0;
            box_width = 400.0;
            cx = 960.0;
            cy = 961.0;
            output = "eDP-1";
            rotation = 0.0;
            type = "login_box";
            settings = {
              background_color = "surface_variant";
              background_opacity = 0.88;
              background_radius = 12.0;
              center_password_text = false;
              input_opacity = 1.0;
              input_radius = 6.0;
              show_caps_lock = true;
              show_keyboard_layout = true;
              show_login_button = true;
              show_password_hint = true;
            };
          };
        };
      };

      notification = {
        background_opacity = 1.0;
      };

      osd = {
        background_opacity = 1.0;
      };

      shell = {
        app_icon_colorize = false;
        corner_radius_scale = 1.0000000149011612;
        font_family = "DejaVu Sans";
        niri_overview_type_to_launch_enabled = true;
        polkit_agent = true;
        screen_time_enabled = true;
        animation = {
          speed = 0.40000000596046448;
        };
      };

      theme = {
        builtin = "Catppuccin";
        custom_palette = "stylix";
        mode = "dark";
        source = "builtin";
        wallpaper_scheme = "m3-content";
      };

      wallpaper = {
        enabled = true;
        transition_on_startup = true;
        default = {
          path = "/home/simon/Pictures/Wallpapers/nixos_wallpaper_rainbow.png";
        };
        last = {
          path = "/home/simon/Pictures/Wallpapers/nixos_wallpaper_rainbow.png";
        };
        monitors = {
          eDP-1 = {
            path = "/home/simon/Pictures/Wallpapers/nixos_wallpaper_rainbow.png";
          };
        };
      };

      widget = {
        active_window = {
          capsule = true;
          display = "text_only";
          title_scroll = "on_hover";
        };
        battery = {
          display_mode = "graphic";
          type = "battery";
        };
        clock = {
          format = "{:%H:%M}";
          type = "clock";
        };
        control-center = {
          custom_image = "/home/simon/Pictures/nix-icon-size_128.png";
          custom_image_colorize = true;
          glyph = "brand-snowflake";
          type = "control-center";
        };
        network = {
          show_label = false;
          show_vpn_label = true;
        };
        tray = {
          type = "tray";
        };
        workspaces = {
          active_pill_size = 3.0;
          anchor = true;
          display = "none";
          empty_color = "on_surface";
          occupied_color = "on_surface_variant";
          pill_scale = 0.8;
          type = "workspaces";
        };
      };
    };
  };
}
