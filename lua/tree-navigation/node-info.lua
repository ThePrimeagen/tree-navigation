local config = require("tree-navigation.config")

local NodeInfo = {}
NodeInfo.__index = NodeInfo

NodeInfo.Method = 1
NodeInfo.Class = 2

--- Instead of using a table I am just using a nice named class to keep
--- track of nodes + bufnr + ft
---@return NodeInfo
function NodeInfo:new(nodes, bufnr, ft, type)

    -- todo: is col correct?
    return setmetatable({
        bufnr = bufnr,
        ft = ft,
        nodes = nodes,
        type = type,
    }, self)

end

function NodeInfo:names()
    local lang = config.get_lang(self.ft);
    print("self", self.type)
    if self.type == NodeInfo.Method then
        return vim.tbl_map(function(node)
            return lang.get_method_name(node)
        end, self.nodes)
    end

    return "NOT FOUND"
end

function NodeInfo:locations()
    return vim.tbl_map(function(node)
        return {node:range()}
    end, self.nodes)
end

-- wont work with overloaded methods as of now.
-- we could also include parameters as part of the name
function NodeInfo:find_by_name(name)
    local names = self:names()

    local idx = -1
    for i, n in ipairs(names) do
        if n == name then
            idx = i
            break
        end
    end

    return self.nodes[idx]
end

return NodeInfo
