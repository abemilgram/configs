-- leader must be set before any mappings
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- nvim-tree replaces netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- rebuild treesitter parsers whenever nvim-treesitter is installed/updated
vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
            if not ev.data.active then vim.cmd.packadd("nvim-treesitter") end
            vim.cmd("TSUpdate")
        end
    end,
})

-- plugins (built-in plugin manager; update with :lua vim.pack.update())
local gh = function(x) return "https://github.com/" .. x end
vim.pack.add({
    gh("nvim-lua/plenary.nvim"),
    gh("nvim-tree/nvim-web-devicons"),
    gh("nvim-tree/nvim-tree.lua"),
    gh("ojroques/nvim-hardline"),
    gh("ms-jpq/coq_nvim"),
    gh("ms-jpq/coq.artifacts"),
    gh("EdenEast/nightfox.nvim"),
    gh("windwp/nvim-autopairs"),
    gh("lewis6991/gitsigns.nvim"),
    gh("nvim-telescope/telescope.nvim"),
    { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },
    gh("neovim/nvim-lspconfig"),
    gh("mason-org/mason.nvim"),
    gh("mason-org/mason-lspconfig.nvim"),
}, { confirm = false })

-- start coq completion automatically
require("coq").setup {}

require("nvim-autopairs").setup {}
require("gitsigns").setup {}
require("nvim-tree").setup {}

require('hardline').setup {
    bufferline = true,
    bufferline_settings = {
        exclude_terminal = false,
        show_index = true,
    },
    theme = 'nordic',
}

-- LSP: mason installs servers, mason-lspconfig enables them
require("mason").setup {}
require("mason-lspconfig").setup {
    ensure_installed = { "pyright" },
}
vim.diagnostic.config({ virtual_text = true })

-- treesitter: parsers + highlighting/indent for any filetype with a parser
require("nvim-treesitter").install {
    "bash", "css", "html", "javascript", "json", "lua", "markdown",
    "markdown_inline", "python", "query", "toml", "tsx", "typescript",
    "vim", "vimdoc", "yaml",
}
vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
        if pcall(vim.treesitter.start, ev.buf) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end,
})

-- file tree
vim.keymap.set("n", "<C-f>", ":NvimTreeToggle<CR>", {})

-- telescope
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", telescope.find_files, {})
vim.keymap.set("n", "<leader>fg", telescope.live_grep, {})
vim.keymap.set("n", "<leader>fb", telescope.buffers, {})
vim.keymap.set("n", "<leader>fh", telescope.help_tags, {})

-- LSP (nvim also maps K hover, grn rename, gra code action, grr references)
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})

vim.keymap.set("n", "<leader>bn", ":bn<CR>", {})
vim.keymap.set("n", "<leader>bd", ":bd<CR>", {})
vim.keymap.set("n", "<leader><SPACE>", ":noh<CR>", {})
vim.keymap.set("n", "<leader>ce", function() vim.cmd.edit(vim.fn.stdpath("config") .. "/init.lua") end, {})


local o = vim.opt
o.number = true
o.relativenumber = true
o.mouse = 'a'
o.termguicolors = true
o.autoindent = true
o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.smarttab = true
o.expandtab = true
o.scrolloff = 8
o.sidescrolloff = 8
o.splitbelow = true
o.splitright = true
o.cursorline = true
o.ignorecase = true
o.smartcase = true
o.wrap = false
o.clipboard = 'unnamedplus'
o.undofile = true

vim.cmd('colorscheme nordfox')
