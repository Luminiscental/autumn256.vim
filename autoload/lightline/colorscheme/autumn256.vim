let s:base03 = [ '#151513', 233 ]
let s:base02 = [ '#30302c', 236 ]
let s:base01 = [ '#4e4e43', 239 ]
let s:base00 = [ '#666656', 242  ]

let s:base0 = [ '#808070', 244 ]
let s:base1 = [ '#949484', 246 ]
let s:base2 = [ '#a8a897', 248 ]
let s:base3 = [ '#e8e8d3', 253 ]

let s:normal = [ '#798d50', 103 ]
let s:insert = [ '#babd4a', 107 ]
let s:replace = [ '#cf6a4c', 167 ]
let s:visual = ['#ff6f6f', 217]
let s:error = [ '#8b4147', 167 ]
let s:warning = [ '#755b24', 215 ]

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}
let s:p.normal.left = [ [ s:base02, s:normal ], [ s:base3, s:base01 ] ]
let s:p.normal.right = [ [ s:base02, s:base1 ], [ s:base2, s:base01 ] ]
let s:p.inactive.right = [ [ s:base02, s:base00 ], [ s:base0, s:base02 ] ]
let s:p.inactive.left =  [ [ s:base0, s:base02 ], [ s:base00, s:base02 ] ]
let s:p.insert.left = [ [ s:base02, s:insert ], [ s:base3, s:base01 ] ]
let s:p.replace.left = [ [ s:base02, s:replace ], [ s:base3, s:base01 ] ]
let s:p.visual.left = [ [ s:base02, s:visual ], [ s:base3, s:base01 ] ]
let s:p.normal.middle = [ [ s:base0, s:base02 ] ]
let s:p.inactive.middle = [ [ s:base00, s:base02 ] ]
let s:p.tabline.left = copy(s:p.normal.middle)
let s:p.tabline.tabsel = [ [ s:base3, s:base00 ] ]
let s:p.tabline.middle = copy(s:p.normal.middle)
let s:p.tabline.right = copy(s:p.tabline.middle)
let s:p.normal.error = [ [ s:error, s:base02 ] ]
let s:p.normal.warning = [ [ s:warning, s:base01 ] ]

let g:lightline#colorscheme#autumn256#palette = lightline#colorscheme#flatten(s:p)
