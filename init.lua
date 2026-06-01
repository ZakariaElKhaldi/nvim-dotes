vim.pack.add({
	'https://github.com/nvim-telescope/telescope.nvim.git',
	'https://github.com/neovim/nvim-lspconfig.git',
	'https://github.com/mason-org/mason.nvim.git',
	--theme
	'https://github.com/srcery-colors/srcery-vim.git',
	'https://github.com/tjdevries/colorbuddy.nvim.git',
	'https://github.com/datsfilipe/vesper.nvim.git',
	'https://github.com/ayu-theme/ayu-vim.git',
})

vim.g.mapleader = " "
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true

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
  },})
vim.keymap.set('n', '<leader>w', vim.diagnostic.open_float)
