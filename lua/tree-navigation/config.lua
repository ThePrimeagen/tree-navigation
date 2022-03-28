local ts_utils = require("nvim-treesitter.ts_utils")
local ts = {
    class = {
        "abstract_class_declaration",
        "class_declaration",
    },
    method = {
        "method_definition"
    },
    get_method_name = function(node)
        return ts_utils.get_node_text(node:field("name")[1])[1]
    end
};

local default_config = {
    typescript = ts,
    javascript = ts,
}

local M = {}

local config = {}

function M.setup(provided_config)
    config = vim.tbl_extend("force", {}, default_config, provided_config)
end

function M.get_class_list(ft)
    return config[ft].class
end

function M.get_method_list(ft)
    return config[ft].method
end

function M.get_lang(ft)
    return config[ft]
end

M.setup({})

return M
