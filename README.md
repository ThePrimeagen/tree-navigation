### This is just a fun experimental library for TS Navigation
The main goal is for me to learn more about tree sitter and see how far I can
take the sweetness.

### Installation
Use your favorite plugin manager

```vim
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground' " you don't actually need this one, but its great for extending the plugin
Plug 'theprimeagen/tree-navigation'
```

### Navigate within a class
right now there isn't a way to just do everything instead everything is in pieces.

#### To get the nodes that represent the current class
```vim
:lua require("tree-navigation").get_class_nodes()
```

this will return a list of tree sitter node wrappers at the current edit of the
document.  Any changes to the document will invalidate the nodes.

#### To navigate based on a list of nodes
to open up telescope and to navigate you can use this
```vim
:lua require("tree-navigation.telescope").navigate_to(nodes)
```

### API of Node Wrapper
As of right now its pretty slim.

#### names
will return a list of names that contains the current selection

#### locations
the list of locations in the current document.

#### bufnr
the bufnr that these nodes were found on

#### type
the numeric value representing what type of nodes these are.  Used for
stringification.

