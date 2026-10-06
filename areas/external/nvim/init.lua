local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", "https://github.com/folke/lazy.nvim.git",
        lazypath })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader, vim.g.maplocalleader = " ", " "
vim.g.loaded_netrw, vim.g.loaded_netrwPlugin = 1, 1
vim.opt.clipboard, vim.opt.undofile = "unnamedplus", true
vim.opt.number, vim.opt.relativenumber = true, true
vim.opt.shiftwidth, vim.opt.expandtab = 4, true
vim.opt.autoindent, vim.opt.smartindent = true, true
vim.opt.shortmess:append("I")

vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function() vim.lsp.buf.format({ timeout_ms = 500 }) end,
})

require("lazy").setup({
    {
        "neovim/nvim-lspconfig",
        dependencies = { "saghen/blink.cmp" },
        config = function()
            vim.lsp.config("*", {
                capabilities = require("blink.cmp").get_lsp_capabilities(),
            })

            vim.lsp.config.nixd = {
                settings = {
                    nixd = {
                        nixpkgs = { expr = "import <nixpkgs> {}" },
                        formatting = { command = { "alejandra" } },
                    },
                },
            }

            for _, s in ipairs({ "nixd", "lua_ls", "rust_analyzer" }) do
                vim.lsp.enable(s)
            end
            vim.lsp.inlay_hint.enable(true)
        end,
    },
    {
        "saghen/blink.cmp",
        version = "1.*",
        opts = {
            keymap = { preset = "default" },
            sources = { default = { "lsp", "path", "snippets", "buffer" } },
        },
    },
    { "echasnovski/mini.pairs",    opts = {} },
    { "echasnovski/mini.icons",    opts = {} },
    { "echasnovski/mini.surround", version = "*", opts = {} },
    {
        "EdenEast/nightfox.nvim",
        priority = 1000,
        opts = { options = { transparent = true } },
        config = function(_, opts)
            require("nightfox").setup(opts)
            vim.cmd.colorscheme("nordfox")
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(a) pcall(vim.treesitter.start, a.buf) end,
            })
        end,
    },
    {
        "FylerOrg/fyler.nvim",
        opts = {},
        keys = { { "-", "<cmd>Fyler<cr>" } },
        init = function()
            vim.api.nvim_create_autocmd("VimEnter", {
                callback = function()
                    local p = vim.fn.argv(0)
                    if vim.fn.isdirectory(p) == 1 then require("fyler").open({ root_path = vim.fn.fnamemodify(p, ":p") }) end
                end,
            })
        end,
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            { "<leader><space>", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
            { "<leader>c",       mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        },
    },
    {
        "ibhagwan/fzf-lua",
        keys = {
            { "<leader>ff", "<cmd>FzfLua files<cr>",     desc = "Files" },
            { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Grep" },
        },
    },
})
