if exists("b:current_syntax")
  finish
endif

syntax case match

" Comments
syntax match veldComment "//.*$" contains=veldAnnotation
syntax region veldComment start="/\*" end="\*/" contains=veldAnnotation
syntax match veldAnnotation "@canvas-pos\|@veld-ignore" contained

" Block type keywords
syntax keyword veldBlockKeyword component page layout theme form service model
syntax keyword veldBlockKeyword migration api job queue workflow pipeline cron
syntax keyword veldBlockKeyword hook agent prompt tool config secret middleware test
syntax keyword veldBlockKeyword import from extend

" Strings
syntax region veldString start=+"+ end=+"+ contains=veldInterpolation
syntax match veldInterpolation "{[^}]*}" contained

" Numbers
syntax match veldNumber "\v\d+(\.\d+)?([eE][+-]?\d+)?"

" Prop keys (identifier before colon)
syntax match veldPropKey "\v[a-zA-Z_][a-zA-Z0-9_]*\s*:"he=e-1

" Booleans
syntax keyword veldBool true false

" Null
syntax keyword veldNull null

" Arrow
syntax match veldArrow "=>"

" Delimiters
syntax match veldBraces "[{}]"
syntax match veldBrackets "[\[\]]"
syntax match veldParens "[()]"

" Import names between braces
syntax match veldImportName "\v\{[a-zA-Z_][a-zA-Z0-9_, ]*\}" contains=veldString

highlight default link veldComment Comment
highlight default link veldAnnotation SpecialComment
highlight default link veldBlockKeyword Keyword
highlight default link veldString String
highlight default link veldInterpolation Special
highlight default link veldNumber Number
highlight default link veldPropKey Identifier
highlight default link veldBool Boolean
highlight default link veldNull Constant
highlight default link veldArrow Operator
highlight default link veldBraces Delimiter
highlight default link veldBrackets Delimiter
highlight default link veldParens Delimiter
highlight default link veldImportName Include

let b:current_syntax = "veld"
