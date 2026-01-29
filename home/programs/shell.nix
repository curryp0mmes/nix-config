{ lib, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    autosuggestion.strategy = [
      "match_prev_cmd"
      "history"
    ];
    syntaxHighlighting.enable = true;
    history.append = true; # real time history file updates
    initContent = lib.mkOrder 400 ''
      command_not_found_handler() {
        local cmd="$1"
        shift
        local args=("$@")
  
        # Colors for the script UI
        local CYAN='\033[0;36m'
        local GREEN='\033[0;32m'
        local YELLOW='\033[1;33m'
        local RED='\033[0;31m'
        local NC='\033[0m'
  
        echo -e "''${CYAN}--- '$cmd' not found. Searching nixpkgs... ---''${NC}"
  
        # 1. Capture and clean nh search results
        local raw_pkgs=$(nh search "$cmd" --limit 6 | \
          sed 's/\x1b\[[0-9;]*[mGKH]//g' | \
          grep "(" | grep -v "Querying" | awk '{print $1}' | \
          tac)
  
        # Check if we found anything
        if [ -z "$raw_pkgs" ]; then
          echo -e "''${RED}No package found for '$cmd' in nixpkgs.''${NC}"
          return 127
        fi
  
        # 2. Use fzf for a graphical selector
        # --height 40%: don't take over the whole screen
        # --layout=reverse: list starts near the prompt
        # --border: adds a nice frame
        # --prompt: custom prompt text
        local pkg=$(echo "$raw_pkgs" | fzf \
          --height 15 \
          --layout=reverse \
          --border \
          --prompt="Select package for '$cmd' > " \
          --header="Enter to run, ESC to cancel")
  
        # If the user didn't cancel (ESC)
        if [ -n "$pkg" ]; then
          # Trim whitespace
          pkg=$(echo "$pkg" | xargs)
          
          echo -e "''${YELLOW}Executing:''${NC} ''${CYAN}nix shell \"nixpkgs#$pkg\" --command $cmd ''${args[@]}''${NC}"
          
          nix shell "nixpkgs#$pkg" --command "$cmd" "''${args[@]}"
        else
          echo -e "''${RED}Aborted.''${NC}"
        fi
      }
  
      fastfetch --config ~/.config/fastfetch/minimal.jsonc
    '';
    
  };

  programs.kitty = {
    enable = true;
    settings = {
      enable_audio_bell = false;
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      # Disable the default newline between prompt and command
      # add_newline = false;
      # Configure the prompt symbols
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      # Configure specific modules, e.g., the directory module
      directory = {
        truncate_to_repo = false;
      };
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
