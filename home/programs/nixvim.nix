{ pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    nixpkgs.useGlobalPackages = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;

    opts = {
      number = true;
      relativenumber = true;
      mouse = "a";
      showmode = false;
      signcolumn = "yes";
      termguicolors = true;
      updatetime = 250;
      timeoutlen = 400;
      splitright = true;
      splitbelow = true;
      ignorecase = true;
      smartcase = true;
      wrap = false;
      cursorline = true;
      scrolloff = 8;
      tabstop = 2;
      shiftwidth = 2;
      softtabstop = 2;
      expandtab = true;
      smartindent = true;
      clipboard = "unnamedplus";
    };

    extraPackages = with pkgs; [
      stylua
      ripgrep
      lazygit
      gnumake
      lua51Packages.tiktoken_core
      fd
    ];

    extraPlugins = with pkgs.vimPlugins; [
      plenary-nvim
      nvim-web-devicons
      lazygit-nvim
      alpha-nvim
      nui-nvim
      which-key-nvim
      neo-tree-nvim
      bufferline-nvim
      lualine-nvim
      telescope-nvim
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp_luasnip
      luasnip
      friendly-snippets
      lspkind-nvim
      lsp_signature-nvim
    ];

    plugins = {
      direnv.enable = true;

      treesitter = {
        enable = true;
        settings = {
          indent = {
            enable = true;
          };
          highlight = {
            enable = true;
          };
        };

        nixvimInjections = true;
        grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
      };

      treesitter-context = {
        enable = true;
      };

      treesitter-textobjects = {
        enable = true;
        settings.select = {
          enable = true;
          lookahead = true;
        };
      };

      lsp = {
        enable = true;
        servers = {
          basedpyright = {
            enable = true;
            extraOptions = {
              before_init = {
                __raw = ''
                  function(params, config)
                    local function get_python_path(root_dir)
                      if vim.env.VIRTUAL_ENV and vim.fn.executable(vim.env.VIRTUAL_ENV .. "/bin/python") == 1 then
                        return vim.env.VIRTUAL_ENV .. "/bin/python"
                      end

                      local cwd = root_dir or vim.fn.getcwd()
                      local candidates = {
                        cwd .. "/.venv/bin/python",
                        cwd .. "/venv/bin/python",
                        cwd .. "/.devenv/state/venv/bin/python",
                        cwd .. "/.direnv/python-venv/bin/python",
                      }

                      for _, path in ipairs(candidates) do
                        if vim.fn.executable(path) == 1 then
                          return path
                        end
                      end

                      local path_python = vim.fn.exepath("python3")
                      if path_python ~= "" then
                        return path_python
                      end

                      return nil
                    end

                    local root = config.root_dir or (params.rootUri and vim.uri_to_fname and vim.uri_to_fname(params.rootUri)) or params.rootPath or vim.fn.getcwd()
                    local py_path = get_python_path(root)
                    if py_path then
                      config.settings = config.settings or {}
                      config.settings.python = config.settings.python or {}
                      config.settings.python.pythonPath = py_path
                      config.settings.basedpyright = config.settings.basedpyright or {}
                      config.settings.basedpyright.analysis = config.settings.basedpyright.analysis or {}
                      config.settings.basedpyright.analysis.pythonPath = py_path
                    end
                  end
                '';
              };
            };
            settings = {
              basedpyright = {
                analysis = {
                  autoSearchPaths = true;
                  useLibraryCodeForTypes = true;
                  diagnosticMode = "workspace";
                  typeCheckingMode = "standard";
                };
              };
              python = {
                analysis = {
                  autoSearchPaths = true;
                  useLibraryCodeForTypes = true;
                  diagnosticMode = "workspace";
                };
              };
            };
          };
          ruff.enable = true;
          nil_ls.enable = true;
          lua_ls = {
            enable = true;
            settings = {
              Lua = {
                diagnostics = { globals = [ "vim" ]; };
                workspace = { checkThirdParty = false; };
                completion = { callSnippet = "Replace"; };
              };
            };
          };
          gopls.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
            settings = {
              rust-analyzer = {
                cargo = { allFeatures = true; };
                check = { command = "clippy"; };
              };
            };
          };
          bashls.enable = true;
          jsonls.enable = true;
          marksman.enable = true;
          taplo.enable = true;
          yamlls.enable = true;
          beancount.enable = true;
        };

        keymaps.lspBuf = {
          gd = "definition";
          gD = "declaration";
          gr = "references";
          gi = "implementation";
          K = "hover";
          "<leader>rn" = "rename";
          "<leader>ca" = "code_action";
          "<leader>cf" = "format";
        };
      };
    };

    extraConfigLua = ''
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "

      local map = vim.keymap.set
      map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

      map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
      map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
      map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

      map("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "New tab" })
      map("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "Close other tabs" })
      map("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Close tab" })
      map("n", "<leader>tl", "<cmd>tabnext<cr>", { desc = "Next tab" })
      map("n", "<leader>th", "<cmd>tabprevious<cr>", { desc = "Previous tab" })

      map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
      map("n", "<leader>w", "<cmd>w<cr>", { desc = "Write" })

      vim.g.lazygit_floating_window_use_plenary = 1
      vim.g.lazygit_floating_window_scaling_factor = 0.9
      vim.g.lazygit_floating_window_border_chars = { "+", "-", "+", "|", "+", "-", "+", "|" }

      map("n", "<leader>gl", "<cmd>LazyGit<cr>", { desc = "Lazygit" })
      map("n", "gl", "<cmd>LazyGit<cr>", { desc = "Lazygit" })

      vim.api.nvim_create_autocmd("TextYankPost", {
        desc = "Highlight yanked text",
        callback = function()
          vim.highlight.on_yank({ timeout = 160 })
        end,
      })

      vim.api.nvim_create_autocmd("CursorHold", {
        desc = "Show diagnostics in a floating window",
        callback = function()
          vim.diagnostic.open_float(nil, { focusable = false })
        end,
      })

      require("which-key").setup({
        preset = "classic",
        delay = 300,
      })
      require("which-key").add({
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>t", group = "tab" },
      })

      require("neo-tree").setup({
        close_if_last_window = true,
        popup_border_style = "rounded",
        filesystem = {
          follow_current_file = { enabled = true },
          hijack_netrw_behavior = "open_default",
        },
        window = {
          width = 34,
        },
      })
      map("n", "<leader>e", "<cmd>Neotree toggle filesystem reveal left<cr>", { desc = "Explorer" })

      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
          always_show_bufferline = true,
          separator_style = "slant",
        },
      })

      require("lualine").setup({
        options = {
          theme = "auto",
          globalstatus = true,
        },
      })

      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        "  ██████  ██▓ ███▄ ▄███▓ ▒█████   ███▄    █   ██████ ",
        "▒██    ▒ ▓██▒▓██▒▀█▀ ██▒▒██▒  ██▒ ██ ▀█   █ ▒██    ▒ ",
        "░ ▓██▄   ▒██▒▓██    ▓██░▒██░  ██▒▓██  ▀█ ██▒░ ▓██▄   ",
        "  ▒   ██▒░██░▒██    ▒██ ▒██   ██░▓██▒  ▐▌██▒  ▒   ██▒",
        "▒██████▒▒░██░▒██▒   ░██▒░ ████▓▒░▒██░   ▓██░▒██████▒▒",
        "▒ ▒▓▒ ▒ ░░▓  ░ ▒░   ░  ░░ ▒░▒░▒░ ░ ▒░   ▒ ▒ ▒ ▒▓▒ ▒ ░",
        "░ ░▒  ░ ░ ▒ ░░  ░      ░  ░ ▒ ▒░ ░ ░░   ░ ▒░░ ░▒  ░ ░",
        "░  ░  ░   ▒ ░░      ░   ░ ░ ░ ▒     ░   ░ ░ ░  ░  ░  ",
        "      ░   ░         ░       ░ ░           ░       ░  ",
        "                                                     ",
        " ███▄    █  ██▓▒██   ██▒ ██▒   █▓ ██▓ ███▄ ▄███▓     ",
        " ██ ▀█   █ ▓██▒▒▒ █ █ ▒░▓██░   █▒▓██▒▓██▒▀█▀ ██▒     ",
        "▓██  ▀█ ██▒▒██▒░░  █   ░ ▓██  █▒░▒██▒▓██    ▓██░     ",
        "▓██▒  ▐▌██▒░██░ ░ █ █ ▒   ▒██ █░░░██░▒██    ▒██      ",
        "▒██░   ▓██░░██░▒██▒ ▒██▒   ▒▀█░  ░██░▒██▒   ░██▒     ",
        "░ ▒░   ▒ ▒ ░▓  ▒▒ ░ ░▓ ░   ░ ▐░  ░▓  ░ ▒░   ░  ░     ",
        "░ ░░   ░ ▒░ ▒ ░░░   ░▒ ░   ░ ░░   ▒ ░░  ░      ░     ",
        "   ░   ░ ░  ▒ ░ ░    ░       ░░   ▒ ░░      ░        ",
        "         ░  ░   ░    ░        ░   ░         ░        ",
        "                             ░                       "
      }

      dashboard.section.buttons.val = {
        dashboard.button("e", "  New file", "<cmd>ene <BAR> startinsert<cr>"),
        dashboard.button("f", "  Find file", "<cmd>Telescope find_files<cr>"),
        dashboard.button("r", "  Recent files", "<cmd>Telescope oldfiles<cr>"),
        dashboard.button("g", "  Live grep", "<cmd>Telescope live_grep<cr>"),
        dashboard.button("q", "  Quit", "<cmd>qa<cr>"),
      }

      dashboard.section.footer.val = { "nixvim on nixos" }
      dashboard.opts.opts.noautocmd = true
      alpha.setup(dashboard.opts)

      vim.api.nvim_create_autocmd("VimEnter", {
        desc = "Show dashboard only when no file is opened directly",
        callback = function()
          if vim.fn.argc() == 0 and vim.api.nvim_buf_get_name(0) == "" then
            alpha.start(true)
          end
        end,
      })

      require("telescope").setup({})
      map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
      map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
      map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
      map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help" })

      local cmp = require("cmp")
      local lspkind = require("lspkind")
      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
          { name = "buffer" },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
          }),
        },
      })

      vim.diagnostic.config({
        severity_sort = true,
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 2,
          source = "if_many",
        },
        float = {
          border = "rounded",
          source = "if_many",
        },
      })

      -- Signature help auto-attach
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client then
            require("lsp_signature").on_attach({
              bind = true,
              hint_enable = false,
              handler_opts = { border = "rounded" },
              floating_window = true,
            }, bufnr)
          end
        end,
      })

      -- Python Virtual Environment Resolution helper for direnv updates
      local function get_python_path(root_dir)
        if vim.env.VIRTUAL_ENV and vim.fn.executable(vim.env.VIRTUAL_ENV .. "/bin/python") == 1 then
          return vim.env.VIRTUAL_ENV .. "/bin/python"
        end

        local cwd = root_dir or vim.fn.getcwd()
        local candidates = {
          cwd .. "/.venv/bin/python",
          cwd .. "/venv/bin/python",
          cwd .. "/.devenv/state/venv/bin/python",
          cwd .. "/.direnv/python-venv/bin/python",
        }

        for _, path in ipairs(candidates) do
          if vim.fn.executable(path) == 1 then
            return path
          end
        end

        local path_python = vim.fn.exepath("python3")
        if path_python ~= "" then
          return path_python
        end

        return nil
      end

      -- Update basedpyright python path dynamically when direnv switches environment
      vim.api.nvim_create_autocmd("User", {
        pattern = "DirenvLoaded",
        desc = "Update basedpyright python path on direnv load",
        callback = function()
          local clients = vim.lsp.get_clients({ name = "basedpyright" })
          for _, client in ipairs(clients) do
            local py_path = get_python_path(client.config.root_dir)
            if py_path then
              client.config.settings = client.config.settings or {}
              client.config.settings.python = client.config.settings.python or {}
              client.config.settings.python.pythonPath = py_path
              if client.config.settings.basedpyright then
                client.config.settings.basedpyright.analysis = client.config.settings.basedpyright.analysis or {}
                client.config.settings.basedpyright.analysis.pythonPath = py_path
              end
              client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
            end
          end
        end,
      })
    '';
  };
}
