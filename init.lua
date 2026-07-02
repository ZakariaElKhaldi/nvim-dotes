--------------------------------------------------
--  Neovim
--------------------------------------------------

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

--------------------------------------------------
-- Plugins
--------------------------------------------------

vim.pack.add({

    --------------------------------------------------
    -- LSP
    --------------------------------------------------

    "https://github.com/neovim/nvim-lspconfig",

    --------------------------------------------------
    -- Completion
    --------------------------------------------------

    {
        src = "https://github.com/Saghen/blink.cmp",
        version = vim.version.range("^1"),
    },

    --------------------------------------------------
    -- Telescope
    --------------------------------------------------

    "https://github.com/nvim-lua/plenary.nvim",

    "https://github.com/nvim-telescope/telescope.nvim",

    {
        src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
    },


    --------------------------------------------------
    -- Explorer
    --------------------------------------------------

    "https://github.com/stevearc/oil.nvim",
    "https://github.com/nvim-tree/nvim-web-devicons",


    --------------------------------------------------
    -- Which Key
    --------------------------------------------------

    "https://github.com/folke/which-key.nvim",

    --------------------------------------------------
    -- Git
    --------------------------------------------------

    "https://github.com/lewis6991/gitsigns.nvim",

    --------------------------------------------------
    -- Auto Pairs
    --------------------------------------------------

    "https://github.com/windwp/nvim-autopairs",

    --------------------------------------------------
    -- Todo comments
    --------------------------------------------------

    "https://github.com/folke/todo-comments.nvim",

    --------------------------------------------------
    -- Theme
    --------------------------------------------------

    "https://github.com/srcery-colors/srcery-vim",

})

--------------------------------------------------
-- Options
--------------------------------------------------

local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.cursorline = true

opt.mouse = "a"

opt.clipboard = "unnamedplus"

opt.termguicolors = true

opt.signcolumn = "yes"

opt.scrolloff = 8

opt.sidescrolloff = 8

opt.ignorecase = true
opt.smartcase = true

opt.wrap = false

opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true

opt.splitright = true
opt.splitbelow = true

opt.timeoutlen = 300

opt.updatetime = 200

opt.completeopt = {
    "menu",
    "menuone",
    "noselect",
}

--------------------------------------------------
-- Theme
--------------------------------------------------

vim.cmd.colorscheme("srcery")

--------------------------------------------------
-- Which-Key
--------------------------------------------------

require("which-key").setup({
    preset = "modern",
    delay = 200,
})



--------------------------------------------------
-- GitSigns
--------------------------------------------------

require("gitsigns").setup()

--------------------------------------------------
-- Todo Comments
--------------------------------------------------

require("todo-comments").setup()

--------------------------------------------------
-- AutoPairs
--------------------------------------------------

require("nvim-autopairs").setup()

--------------------------------------------------
-- Oil
--------------------------------------------------

require("oil").setup({

    default_file_explorer = true,

    columns = {
        "icon",
        "permissions",
        "size",
    },

    delete_to_trash = true,

    skip_confirm_for_simple_edits = true,

    view_options = {
        show_hidden = true,
    },

    float = {
        border = "rounded",
    },

})

require("nvim-web-devicons").setup({
    default = true,
})

vim.keymap.set(
    "n",
    "-",
    "<CMD>Oil<CR>",
    { desc = "Parent Directory" }
)

vim.keymap.set(
    "n",
    "<leader>e",
    "<CMD>Oil --float<CR>",
    { desc = "Explorer" }
)

--------------------------------------------------
-- Telescope
--------------------------------------------------

local telescope = require("telescope")

telescope.setup({

    defaults = {

        layout_strategy = "horizontal",

        sorting_strategy = "ascending",

        layout_config = {

            prompt_position = "top",

        },

        file_ignore_patterns = {
            ".git/",
            "build/",
            "dist/",
            "target/",
        },

    },

})

pcall(telescope.load_extension, "fzf")

local builtin = require("telescope.builtin")

vim.keymap.set(
    "n",
    "<leader>ff",
    builtin.find_files,
    { desc = "Find Files" }
)

vim.keymap.set(
    "n",
    "<leader>fg",
    builtin.live_grep,
    { desc = "Live Grep" }
)

vim.keymap.set(
    "n",
    "<leader>fb",
    builtin.buffers,
    { desc = "Buffers" }
)

vim.keymap.set(
    "n",
    "<leader>fh",
    builtin.help_tags,
    { desc = "Help Tags" }
)

vim.keymap.set(
    "n",
    "<leader>fr",
    builtin.oldfiles,
    { desc = "Recent Files" }
)

vim.keymap.set(
    "n",
    "<leader>fs",
    builtin.lsp_document_symbols,
    { desc = "Document Symbols" }
)

vim.keymap.set(
    "n",
    "<leader>fw",
    builtin.lsp_dynamic_workspace_symbols,
    { desc = "Workspace Symbols" }
)

--------------------------------------------------
-- Blink Completion
--------------------------------------------------

