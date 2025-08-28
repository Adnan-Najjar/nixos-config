---@diagnostic disable: undefined-global
vim.g.mapleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.have_nerd_font = true
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.inccommand = "split"
vim.opt.winborder = "rounded"
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.showtabline = 2
vim.opt.showmode = false
vim.opt.laststatus = 3

-- Tab management
vim.keymap.set("n", "<A-1>", ":tabnext 1<cr>")
vim.keymap.set("n", "<A-2>", ":tabnext 2<cr>")
vim.keymap.set("n", "<A-3>", ":tabnext 3<cr>")
vim.keymap.set("n", "<A-4>", ":tabnext 4<cr>")
vim.keymap.set("n", "<A-w>", ":tabclose<cr>")
vim.keymap.set("n", "<A-a>", ":tabnew<cr>")
vim.keymap.set("n", "<A-n>", ":tabnext<cr>")
-- Window management
vim.keymap.set("n", "<C-h>", "<c-w><c-h>")
vim.keymap.set("n", "<C-l>", "<c-w><c-l>")
vim.keymap.set("n", "<C-j>", "<c-w><c-j>")
vim.keymap.set("n", "<C-k>", "<c-w><c-k>")
vim.keymap.set("n", "<C-w>g", ":vert sball<cr>", { desc = "Split all buffers" })
vim.keymap.set("n", "<C-w>t", ":tab sball<cr>", { desc = "Tab all splits" })

-- Quality of Life
vim.cmd([[
  ca Q q
  ca W w
  ca Wq wq
]])
vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv")
vim.keymap.set({ "n", "v" }, "<leader>d", [[d]])
vim.keymap.set({ "n", "v" }, "d", [["_d]])
vim.keymap.set("x", "p", [["_dP]])
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- Highlight when copying text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Gitsgins
require('gitsigns').setup {
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
	},
}
-- Theme
require("tokyonight").setup()
vim.cmd.colorscheme("tokyonight-night")
vim.cmd([[ highlight Normal ctermbg=none guibg=none ]])
-- Lualine
require('lualine').setup()
-- Picker
require("mini.pick").setup()
vim.keymap.set("n", "<leader>f", ":Pick files<CR>")
vim.keymap.set("n", "<leader>b", ":Pick buffers<CR>")
-- File explorer
require("mini.files").setup({
	mappings = {
		close = '<esc>',
		synchronize = 's',
		go_in_plus = "<CR>",
	},
})
vim.keymap.set("n", "<leader>e", function() require("mini.files").open(vim.api.nvim_buf_get_name(0), true) end)
vim.keymap.set("n", "<leader>E", ":Open .<CR>")
-- Undotree
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
-- Load Supermaven on keybind
vim.keymap.set("n", "<leader>m", function()
	require("supermaven-nvim").setup({
		log_level = "off",
		keymaps = {
			accept_word = "<C-e>",
		},
		disable_keymaps = true
	})
end)
-- Toggle Terminal
local term_buf = nil
local term_win = nil
vim.keymap.set({ "n", "t" }, "<leader><leader>", function()
	if term_win and vim.api.nvim_win_is_valid(term_win) then
		if vim.api.nvim_get_current_win() == term_win then
			vim.cmd.hide()
		else
			vim.api.nvim_set_current_win(term_win)
			vim.cmd.startinsert()
		end
		return
	end
	if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
		vim.cmd.split()
		vim.cmd.wincmd("J")
		vim.api.nvim_win_set_height(0, 10)
		vim.api.nvim_win_set_buf(0, term_buf)
		term_win = vim.api.nvim_get_current_win()
		vim.cmd.startinsert()
		return
	end
	vim.cmd.split()
	vim.cmd.term()
	vim.cmd.wincmd("J")
	vim.api.nvim_buf_set_name(0, "Toggle Terminal")
	vim.api.nvim_win_set_height(0, 10)
	term_win = vim.api.nvim_get_current_win()
	term_buf = vim.api.nvim_get_current_buf()
	vim.fn.chansend(vim.b.terminal_job_id, "clear\n")
	vim.cmd.startinsert()
end)
-- Tab Terminal
vim.keymap.set("n", "<A-t>", function()
	vim.cmd.tabnew()
	vim.cmd.term()
	vim.api.nvim_buf_set_name(0, "Tab Terminal")
	vim.cmd.startinsert()
end)
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
vim.cmd("highlight! link NormalNC Normal")

-- LSP setup
vim.diagnostic.config({
	virtual_text = true,
	underline = true,
	signs = true,
})
-- Mason setup
require("mason-lspconfig").setup()
require("mason-tool-installer").setup()
-- Treesitter setup
require("nvim-treesitter.install").prefer_git = true
require("nvim-treesitter.install").compilers = { "zig", "gcc" }
require("nvim-treesitter.configs").setup {
	auto_install = true,
	highlight = {
		enable = true,
	},
	indent = { enable = true },
}
-- LSP completion setup
require("blink.cmp").setup({
	signature = { enabled = true },
	fuzzy = {
		implementation = "lua",
	},
	completion = {
		documentation = { auto_show = true, auto_show_delay_ms = 500 },
		menu = {
			auto_show = true,
			draw = {
				treesitter = { "lsp" },
				columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
			},
		},
	},
})
-- LSP keymaps
vim.keymap.set("n", "<leader>l", vim.lsp.buf.format)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
-- Disable LSP errors on keybind
local isLspDiagnosticsVisible = true
vim.keymap.set("n", "<leader>h", function()
	isLspDiagnosticsVisible = not isLspDiagnosticsVisible
	vim.diagnostic.config({
		virtual_text = isLspDiagnosticsVisible,
		underline = isLspDiagnosticsVisible,
		signs = true,
	})
end)
