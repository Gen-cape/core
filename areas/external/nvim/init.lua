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

vim.lsp.enable({ "nixd", "lua_ls", "rust_analyzer" })
vim.lsp.inlay_hint.enable(true)
vim.lsp.config("nixd", {
    settings = {
        nixd = {
            formatting = {
                command = { "alejandra" },
            },
        },
    },
})
vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function() vim.lsp.buf.format({ timeout_ms = 500 }) end,
})

require("lazy").setup({
    {
        "neovim/nvim-lspconfig",
        dependencies = { "Saghen/blink.cmp" },
        config = function()
        end,
    },
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
        "Saghen/blink.cmp",
        version = "*",
        opts = { keymap = { preset = "default" } },
        config = function(_, opts)
            require("blink.cmp").setup(opts)
            vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })
        end,
    },
    { "echasnovski/mini.icons",    opts = {} },
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
    { "echasnovski/mini.surround", version = "*", opts = {} },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            { "<leader><space>", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
            { "<C-Space>",       mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
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