require("blink.cmp").setup({

    keymap = {
        preset = "default",
    },

    appearance = {
        nerd_font_variant = "mono",
    },

    completion = {

        documentation = {

            auto_show = true,
            auto_show_delay_ms = 200,

        },

        menu = {
            border = "rounded",
        },
    },

    signature = {
        enabled = true,
    },

    sources = {

        default = {

            "lsp",
            "path",
            "buffer",
            "snippets",

        },

    },

    fuzzy = {
        implementation = "prefer_rust_with_warning",
    },

})

--------------------------------------------------
-- LSP
--------------------------------------------------

vim.lsp.enable({
    "lua_ls",
    "clangd",
    "rust_analyzer",
    "cmake",
})

vim.lsp.config("lua_ls", {
    cmd = { "lua-language-server" },
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = {
                enable = false,
            },
        },
    },
})

vim.lsp.config("clangd", {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--completion-style=detailed",
        "--header-insertion=iwyu",
    },
})

vim.lsp.config("rust_analyzer", {
    cmd = { "rust-analyzer" },
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                allFeatures = true,
            },
            checkOnSave = true,
        },
    },
})

vim.lsp.config("cmake", {
    cmd = { "cmake-language-server" },
})

--------------------------------------------------
-- Diagnostics
--------------------------------------------------

vim.diagnostic.config({

    underline = true,

    virtual_text = {

        spacing = 4,

        source = "if_many",

    },

    signs = true,

    severity_sort = true,

    update_in_insert = false,

    float = {
        border = "rounded",
        source = "always",

    },

})

--------------------------------------------------
-- LSP Attach
--------------------------------------------------

local lsp_group =
    vim.api.nvim_create_augroup("MyLsp", {})

vim.api.nvim_create_autocmd("LspAttach", {

    group = lsp_group,

    callback = function(event)
        local opts = {
            buffer = event.buf,
            silent = true,
        }

        --------------------------------------------------
        -- Navigation
        --------------------------------------------------

        vim.keymap.set(
            "n",
            "gd",
            vim.lsp.buf.definition,
            vim.tbl_extend("force", opts, {
                desc = "Goto Definition",
            })
        )

        vim.keymap.set(
            "n",
            "gD",
            vim.lsp.buf.declaration,
            vim.tbl_extend("force", opts, {
                desc = "Goto Declaration",
            })
        )

        vim.keymap.set(
            "n",
            "gr",
            vim.lsp.buf.references,
            vim.tbl_extend("force", opts, {
                desc = "References",
            })
        )

        vim.keymap.set(
            "n",
            "gi",
            vim.lsp.buf.implementation,
            vim.tbl_extend("force", opts, {
                desc = "Implementation",
            })
        )

        vim.keymap.set(
            "n",
            "gt",
            vim.lsp.buf.type_definition,
            vim.tbl_extend("force", opts, {
                desc = "Type Definition",
            })
        )

        --------------------------------------------------
        -- Documentation
        --------------------------------------------------

        vim.keymap.set(
            "n",
            "K",
            vim.lsp.buf.hover,
            vim.tbl_extend("force", opts, {
                desc = "Hover",
            })
        )

        vim.keymap.set(
            "n",
            "<C-k>",
            vim.lsp.buf.signature_help,
            vim.tbl_extend("force", opts, {
                desc = "Signature Help",
            })
        )

        --------------------------------------------------
        -- Actions
        --------------------------------------------------

        vim.keymap.set(
            "n",
            "<leader>rn",
            vim.lsp.buf.rename,
            vim.tbl_extend("force", opts, {
                desc = "Rename",
            })
        )

        vim.keymap.set(
            { "n", "v" },
            "<leader>ca",
            vim.lsp.buf.code_action,
            vim.tbl_extend("force", opts, {
                desc = "Code Action",
            })
        )

        --------------------------------------------------
        -- Diagnostics
        --------------------------------------------------

        vim.keymap.set(
            "n",
            "[d",
            vim.diagnostic.goto_prev,
            vim.tbl_extend("force", opts, {
                desc = "Previous Diagnostic",
            })
        )

        vim.keymap.set(
            "n",
            "]d",
            vim.diagnostic.goto_next,
            vim.tbl_extend("force", opts, {
                desc = "Next Diagnostic",
            })
        )

        vim.keymap.set(
            "n",
            "<leader>d",
            vim.diagnostic.open_float,
            vim.tbl_extend("force", opts, {
                desc = "Line Diagnostics",
            })
        )

        --------------------------------------------------
        -- Inlay Hints
        --------------------------------------------------

        if vim.lsp.inlay_hint then
            vim.keymap.set(
                "n",
                "<leader>ih",
                function()
                    vim.lsp.inlay_hint.enable(
                        not vim.lsp.inlay_hint.is_enabled()
                    )
                end,
                vim.tbl_extend("force", opts, {
                    desc = "Toggle Inlay Hints",
                })
            )
        end
    end,

})


--------------------------------------------------
-- Gitsigns (Git in sign column)
--------------------------------------------------

