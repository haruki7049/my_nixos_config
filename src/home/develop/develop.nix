{ config, lib, pkgs, ... }:
let
  neovimPluginFromGitHub = rev: owner: repo: sha256:
    pkgs.vimUtils.buildVimPlugin {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = rev;
      src = pkgs.fetchFromGitHub {
        owner = owner;
        repo = repo;
        rev = rev;
        sha256 = sha256;
      };
    };
in {
  home.packages = with pkgs; [
    vim
    mg
    your-editor
    helix
    bash
    htop
    wget
    curl
    unzip
    gzip
    git
    zellij
    nixpkgs-fmt
    brave
    google-chrome
    neovide
    discord
    element-desktop
    slack
    whalebird
    osu-lazer
    anki
    thunderbird
    spotify
    gns3-gui
    gns3-server
    #ciscoPacketTracer8
  ];
  home.pointerCursor = let
    getFrom = url: sha256: name: size: {
      gtk.enable = true;
      x11.enable = true;
      name = name;
      size = size;
      package = pkgs.runCommand "moveUp" { } ''
        mkdir -p $out/share/icons
        ln -s ${
          builtins.fetchTarball {
            url = url;
            sha256 = sha256;
          }
        } $out/share/icons/${name}
      '';
    };
  in getFrom
  "https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.6/Bibata-Modern-Classic.tar.xz"
  "sha256-jpEuovyLr9HBDsShJo1efRxd21Fxi7HIjXtPJmLQaCU=" "bibata" 24;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  programs = {
    bash = { enable = true; };
    nushell = { enable = true; };
    fish = { enable = true; };
    zsh = {
      enable = true;
      dotDir = ".config/zsh";
    };
    alacritty = {
      enable = true;
      settings = {
        font.size = 8.0;
        font.normal.family = "UDEV Gothic NF";
      };
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      extraPackages = with pkgs; [
        deno
        rust-analyzer
        lua53Packages.lua-lsp
        nixd
        rubyPackages.solargraph
        ruff
        ruff-lsp
      ];
      plugins = with pkgs.vimPlugins; [
        # zephyr-nvim, A colorscheme for neovim and vim
        zephyr-nvim

        # plenary, A library for plugin creator
        plenary-nvim

        # denops, A Deno-Vim library for plugin creator
        denops-vim

        # Telescope
        telescope-nvim
        telescope-file-browser-nvim

        # lspconfig
        nvim-lspconfig

        # skkeleton, Vim's SKK
        (neovimPluginFromGitHub "438b9d22d926569db6e6034e0d333edce5f4d4cf"
          "vim-skk" "skkeleton"
          "sha256-jXPMDxiyJ3w4cpRgonlXjdmSJHsnkLhG6NeBjYjeKeo=")

        # GitHub Copilot
        copilot-vim
      ];
      extraLuaConfig = ''
        -- BASE
        vim.opt.termguicolors = true
        vim.opt.number = true
        vim.opt.syntax = 'on'
        vim.opt.backup = false
        vim.opt.swapfile = false
        vim.scriptencoding = 'utf-8'
        vim.opt.encoding = 'utf-8'
        vim.opt.fileencoding = 'utf-8'
        vim.opt.helplang = "ja", "en"
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
        vim.o.formatoptions = vim.o.formatoptions .. 'jql'
        vim.opt.laststatus = 0
        vim.opt.cmdheight = 0
        vim.api.nvim_create_autocmd({'FileType'}, {
          pattern = '*',
          command = 'set formatoptions-=c',
        })

        -- INDENT
        vim.api.nvim_create_autocmd({'FileType'}, {
          pattern = 'lua',
          command = 'setlocal tabstop=2 shiftwidth=2 et',
        })
        vim.api.nvim_create_autocmd({'FileType'}, {
          pattern = 'rust',
          command = 'setlocal tabstop=4 shiftwidth=4 et',
        })
        vim.api.nvim_create_autocmd({'FileType'}, {
          pattern = 'html',
          command = 'setlocal tabstop=4 shiftwidth=4 et',
        })
        vim.api.nvim_create_autocmd({'FileType'}, {
          pattern = 'c',
          command = 'setlocal tabstop=4 shiftwidth=4 et',
        })
        vim.api.nvim_create_autocmd({'FileType'}, {
          pattern = 'sh',
          command = 'setlocal tabstop=4 shiftwidth=4 et',
        })
        vim.api.nvim_create_autocmd({'FileType'}, {
          pattern = 'fish',
          command = 'setlocal tabstop=2 shiftwidth=2 et',
        })
        vim.api.nvim_create_autocmd({'FileType'}, {
          pattern = 'ps1',
          command = 'setlocal tabstop=4 shiftwidth=4 et',
        })
        vim.api.nvim_create_autocmd({'FileType'}, {
          pattern = 'java',
          command = 'setlocal tabstop=4 shiftwidth=4 et',
        })
        vim.api.nvim_create_autocmd({'FileType'}, {
          pattern = 'nix',
          command = 'setlocal tabstop=2 shiftwidth=2 et',
        })
        vim.api.nvim_create_autocmd({'FileType'}, {
          pattern = 'nu',
          command = 'setlocal tabstop=4 shiftwidth=4 et',
        })
        vim.api.nvim_create_autocmd({'FileType'}, {
          pattern = 'typescriptreact',
          command = 'setlocal tabstop=2 shiftwidth=2 et',
        })
        vim.api.nvim_create_autocmd({'FileType'}, {
          pattern = 'gleam',
          command = 'setlocal tabstop=2 shiftwidth=2 et',
        })
        vim.api.nvim_create_autocmd({'FileType'}, {
          pattern = 'lisp',
          command = 'setlocal tabstop=2 shiftwidth=2 et',
        })
        vim.api.nvim_create_autocmd({'FileType'}, {
          pattern = 'typescript',
          command = 'setlocal tabstop=2 shiftwidth=2 et',
        })
        vim.api.nvim_create_autocmd({'FileType'}, {
          pattern = 'nginx',
          command = 'setlocal tabstop=4 shiftwidth=4 et',
        })

        vim.api.nvim_create_autocmd({'FileType'}, {
          pattern = '*',
          command = 'if &l:omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif',
        })

        -- NEOVIDE
        local font_name = "UDEV Gothic NF:h14"
        if vim.g.neovide then
          vim.o.guifont = font_name
          vim.g.neovide_transparency = 0.98
          vim.g.transparency = 0.98
        end

        -- TERMINAL
        vim.g.sh = "bash"

        -- KEYCONFIG
        vim.api.nvim_set_keymap("n", "<leader>q", "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown())<cr>", {noremap = true});
        vim.api.nvim_set_keymap("i", "<C-j>", "<Plug>(skkeleton-enable)", {noremap = true});
        vim.api.nvim_set_keymap("c", "<C-j>", "<Plug>(skkeleton-enable)", {noremap = true});

        -- SKKELETON's JISYO
        vim.api.nvim_exec([[
          call skkeleton#config({
            \   'globalDictionaries': ['~/.skk/.skk-jisyo'],
            \   'eggLikeNewline': v:true,
            \ })
        ]], false);

        -- LSPCONFIG
        require('lspconfig').rust_analyzer.setup({
          settings = {
            ['rust-analyzer'] = {},
          },
        })
        require('lspconfig').denols.setup({
          settings = {
            ['denols'] = {
              cmd = {
                "deno",
                "lsp",
              },
              filetypes = {
                "javascript",
                "javascriptreact",
                "javascript.jsx",
                "typescript",
                "typescriptreact",
                "typescript.tsx"
              },
              settings = {
                deno = {
                  enable = true,
                  suggest = {
                    imports = {
                      hosts = {
                        ["https://deno.land"] = true,
                        ["https://jsr.io"] = true,
                      },
                    },
                  },
                },
              },
            },
          },
        })
        require('lspconfig').ruff.setup({
          settings = {
            ['ruff'] = {
              cmd = {
                "ruff",
                "server",
                "--preview",
              },
              filetypes = {
                "python",
              },
              single_file_support = true,
            },
          },
        })
        require('lspconfig').ruff_lsp.setup({
          settings = {
            ['ruff-lsp'] = {
              cmd = {
                "ruff-lsp",
              },
              filetypes = {
                "python",
              },
              single_file_support = true,
            },
          },
        })
        require('lspconfig').solargraph.setup({
          settings = {
            ['solargraph'] = {
              cmd = {
                "solargraph",
                "stdio",
              },
              filetypes = {
                "ruby",
              },
              settings = {
                solargraph = {
                  diagnostics = true,
                },
              },
            },
          },
        })
        require('lspconfig').lua_ls.setup({
          settings = {
            Lua = {
              diagnostics = {
                globals = {
                  'vim',
                },
              },
              telemetry = {
                enable = true,
              },
            },
          },
        })
        require('lspconfig').nixd.setup({
          settings = {
            ['nixd'] = {
              nixpkgs = {
                expr = "import <nixpkgs> { }",
              },
              formatting = {
                command = { "nixpkgs-fmt" },
              },
              options = {
                nixos = {
                  expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.k-on.options',
                },
                home_manager = {
                  expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."ruixi@k-on".options',
                },
              },
            },
          },
        })

        -- COLORSCHEME
        vim.cmd("colorscheme zephyr")
      '';
    };
    emacs = { enable = true; };
  };
  xsession = {
    windowManager.i3 = {
      enable = true;
      config = let
        finishCommand = ''
          exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'"
        '';
      in rec {
        modifier = "Mod4";
        floating.modifier = "Mod4";
        keybindings = {
          "${modifier}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+p" =
            "exec --no-startup-id ${pkgs.rofi}/bin/rofi -show run";

          "${modifier}+Left" = "focus left";
          "${modifier}+Right" = "focus right";
          "${modifier}+Up" = "focus up";
          "${modifier}+Down" = "focus down";

          "${modifier}+Shift+Left" = "move left";
          "${modifier}+Shift+Right" = "move right";
          "${modifier}+Shift+Up" = "move up";
          "${modifier}+Shift+Down" = "move down";

          "${modifier}+h" = "split h";
          "${modifier}+v" = "split v";
          "${modifier}+f" = "fullscreen toggle";
          "${modifier}+s" = "layout stacking";
          "${modifier}+w" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";

          "${modifier}+Shift+space" = "floating toggle";
          "${modifier}+space" = "focus mode_toggle";

          "${modifier}+a" = "focus parent";
          "${modifier}+d" = "focus child";

          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+r" = "restart";
          "${modifier}+Shift+e" = finishCommand;

          "${modifier}+r" = "mode 'resize'";

          "${modifier}+1" = "workspace number 1";
          "${modifier}+2" = "workspace number 2";
          "${modifier}+3" = "workspace number 3";
          "${modifier}+4" = "workspace number 4";
          "${modifier}+5" = "workspace number 5";
          "${modifier}+6" = "workspace number 6";
          "${modifier}+7" = "workspace number 7";
          "${modifier}+8" = "workspace number 8";
          "${modifier}+9" = "workspace number 9";
          "${modifier}+0" = "workspace number 10";
          "${modifier}+Shift+1" = "move container to workspace number 1";
          "${modifier}+Shift+2" = "move container to workspace number 2";
          "${modifier}+Shift+3" = "move container to workspace number 3";
          "${modifier}+Shift+4" = "move container to workspace number 4";
          "${modifier}+Shift+5" = "move container to workspace number 5";
          "${modifier}+Shift+6" = "move container to workspace number 6";
          "${modifier}+Shift+7" = "move container to workspace number 7";
          "${modifier}+Shift+8" = "move container to workspace number 8";
          "${modifier}+Shift+9" = "move container to workspace number 9";
          "${modifier}+Shift+0" = "move container to workspace number 10";
        };
        modes = {
          resize = {
            Left = "resize shrink width 10 px or 10 ppt";
            Right = "resize grow width 10 px or 10 ppt";
            Up = "resize shrink height 10 px or 10 ppt";
            Down = "resize grow height 10 px or 10 ppt";
            Return = "mode 'default'";
            Escape = "mode 'default'";
          };
        };
        fonts = {
          names = [ "monospace" ];
          style = "normal";
          size = 8.0;
        };
        bars = [{
          position = "bottom";
          statusCommand = "${pkgs.i3status}/bin/i3status";
        }];
      };
    };
  };
}