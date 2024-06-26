"
" -- autumn256.vim
"

set background=dark
if version > 580
    " no guarantees for version 5.8 and below, but this makes it stop
    " complaining
    hi clear
    if exists("syntax_on")
        syntax reset
    endif
endif
let g:colors_name="autumn256"

if has("gui_running") || &t_Co == 88 || &t_Co == 256
    " -- functions

    " returns an approximate grey index for the given grey level
    fun <SID>grey_number(x)
        if &t_Co == 88
            if a:x < 23
                return 0
            elseif a:x < 69
                return 1
            elseif a:x < 103
                return 2
            elseif a:x < 127
                return 3
            elseif a:x < 150
                return 4
            elseif a:x < 173
                return 5
            elseif a:x < 196
                return 6
            elseif a:x < 219
                return 7
            elseif a:x < 243
                return 8
            else
                return 9
            endif
        else
            if a:x < 14
                return 0
            else
                let l:n = (a:x - 8) / 10
                let l:m = (a:x - 8) % 10
                if l:m < 5
                    return l:n
                else
                    return l:n + 1
                endif
            endif
        endif
    endfun

    " returns the actual grey level represented by the grey index
    fun <SID>grey_level(n)
        if &t_Co == 88
            if a:n == 0
                return 0
            elseif a:n == 1
                return 46
            elseif a:n == 2
                return 92
            elseif a:n == 3
                return 115
            elseif a:n == 4
                return 139
            elseif a:n == 5
                return 162
            elseif a:n == 6
                return 185
            elseif a:n == 7
                return 208
            elseif a:n == 8
                return 231
            else
                return 255
            endif
        else
            if a:n == 0
                return 0
            else
                return 8 + (a:n * 10)
            endif
        endif
    endfun

    " returns the palette index for the given grey index
    fun <SID>grey_color(n)
        if &t_Co == 88
            if a:n == 0
                return 16
            elseif a:n == 9
                return 79
            else
                return 79 + a:n
            endif
        else
            if a:n == 0
                return 16
            elseif a:n == 25
                return 231
            else
                return 231 + a:n
            endif
        endif
    endfun

    " returns an approximate color index for the given color level
    fun <SID>rgb_number(x)
        if &t_Co == 88
            if a:x < 69
                return 0
            elseif a:x < 172
                return 1
            elseif a:x < 230
                return 2
            else
                return 3
            endif
        else
            if a:x < 75
                return 0
            else
                let l:n = (a:x - 55) / 40
                let l:m = (a:x - 55) % 40
                if l:m < 20
                    return l:n
                else
                    return l:n + 1
                endif
            endif
        endif
    endfun

    " returns the actual color level for the given color index
    fun <SID>rgb_level(n)
        if &t_Co == 88
            if a:n == 0
                return 0
            elseif a:n == 1
                return 139
            elseif a:n == 2
                return 205
            else
                return 255
            endif
        else
            if a:n == 0
                return 0
            else
                return 55 + (a:n * 40)
            endif
        endif
    endfun

    " returns the palette index for the given R/G/B color indices
    fun <SID>rgb_color(x, y, z)
        if &t_Co == 88
            return 16 + (a:x * 16) + (a:y * 4) + a:z
        else
            return 16 + (a:x * 36) + (a:y * 6) + a:z
        endif
    endfun

    " returns the palette index to approximate the given R/G/B color levels
    fun <SID>color(r, g, b)
        " get the closest grey
        let l:gx = <SID>grey_number(a:r)
        let l:gy = <SID>grey_number(a:g)
        let l:gz = <SID>grey_number(a:b)

        " get the closest color
        let l:x = <SID>rgb_number(a:r)
        let l:y = <SID>rgb_number(a:g)
        let l:z = <SID>rgb_number(a:b)

        if l:gx == l:gy && l:gy == l:gz
            " there are two possibilities
            let l:dgr = <SID>grey_level(l:gx) - a:r
            let l:dgg = <SID>grey_level(l:gy) - a:g
            let l:dgb = <SID>grey_level(l:gz) - a:b
            let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
            let l:dr = <SID>rgb_level(l:gx) - a:r
            let l:dg = <SID>rgb_level(l:gy) - a:g
            let l:db = <SID>rgb_level(l:gz) - a:b
            let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
            if l:dgrey < l:drgb
                " use the grey
                return <SID>grey_color(l:gx)
            else
                " use the color
                return <SID>rgb_color(l:x, l:y, l:z)
            endif
        else
            " only one possibility
            return <SID>rgb_color(l:x, l:y, l:z)
        endif
    endfun

    " returns the palette index to approximate the 'rrggbb' hex string
    fun <SID>rgb(rgb)
        let l:r = ("0x" . strpart(a:rgb, 0, 2)) + 0
        let l:g = ("0x" . strpart(a:rgb, 2, 2)) + 0
        let l:b = ("0x" . strpart(a:rgb, 4, 2)) + 0

        return <SID>color(l:r, l:g, l:b)
    endfun

    " sets the highlighting for the given group
    fun <SID>X(group, fg, bg, attr, sp)
        if a:fg != ""
            exec "hi " . a:group . " guifg=#" . a:fg . " ctermfg=" . <SID>rgb(a:fg)
        endif
        if a:bg != ""
            exec "hi " . a:group . " guibg=#" . a:bg . " ctermbg=" . <SID>rgb(a:bg)
        endif
        if a:attr != ""
            exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
        endif
        if a:sp != ""
            exec "hi " . a:group . " guisp=#" . a:sp
        endif
    endfun

    call <SID>X("Normal", "ead49b", "none", "none", "")
    call <SID>X("Cursor", "708090", "f0e68c", "", "")
    "CursorIM
    "ErrorMsg
    call <SID>X("SignColumn", "", "none", "none", "")
    call <SID>X("ColorColumn", "", "303030", "", "")
    call <SID>X("VertSplit", "c2bfa5", "7f7f7f", "reverse", "")
    call <SID>X("Folded", "666666", "303030", "", "")
    call <SID>X("FoldColumn", "666666", "303030", "", "")
    call <SID>X("IncSearch", "708090", "f0e68c", "", "")
    call <SID>X("LineNr", "9d6a47", "", "", "")
    call <SID>X("CursorLineNR", "9d6a47", "", "", "")
    call <SID>X("LineNrAbove", "564438", "", "", "")
    call <SID>X("LineNrBelow", "564438", "", "", "")
    call <SID>X("ModeMsg", "d4d4d4", "", "", "")
    call <SID>X("MoreMsg", "2e8b57", "", "", "")
    call <SID>X("NonText", "addbe7", "", "bold", "")
    call <SID>X("Question", "00ff7f", "", "", "")
    call <SID>X("Search", "f5deb3", "cd853f", "", "")
    call <SID>X("SpecialKey", "9acd32", "", "", "")
    call <SID>X("StatusLine", "c2bfa5", "000000", "reverse", "")
    call <SID>X("StatusLineNC", "c2bfa5", "7f7f7f", "reverse", "")
    call <SID>X("Title", "cd5c5c", "", "", "")
    call <SID>X("Visual", "d3d3d3", "3e3e3e", "reverse", "")
    call <SID>X("QuickFixLine", "c9a554", "", "", "")
    "VisualNOS
    call <SID>X("WarningMsg", "1e272b", "755b24", "", "")
    call <SID>X("ErrorMsg", "1e272b", "8b4147", "", "")
    "WildMenu
    call <SID>X("Directory", "848851", "263137", "", "")
    "Menu
    call <SID>X("Pmenu", "ead49b", "263137", "", "")
    call <SID>X("PmenuSel", "1e272b", "ead49b", "", "")
    "Scrollbar
    "Tooltip
    "Underlined

    " -- Code objects
    call <SID>X("Comment", "666666", "", "", "")
    call <SID>X("Constant", "af545b", "", "", "")
    call <SID>X("Identifier", "f8b279", "", "none", "")
    call <SID>X("Function", "c9a554", "", "", "")
    call <SID>X("Define", "936d43", "", "none", "")
    call <SID>X("Statement", "b36d43", "", "", "")
    call <SID>X("String", "78824b", "", "", "")
    call <SID>X("PreProc", "936d43", "", "", "")
    call <SID>X("Type", "9d6a47", "", "", "")
    call <SID>X("Special", "ead49b", "", "", "")
    call <SID>X("Operator", "ead49b", "", "", "")
    call <SID>X("Delimiter", "ead49b", "", "", "")
    call <SID>X("Member", "bad46b", "", "", "")
    call <SID>X("Variable", "ead49b", "", "", "")
    call <SID>X("Namespace", "cd6a47", "", "", "")
    call <SID>X("EnumConstant", "af545b", "", "", "")
    call <SID>X("Sneak", "", "666666", "", "")
    call <SID>X("Conceal", "bad46b", "none", "", "")
    call <SID>X("MatchParen", "333333", "666666", "", "")
    call <SID>X("Ignore", "666666", "", "", "")
    call <SID>X("Error", "ead49b", "8b4147", "", "")

    " -- python-syntax
    call <SID>X("pythonClassVar", "cb5f36", "", "", "")
    call <SID>X("pythonFunction", "c9a554", "", "", "")
    call <SID>X("pythonBuiltinFunc", "bad46b", "", "", "")
    call <SID>X("pythonImport", "564438", "", "", "")
    call <SID>X("pythonBuiltinType", "bad46b", "", "", "")

    " -- vimtex
    call <SID>X("texMathOper", "9d6a47", "", "", "")

    " -- LspCxx
    call <SID>X("LspCxxHlSymNamespace", "cd6a47", "", "", "")
    call <SID>X("LspCxxHlSymField", "a5b565", "", "", "")
    call <SID>X("LspCxxHlSymMethod", "c6e650", "", "", "")
    call <SID>X("LspCxxHlSymMacro", "af545b", "", "", "")

    " -- TODO and NOTE groups
    call <SID>X("Todo", "ffcc44", "none", "bold", "")
    call <SID>X("Note", "c6e650", "none", "bold", "")

    " -- clojure.vim
    call <SID>X("clojureSpecial", "564438", "", "", "")
    call <SID>X("clojureSymbol", "bad46b", "", "", "")

    " -- coc.nvim
    call <SID>X("CocHighlightText", "", "685742", "", "")
    call <SID>X("CocFadeOut", "666666", "", "underline", "")
    call <SID>X("CocErrorHighlight", "", "8b4147", "", "")
    call <SID>X("CocErrorSign", "8b4147", "", "", "")
    call <SID>X("CocWarningHighlight", "", "755b24", "", "")
    call <SID>X("CocWarningSign", "755b24", "", "", "")
    call <SID>X("CocInfoHighlight", "", "78824b", "", "")
    call <SID>X("CocInfoSign", "78824b", "", "", "")
    call <SID>X("CocHintHighlight", "", "", "underline", "")
    call <SID>X("CocHintSign", "bad46b", "", "", "")
    call <SID>X("CocCodeLens", "666666", "", "italic", "")
    call <SID>X("CocRustChainingHint", "666666", "", "italic", "")
    call <SID>X("CocRustTypeHint", "666666", "", "italic", "")

    " -- vimdiff
    call <SID>X("DiffAdd", "none", "283912", "", "")
    call <SID>X("DiffChange", "none", "615822", "", "")
    call <SID>X("DiffDelete", "1e272b", "522215", "", "")
    call <SID>X("DiffText", "none", "837b45", "underline", "ead49b")

    " -- git-signs
    call <SID>X("GitSignsAdd", "78824b", "", "", "")
    call <SID>X("GitSignsChange", "d9b554", "", "", "")
    call <SID>X("GitSignsDelete", "8b4147", "", "", "")

    " vim-illuminate
    call <SID>X("IlluminatedWordRead", "", "685742", "", "")
    call <SID>X("IlluminatedWordText", "", "685742", "", "")
    call <SID>X("IlluminatedWordWrite", "", "685742", "", "")

    " -- nvim-lsp
    call <SID>X("LspReferenceRead", "", "685742", "", "")
    call <SID>X("LspReferenceText", "", "685742", "", "")
    call <SID>X("LspReferenceWrite", "", "685742", "", "")

    call <SID>X("LspCodeLens", "666666", "", "italic", "")
    call <SID>X("LspCodeLensSeparator", "444444", "", "italic", "")

    call <SID>X("DiagnosticError", "8b4147", "", "", "")
    call <SID>X("DiagnosticSignError", "", "8b4147", "", "")
    call <SID>X("DiagnosticUnderlineError", "", "", "undercurl", "8b4147")

    call <SID>X("DiagnosticWarn", "755b24", "", "", "")
    call <SID>X("DiagnosticSignWarn", "", "755b24", "", "")
    call <SID>X("DiagnosticUnderlineWarn", "", "", "undercurl", "755b24")

    call <SID>X("DiagnosticInformation", "78824b", "", "", "")
    call <SID>X("DiagnosticSignInformation", "", "", "", "")
    call <SID>X("DiagnosticUnderlineInformation", "", "", "underline", "78824b")

    call <SID>X("DiagnosticHint", "ddc064", "", "", "")
    call <SID>X("DiagnosticSignHint", "", "", "", "")
    call <SID>X("DiagnosticUnderlineHint", "", "", "underline", "ddc064")

    " -- nvim-tree
    call <SID>X("NvimTreeFolderIcon", "c9a554", "", "", "")
    call <SID>X("NvimTreeIndentMarker", "666666", "", "", "")

    " -- nvim-treesitter
    call <SID>X("TSError", "", "", "undercurl", "662222")
    call <SID>X("TSNote", "c6e650", "", "bold", "")
    call <SID>X("TSWarning", "ffcc44", "", "bold", "")
    call <SID>X("TSDanger", "8b4147", "", "bold", "")
    call <SID>X("TSSymbol", "ead49b", "", "", "")
    call <SID>X("TSPunctBracket", "ead49b", "", "", "")
    call <SID>X("TSPunctSpecial", "ead49b", "", "", "")
    call <SID>X("TSNamespace", "936d43", "", "", "")
    call <SID>X("TSInclude", "564438", "", "", "")
    call <SID>X("TSAttribute", "ead49b", "", "", "")
    call <SID>X("TSType", "9d6a47", "", "", "")
    call <SID>X("TSTypeBuiltin", "9d6a47", "", "", "")
    call <SID>X("TSParameter", "f8b279", "", "", "")
    call <SID>X("TSParameterReference", "f8b279", "", "", "")
    call <SID>X("TSVariable", "f8b279", "", "", "")
    call <SID>X("TSVariableBuiltin", "cb5f36", "", "", "")
    call <SID>X("TSProperty", "f8b279", "", "", "")
    call <SID>X("TSField", "f8b279", "", "", "")
    call <SID>X("TSFunction", "c9a554", "", "", "")
    call <SID>X("TSMethod", "c9a554", "", "", "")
    call <SID>X("TSConstructor", "c9a554", "", "", "")
    call <SID>X("TSFuncMacro", "936d43", "", "", "")
    call <SID>X("TSFuncBuiltin", "bad46b", "", "", "")
    call <SID>X("TSKeyword", "b36d43", "", "", "")
    call <SID>X("TSRepeat", "b36d43", "", "", "")
    call <SID>X("TSKeywordFunction", "b36d43", "", "", "")
    call <SID>X("TSKeywordOperator", "b36d43", "", "", "")
    call <SID>X("TSKeywordReturn", "b36d43", "", "", "")
    call <SID>X("TSLabel", "b36d43", "", "", "")
    call <SID>X("TSException", "b36d43", "", "", "")
    call <SID>X("TSConditional", "b36d43", "", "", "")
    call <SID>X("TSComment", "666666", "", "", "")
    call <SID>X("TSString", "78824b", "", "", "")
    call <SID>X("TSStringRegex", "af545b", "", "", "")
    call <SID>X("TSStringEscape", "ead49b", "", "", "")
    call <SID>X("TSStringSpecial", "ead49b", "", "", "")
    call <SID>X("TSConstant", "af545b", "", "", "")
    call <SID>X("TSConstBuiltin", "af545b", "", "", "")
    call <SID>X("TSConstMacro", "af545b", "", "", "")
    call <SID>X("TSNumber", "af545b", "", "", "")
    call <SID>X("TSFloat", "af545b", "", "", "")
    call <SID>X("TSBoolean", "af545b", "", "", "")
    call <SID>X("TSCharacter", "af545b", "", "", "")
    call <SID>X("TSOperator", "b36d43", "", "", "")

    if has('nvim-0.8')
      highlight! link @annotation TSAnnotation
      highlight! link @attribute TSAttribute
      highlight! link @boolean TSBoolean
      highlight! link @character TSCharacter
      highlight! link @character.special TSCharacterSpecial
      highlight! link @comment TSComment
      highlight! link @comment.error TSDanger
      highlight! link @comment.note TSNote
      highlight! link @comment.todo TSTodo
      highlight! link @comment.warning TSWarning
      highlight! link @conceal Grey
      highlight! link @conditional TSConditional
      highlight! link @constant TSConstant
      highlight! link @constant.builtin TSConstBuiltin
      highlight! link @constant.macro TSConstMacro
      highlight! link @constructor TSConstructor
      highlight! link @debug TSDebug
      highlight! link @define TSDefine
      highlight! link @diff.delta diffChanged
      highlight! link @diff.minus diffRemoved
      highlight! link @diff.plus diffAdded
      highlight! link @error TSError " This has been removed from nvim-treesitter
      highlight! link @exception TSException
      highlight! link @field TSField
      highlight! link @float TSFloat
      highlight! link @function TSFunction
      highlight! link @function.builtin TSFuncBuiltin
      highlight! link @function.call TSFunctionCall
      highlight! link @function.macro TSFuncMacro
      highlight! link @function.method TSMethod
      highlight! link @function.method.call TSMethodCall
      highlight! link @include TSInclude
      highlight! link @keyword TSKeyword
      highlight! link @keyword.conditional TSConditional
      highlight! link @keyword.debug TSDebug
      highlight! link @keyword.directive TSPreProc
      highlight! link @keyword.directive.define TSDefine
      highlight! link @keyword.exception TSException
      highlight! link @keyword.function TSKeywordFunction
      highlight! link @keyword.import TSInclude
      highlight! link @keyword.operator TSKeywordOperator
      highlight! link @keyword.repeat TSRepeat
      highlight! link @keyword.return TSKeywordReturn
      highlight! link @keyword.storage TSStorageClass
      highlight! link @label TSLabel
      highlight! link @markup.emphasis TSEmphasis
      highlight! link @markup.environment TSEnvironment
      highlight! link @markup.environment.name TSEnvironmentName
      highlight! link @markup.heading TSTitle
      highlight! link @markup.link TSTextReference
      highlight! link @markup.link.label TSStringSpecial
      highlight! link @markup.link.url TSURI
      highlight! link @markup.list TSPunctSpecial
      highlight! link @markup.list.checked Green
      highlight! link @markup.list.unchecked Ignore
      highlight! link @markup.math TSMath
      highlight! link @markup.note TSNote
      highlight! link @markup.quote Grey
      highlight! link @markup.raw TSLiteral
      highlight! link @markup.strike TSStrike
      highlight! link @markup.strong TSStrong
      highlight! link @markup.underline TSUnderline
      highlight! link @math TSMath
      highlight! link @method TSMethod
      highlight! link @method.call TSMethodCall
      highlight! link @module TSNamespace
      highlight! link @namespace TSNamespace
      highlight! link @none TSNone
      highlight! link @number TSNumber
      highlight! link @number.float TSFloat
      highlight! link @operator TSOperator
      highlight! link @parameter TSParameter
      highlight! link @parameter.reference TSParameterReference
      highlight! link @preproc TSPreProc
      highlight! link @property TSProperty
      highlight! link @punctuation.bracket TSPunctBracket
      highlight! link @punctuation.delimiter TSPunctDelimiter
      highlight! link @punctuation.special TSPunctSpecial
      highlight! link @repeat TSRepeat
      highlight! link @storageclass TSStorageClass
      highlight! link @storageclass.lifetime TSStorageClassLifetime
      highlight! link @strike TSStrike
      highlight! link @string TSString
      highlight! link @string.escape TSStringEscape
      highlight! link @string.regex TSStringRegex
      highlight! link @string.regexp TSStringRegex
      highlight! link @string.special TSStringSpecial
      highlight! link @string.special.symbol TSSymbol
      highlight! link @string.special.uri TSURI
      highlight! link @symbol TSSymbol
      highlight! link @tag TSTag
      highlight! link @tag.attribute TSTagAttribute
      highlight! link @tag.delimiter TSTagDelimiter
      highlight! link @text TSText
      highlight! link @text.danger TSDanger
      highlight! link @text.diff.add diffAdded
      highlight! link @text.diff.delete diffRemoved
      highlight! link @text.emphasis TSEmphasis
      highlight! link @text.environment TSEnvironment
      highlight! link @text.environment.name TSEnvironmentName
      highlight! link @text.literal TSLiteral
      highlight! link @text.math TSMath
      highlight! link @text.note TSNote
      highlight! link @text.reference TSTextReference
      highlight! link @text.strike TSStrike
      highlight! link @text.strong TSStrong
      highlight! link @text.title TSTitle
      highlight! link @text.todo TSTodo
      highlight! link @text.todo.checked Green
      highlight! link @text.todo.unchecked Ignore
      highlight! link @text.underline TSUnderline
      highlight! link @text.uri TSURI
      highlight! link @text.warning TSWarning
      highlight! link @todo TSTodo
      highlight! link @type TSType
      highlight! link @type.builtin TSTypeBuiltin
      highlight! link @type.definition TSTypeDefinition
      highlight! link @type.qualifier TSTypeQualifier
      highlight! link @uri TSURI
      highlight! link @variable TSVariable
      highlight! link @variable.builtin TSVariableBuiltin
      highlight! link @variable.member TSField
      highlight! link @variable.parameter TSParameter
    endif
    if has('nvim-0.9')
      highlight! link @lsp.type.class TSType
      highlight! link @lsp.type.comment TSComment
      highlight! link @lsp.type.decorator TSFunction
      highlight! link @lsp.type.enum TSType
      highlight! link @lsp.type.enumMember TSProperty
      highlight! link @lsp.type.events TSLabel
      highlight! link @lsp.type.function TSFunction
      highlight! link @lsp.type.interface TSType
      highlight! link @lsp.type.keyword TSKeyword
      highlight! link @lsp.type.macro TSConstMacro
      highlight! link @lsp.type.method TSMethod
      highlight! link @lsp.type.modifier TSTypeQualifier
      highlight! link @lsp.type.namespace TSNamespace
      highlight! link @lsp.type.number TSNumber
      highlight! link @lsp.type.operator TSOperator
      highlight! link @lsp.type.parameter TSParameter
      highlight! link @lsp.type.property TSProperty
      highlight! link @lsp.type.regexp TSStringRegex
      highlight! link @lsp.type.string TSString
      highlight! link @lsp.type.struct TSType
      highlight! link @lsp.type.type TSType
      highlight! link @lsp.type.typeParameter TSTypeDefinition
      highlight! link @lsp.type.variable TSVariable
      highlight! link DiagnosticUnnecessary WarningText
    endif

    " delete functions
    delf <SID>X
    delf <SID>rgb
    delf <SID>color
    delf <SID>rgb_color
    delf <SID>rgb_level
    delf <SID>rgb_number
    delf <SID>grey_color
    delf <SID>grey_level
    delf <SID>grey_number
endif

" vim: set fdl=0 fdm=marker:
