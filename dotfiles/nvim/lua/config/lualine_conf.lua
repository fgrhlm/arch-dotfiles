require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        component_separators = {},
        section_separators = {},
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {},
        lualine_z = {}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    },
}
