{ pkgs, ... }: {
  programs.helix = {
    enable = true;
   
    settings = {
      # theme = "kanagawa";
      # theme = "everforest_dark";
      # theme = "catppuccin_macchiato";
      theme = "rose_pine";

      editor = {
        line-number = "relative";
        # highlight lines with cursors
        cursorline = true;
        # don't start lines following comments with a comment
        continue-comments = false;
        rulers = [ 80 ];
        # always show open buffers
        bufferline = "always";
        # indicate modes with different colors
        color-modes = true;
        # idle-timeout = 200;
        text-width = 80;
        end-of-line-diagnostics = "hint";
      
        statusline = {
          right = [
            "diagnostics" "selections" "register" "position" "file-type"
            "file-encoding"
          ];

          mode.normal = "NORMAL";
          mode.insert = "INSERT";
          mode.select = "SELECT";
        };

        lsp = {
          display-progress-messages = true;
          display-inlay-hints = true;
          snippets = false;
        };

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        file-picker = {
          hidden = false;
        };

        auto-pairs = {
          "<" = ">";
        };

        soft-wrap.enable = true;

        inline-diagnostics = {
          cursor-line = "info";
        };
      };

      keys.insert = {
        "S-tab" = "unindent";
      };

      keys.normal = {
        "q" = ":quit-all";
        "C-j" = ["extend_to_line_bounds" "delete_selection" "paste_after"];
        "C-k" = ["extend_to_line_bounds" "delete_selection" "move_line_up" "paste_before"];
      };
      keys.select = {
        "q" = ":quit-all";
      };
    };

    languages = {
      language-server = {
        rust-analyzer = {
          config = {
            check = {
              command = "clippy";
              features = "all";
            };
            completion.termSearch.enable = true;
            hover = {
              show.traitAssocItems = 3;
            };
            # prefer importing items from `self` where possible
            imports.prefix = "self";

            inlayHints = {
              closureCaptureHints.enable = true;
              maxLength = 20;
            };
          };
        };
        nil = {
          command = "${pkgs.nil}/bin/nil";
        };
        harper = {
          command = "${pkgs.harper}/bin/harper-ls";
          args = [ "--stdio" ];
        };

        # lsp-ai = {
        #   command = "${pkgs.lsp-ai}/bin/lsp-ai";
        #   config = {
        #     memory = {
        #       file_store = {};
        #     };
        #     models = {
        #       model1 = {
        #         type = "anthropic";
        #         chat_endpoint = "https://api.x.ai/v1/messages";
        #         model = "grok-3-mini";
        #         auth_token_env_var_name = "XAI_API_KEY";
        #       };
        #     };
        #     completion = {
        #       model = "model1";
        #       parameters = {
        #         max_context = 2048;
        #         max_tokens = 2048;
        #         messages = [
        #           {
        #             role = "user";
        #             content = "{CODE}";
        #           }
        #         ];
        #         system = "Instructions:\n- You are an AI programming assistant.\n- Given a piece of code with the cursor location marked by \"<CURSOR>\", replace \"<CURSOR>\" with the correct code or comment.\n- First, think step-by-step.\n- Describe your plan for what to build in pseudocode, written out in great detail.\n- Then output the code replacing the \"<CURSOR>\"\n- Ensure that your completion fits within the language context of the provided code snippet (e.g., Python, JavaScript, Rust).\n\nRules:\n- Only respond with code or comments.\n- Only replace \"<CURSOR>\"; do not include any previously written code.\n- Never include \"<CURSOR>\" in your response\n- If the cursor is within a comment, complete the comment meaningfully.\n- Handle ambiguous cases by providing the most contextually appropriate completion.\n- Be consistent with your responses.";
        #       };
        #     };
        #   };
        # };
      };

      language = [
        {
          name = "rust";
          auto-format = true;
          formatter = {
            command = "cargo fmt";
          };
          indent = { tab-width = 2; unit = "  "; };
          # language-servers = [ "rust-analyzer" "lsp-ai" ];
        }
        {
          name = "nix";
          language-servers = [ "nil" ];
        }
        {
          name = "wgsl";
          indent = { tab-width = 2; unit = "  "; };
        }
        {
          name = "surrealdb";
          scope = "source.surrealdb";
          file-types = [ "surql" ];
          comment-tokens = "--";
          indent = { tab-width = 2; unit = "  "; };
          grammar = "surrealdb";
        }
        {
          name = "markdown";
          language-servers = [ "marksman" "harper" ];
        }
        {
          name = "toml";
          auto-format = true;
          formatter = {
            command = "${pkgs.taplo}/bin/taplo";
            args = [ "fmt" "-" ];
          };
        }
      ];

      # note: in order for this grammar to work, run the following:
      # `nix shell nixpkgs#clang -c sh -c "hx --grammar fetch && hx --grammar build"`
      # it may take some moments to fetch the first time
      grammar = [
        {
          name = "surrealdb";
          source = {
            git = "https://github.com/DariusCorvus/tree-sitter-surrealdb";
            rev = "17a7ed4481bdaaa35a1372f3a94bc851d634a19e";
          };
        }
      ];
    };
  };

  
  home.file.surql-queries = let
    surql-ts-src = pkgs.fetchgit {
      url = "https://github.com/DariusCorvus/tree-sitter-surrealdb";
      rev = "17a7ed4481bdaaa35a1372f3a94bc851d634a19e";
      hash = "sha256-/xX5lEQKFuLQl6YxUA2WLKGX5P2GBugtYj42WCtA0xU=";
    };
  in {
    source = "${surql-ts-src}/queries/highlights.scm";
    target = ".config/helix/runtime/queries/surrealdb/highlights.scm";
  };

  home.packages = with pkgs; [
    taplo
  ];
}

