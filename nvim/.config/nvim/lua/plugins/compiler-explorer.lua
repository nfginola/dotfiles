return {
	{
		'krady21/compiler-explorer.nvim',
		dependencies = { 'stevearc/dressing.nvim' },
		cmd = {
			'CECompile',
			'CECompileLive',
			'CEFormat',
			'CEAddLibrary',
			'CELoadExample',
			'CEOpenWebsite',
			'CEDeleteCache',
			'CEShowTooltip',
			'CEGotoLabel',
		},
		keys = {
			{ '<Leader>ct', '<cmd>CEShowTooltip<cr>', desc = '[C]ompiler Explorer [T]ooltip' },
		},
		config = function()
			require('compiler-explorer').setup({
				url = 'https://godbolt.org',
				infer_lang = true,
				line_match = {
					highlight = false,
					jump = false,
				},
				open_qflist = false,
				split = 'split',
				compiler_flags = '',
				job_timeout_ms = 25000,
				languages = {
					--c = {
					--  compiler = 'g121',
					--  compiler_flags = '-O2 -Wall',
					--},
				},
			})
		end,
	},
}
