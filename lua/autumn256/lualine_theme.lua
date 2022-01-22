local colors = {
  color2   = '#30302c',
  color3   = '#ff6f6f',
  color4   = '#e8e8d3',
  color5   = '#4e4e43',
  color8   = '#cf6a4c',
  color9   = '#666656',
  color10  = '#808070',
  color11  = '#798d50',
  color14  = '#babd4a',
}

return {
  visual = {
    a = { fg = colors.color2, bg = colors.color3, gui = 'bold' },
    b = { fg = colors.color4, bg = colors.color5 },
  },
  replace = {
    a = { fg = colors.color2, bg = colors.color8, gui = 'bold' },
    b = { fg = colors.color4, bg = colors.color5 },
  },
  inactive = {
    c = { fg = colors.color9, bg = colors.color2 },
    a = { fg = colors.color10, bg = colors.color2, gui = 'bold' },
    b = { fg = colors.color9, bg = colors.color2 },
  },
  normal = {
    c = { fg = colors.color10, bg = colors.color2 },
    a = { fg = colors.color2, bg = colors.color11, gui = 'bold' },
    b = { fg = colors.color4, bg = colors.color5 },
  },
  insert = {
    a = { fg = colors.color2, bg = colors.color14, gui = 'bold' },
    b = { fg = colors.color4, bg = colors.color5 },
  },
}
