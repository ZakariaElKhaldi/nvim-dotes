vim.g.mapleader = " "

vim.pack.add({
	'https://github.com/neovim/nvim-lspconfig.git',
	'https://github.com/mason-org/mason.nvim.git',
	--theme
	'https://github.com/srcery-colors/srcery-vim.git',
	'https://github.com/tjdevries/colorbuddy.nvim.git',
	'https://github.com/datsfilipe/vesper.nvim.git',
	'https://github.com/ayu-theme/ayu-vim.git',

	'https://github.com/nvim-mini/mini.nvim',
	'https://github.com/nvim-tree/nvim-web-devicons', -- if you prefer nvim-web-devicons

	'https://github.com/nvim-lua/plenary.nvim',
	'https://github.com/nvim-telescope/telescope.nvim',
	'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
})

require('telescope').setup{}
require('mini.files').setup()

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

vim.keymap.set("n", "<leader><leader>", function()
	MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
	MiniFiles.reveal_cwd()
end, { desc = "Toggle into currently opened file" })

vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.clipboard = 'unnamedplus'
vim.o.ignorecase = true
vim.o.smartcase = true

--vim.cmd.colorscheme('srcery')
--vim.cmd.colorscheme("colorbuddy")
--vim.cmd.colorscheme('vesper')
vim.cmd.colorscheme('ayu')

vim.o.autocomplete = true
vim.opt.complete:append('o')
vim.opt.completeopt = {
	"menu",
	"menuone",
	"noselect",
	"popup",
	"fuzzy",
}

require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗"
		}
	}
})

vim.lsp.config['clangd'] = {
	cmd = { 'clangd' },
	filetypes = { 'c', 'cpp', 'h' },
}

vim.lsp.config('lua_ls', {
	cmd = { "lua-language-server" },
	filetypes = { 'lua' },
})

vim.lsp.enable('lua_ls')
vim.lsp.enable('clangd')

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(ev)
		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end

		if not client:supports_method('textDocument/willSaveWaitUntil')
		    and client:supports_method('textDocument/formatting') then
			vim.api.nvim_create_autocmd('BufWritePre', {
				group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
				buffer = ev.buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
				end,
			})
		end
	end,
})

vim.diagnostic.enable()
vim.diagnostic.config({
	float = {
		border = "rounded",
	},
	virtual_text = {
		severity = vim.diagnostic.severity.ERROR,
	},
})
vim.keymap.set('n', '<leader>w', vim.diagnostic.open_float)

if vim.g.neovide then
	vim.g.neovide_scale_factor = 1.0

	vim.keymap.set("n", "<C-=>", function()
		vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
	end)

	vim.keymap.set("n", "<C-->", function()
		vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1
	end)

	vim.keymap.set("n", "<C-0>", function()
		vim.g.neovide_scale_factor = 1.0
	end)
end
