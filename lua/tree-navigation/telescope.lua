local M = {}

M.navigate_to = function(nodes)

    local function navigate_to(prompt_bufnr)
        local content = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
        require("telescope.actions").close(prompt_bufnr)

        local node = nodes:find_by_name(content.value)
        local row, col = node:range()

        vim.api.nvim_win_set_cursor(0, {row + 1, col + 1})
    end

    local names = nodes:names()
	require("telescope.pickers").new({}, {
		prompt_title = "navigation",
		finder = require("telescope.finders").new_table({
			results = names,
		}),
		sorter = require("telescope.config").values.generic_sorter({}),
		attach_mappings = function(_, map)
			map("i", "<CR>", navigate_to)
			map("n", "<CR>", navigate_to)
			return true
		end,
	}):find()
end

return M
