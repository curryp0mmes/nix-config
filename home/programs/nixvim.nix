{ pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;

    extraPackages = with pkgs; [
      bash-language-server
      pyright
      basedpyright
      lua-language-server
      stylua
      ripgrep
      lazygit
      beancount-language-server
      gopls
      go
      rust-analyzer
      rustfmt
      taplo
      nil
      nodePackages.vscode-langservers-extracted
      nodePackages.yaml-language-server
      marksman
      ruff
      lua51Packages.tiktoken_core
      gnumake
      python3Packages.jedi-language-server
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
      nvim-treesitter
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

    extraConfigLua = ''
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "

      local opt = vim.opt
      opt.number = true
      opt.relativenumber = true
      opt.mouse = "a"
      opt.showmode = false
      opt.signcolumn = "yes"
      opt.termguicolors = true
      opt.updatetime = 250
      opt.timeoutlen = 400
      opt.splitright = true
      opt.splitbelow = true
      opt.ignorecase = true
      opt.smartcase = true
      opt.wrap = false
      opt.cursorline = true
      opt.scrolloff = 8
      opt.tabstop = 2
      opt.shiftwidth = 2
      opt.softtabstop = 2
      opt.expandtab = true
      opt.smartindent = true
      opt.clipboard = "unnamedplus"
      opt.completeopt = { "menu", "menuone", "noselect" }

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

      local ts_ok, ts_configs = pcall(require, "nvim-treesitter.configs")
      if not ts_ok then
        ts_ok, ts_configs = pcall(require, "nvim-treesitter.config")
      end
      if ts_ok then
        ts_configs.setup({
          highlight = { enable = true },
          indent = { enable = true },
          auto_install = true,
          ensure_installed = {
            "bash",
            "go",
            "json",
            "lua",
            "markdown",
            "nix",
            "python",
            "rust",
            "toml",
            "vim",
            "yaml",
          },
        })
      end

      local cmp = require("cmp")
      local lspkind = require("lspkind")
      local luasnip = require("luasnip")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local has_new_lsp_api = vim.lsp ~= nil
        and type(vim.lsp.enable) == "function"
        and (type(vim.lsp.config) == "function" or type(vim.lsp.config) == "table")

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

      local on_attach = function(_, bufnr)
        local lsp_map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        lsp_map("n", "gd", vim.lsp.buf.definition, "Go to definition")
        lsp_map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
        lsp_map("n", "gr", vim.lsp.buf.references, "References")
        lsp_map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
        lsp_map("n", "K", vim.lsp.buf.hover, "Hover docs")
        lsp_map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        lsp_map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
        lsp_map("n", "<leader>cf", function()
          vim.lsp.buf.format({ async = true })
        end, "Format file")
        lsp_map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")

        require("lsp_signature").on_attach({
          bind = true,
          hint_enable = false,
          handler_opts = { border = "rounded" },
          floating_window = true,
        }, bufnr)
      end

      local function can_run(cmd)
        return vim.fn.executable(cmd) == 1
      end

      local servers = {
        bashls = { cmd = "bash-language-server" },
        beancount = { cmd = "beancount-language-server" },
        gopls = { cmd = "gopls" },
        jsonls = { cmd = "vscode-json-language-server" },
        lua_ls = {
          cmd = "lua-language-server",
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
              completion = { callSnippet = "Replace" },
            },
          },
        },
        marksman = { cmd = "marksman" },
        nil_ls = { cmd = "nil" },
        ruff = { cmd = "ruff" },
        rust_analyzer = {
          cmd = "rust-analyzer",
          settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              check = { command = "clippy" },
            },
          },
        },
        taplo = { cmd = "taplo" },
        yamlls = { cmd = "yaml-language-server" },
      }

      if can_run("basedpyright-langserver") then
        servers.basedpyright = { cmd = "basedpyright-langserver" }
      elseif can_run("pyright-langserver") then
        servers.pyright = { cmd = "pyright-langserver" }
      end

      for server, server_opts in pairs(servers) do
        if can_run(server_opts.cmd) then
          server_opts.cmd = nil
          server_opts.capabilities = capabilities
          server_opts.on_attach = on_attach
          if has_new_lsp_api then
            vim.lsp.config(server, server_opts)
            vim.lsp.enable(server)
          else
            local ok_lspconfig, lspconfig = pcall(require, "lspconfig")
            if ok_lspconfig then
              lspconfig[server].setup(server_opts)
            end
          end
        end
      end
    '';
  };
}
