local ts_utils = require("nvim-treesitter.ts_utils");
local parsers = require("nvim-treesitter.parsers");
local config = require("tree-navigation.config");
local NodeInfo = require("tree-navigation.node-info");

local function get_bufnr(bufnr)
    return bufnr or vim.api.nvim_get_current_buf()
end

local function filetype(bufnr)
    return vim.bo[bufnr].ft;
end

function get_root(filetype, bufnr)
    local parser = parsers.get_parser(bufnr, filetype)

    if not parser then
        error(
            "No treesitter parser found. Install one using :TSInstall <language>"
        )
    end

    return parser:parse()[1]:root()
end

local M = {}

local function walk_up_until(starting_node, type_name)
    local curr = starting_node

    while curr ~= nil and not vim.tbl_contains(type_name, curr:type()) do
        curr = curr:parent()
    end

    return curr
end

local function get_sexpr(name)
    return string.format("(%s) @tmp_capture", name)
end

local function find_occurrences(scope, sexpr, ft, bufnr)

    if not sexpr:find("@") then
        sexpr = sexpr .. " @tmp_capture"
    end

    local ok, sexpr_query = pcall(vim.treesitter.parse_query, ft, sexpr)
    if not ok then
        error(
            string.format("Invalid query: '%s'\n error: %s", sexpr, sexpr_query)
        )
    end

    local occurrences = {}
    for _, n in sexpr_query:iter_captures(scope, bufnr, 0, -1) do
        table.insert(occurrences, n)
    end

    return occurrences
end

function M:get_class_nodes(bufnr)
    bufnr = get_bufnr(bufnr)
    local ft = filetype(bufnr)

    local node = ts_utils.get_node_at_cursor()

    local class = config.get_class_list(ft)

    if not class then
        error("Your language has no configuration, make a pr you ignorant slut.")
    end

    local class_node = walk_up_until(node, class)
    if not class_node then
        return {}
    end

    local methods = config.get_method_list(ft)
    local defs = {}
    for _, method in ipairs(methods) do
        vim.list_extend(defs, find_occurrences(class_node, get_sexpr(method), ft, bufnr))
    end

    return NodeInfo:new(defs, bufnr, ft, NodeInfo.Method)
end

return M;