require("gitsigns").setup({

    signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
    },

})

--------------------------------------------------
-- Better UI for diagnostics
--------------------------------------------------

vim.diagnostic.config({

    virtual_text = {
        spacing = 4,
        prefix = "●",
    },

    float = {
        border = "rounded",
        source = "if_many",
    },

    signs = true,
    underline = true,
    severity_sort = true,

})

--------------------------------------------------
-- Buffer navigation
--------------------------------------------------

vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { desc = "Prev buffer" })
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })

vim.keymap.set("n", "<leader>bd", ":bd<CR>", { desc = "Delete buffer" })

--------------------------------------------------
-- Window navigation
--------------------------------------------------

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

--------------------------------------------------
-- Window resizing
--------------------------------------------------

vim.keymap.set("n", "<C-Up>", ":resize +2<CR>")
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>")
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>")
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>")

--------------------------------------------------
-- Clear search highlight
--------------------------------------------------

vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>")

--------------------------------------------------
-- Quick save / quit
--------------------------------------------------

vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })

--------------------------------------------------
-- Terminal toggle (simple)
--------------------------------------------------

vim.keymap.set("n", "<leader>t", function()
    vim.cmd("split | terminal")
end, { desc = "Open terminal" })

--------------------------------------------------
-- Telescope LSP integrations
--------------------------------------------------

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ld", builtin.lsp_definitions, { desc = "LSP Definitions" })
vim.keymap.set("n", "<leader>lr", builtin.lsp_references, { desc = "LSP References" })
vim.keymap.set("n", "<leader>ls", builtin.lsp_document_symbols, { desc = "LSP Symbols" })
vim.keymap.set("n", "<leader>lw", builtin.lsp_dynamic_workspace_symbols, { desc = "Workspace Symbols" })

--------------------------------------------------
-- File search shortcuts
--------------------------------------------------

vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "Resume search" })
vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "Commands" })

--------------------------------------------------
-- Auto-format (safe LSP formatting)
--------------------------------------------------

vim.api.nvim_create_autocmd("BufWritePre", {

    callback = function(args)
        local clients = vim.lsp.get_clients({ bufnr = args.buf })

        if #clients == 0 then
            return
        end

        vim.lsp.buf.format({

            bufnr = args.buf,

            timeout_ms = 2000,

            async = false,

            filter = function(client)
                return client.supports_method("textDocument/formatting")
            end,

        })
    end,

})

--------------------------------------------------
-- Highlight on yank
--------------------------------------------------

vim.api.nvim_create_autocmd("TextYankPost", {

    callback = function()
        vim.highlight.on_yank({
            timeout = 150,
        })
    end,

})

--------------------------------------------------
-- Remove trailing whitespace on save
--------------------------------------------------

vim.api.nvim_create_autocmd("BufWritePre", {

    pattern = "*",

    callback = function()
        local pos = vim.api.nvim_win_get_cursor(0)
        vim.cmd([[%s/\s\+$//e]])
        vim.api.nvim_win_set_cursor(0, pos)
    end,

})

--------------------------------------------------
-- LSP UI improvements
--------------------------------------------------

vim.lsp.config("*", {
    handlers = {
        ["textDocument/hover"] = function(_, result, ctx, config)
            config = config or {}
            config.border = "rounded"
            return vim.lsp.handlers.hover(_, result, ctx, config)
        end,

        ["textDocument/signatureHelp"] = function(_, result, ctx, config)
            config = config or {}
            config.border = "rounded"
            return vim.lsp.handlers.signature_help(_, result, ctx, config)
        end,
    },
})

--------------------------------------------------
-- Better diagnostics navigation UI
--------------------------------------------------

vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })

--------------------------------------------------
-- Global escape improvements
--------------------------------------------------

vim.keymap.set({ "i", "n", "v" }, "<C-c>", "<Esc>")

--------------------------------------------------
-- Disable arrow keys (force hjkl discipline)
--------------------------------------------------

vim.keymap.set({ "n", "i", "v" }, "<Up>", "<Nop>")
vim.keymap.set({ "n", "i", "v" }, "<Down>", "<Nop>")
vim.keymap.set({ "n", "i", "v" }, "<Left>", "<Nop>")
vim.keymap.set({ "n", "i", "v" }, "<Right>", "<Nop>")

--------------------------------------------------
-- Neovide support
--------------------------------------------------

if vim.g.neovide then
    vim.g.neovide_scale_factor = 1.0

    vim.keymap.set("n", "<C-+>", function()
        vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
    end)

    vim.keymap.set("n", "<C-->", function()
        vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1
    end)

    vim.keymap.set("n", "<C-0>", function()
        vim.g.neovide_scale_factor = 1.0
    end)

    vim.opt.guifont = "JetBrainsMono Nerd Font:h12"
end

--------------------------------------------------
-- Final UX polish
--------------------------------------------------

vim.opt.updatetime = 200
vim.opt.timeoutlen = 300
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true

--------------------------------------------------
-- Done
--------------------------------------------------

print("Neovim config loaded successfully")
