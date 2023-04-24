require("dracula").setup({
	-- show the '~' characters after the end of buffers
	show_end_of_buffer = true, -- default false
	-- use transparent background
	transparent_bg = true, -- default false
	-- set italic comment
	italic_comment = true, -- default false
})

function ColorMyPencils(color)
	color = color or "dracula"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorMyPencils()

