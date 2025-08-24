return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			direction = "float",
			float_opts = {
				border = "curved",
			},
		})

		-- Keymap: <leader>rr to run current cpp file
		vim.keymap.set("n", "<leader>rr", function()
			-- Always save buffer first
			vim.cmd("w")
			local file = vim.fn.expand("%:p") -- full path to current file
			local name = vim.fn.expand("%:t:r") -- filename without extension
			local dir = vim.fn.getcwd() -- project root
			local bin_dir = dir .. "/.bin"

			-- Ensure .bin exists
			vim.fn.mkdir(bin_dir, "p")

			-- Build command
			local cmd = string.format("g++ -std=c++17 -O2 %s -o %s/%s && %s/%s", file, bin_dir, name, bin_dir, name)

			require("toggleterm.terminal").Terminal
				:new({ cmd = cmd, direction = "float", close_on_exit = false })
				:toggle()
		end, { desc = "Run current C++ file in floating terminal" })
	end,
}
