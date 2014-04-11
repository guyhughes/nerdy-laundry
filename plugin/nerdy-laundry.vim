
" Script Init.   {{{
" ==================================================

if exists('g:loaded_nerdy_laundry')
  finish  " goto fail 
elseif v:version < 700
  echoerr "LAUNDRY: plugin requires vim >= 7."
  finish  " goto fail 
elseif !exists("loaded_nerd_comments")
  echoerr "LAUNDRY: plugin requires NERDCommenter [https://github.com/scrooloose/NERDCommenter]."
  finish  " goto fail 
else  " proper else statements saves the world from #gotofail
  let g:loaded_nerdy_laundry = 1
endif
"}}}

" Laundry's Unexposed Library {{{
"
" It's like, let's grab a book at the library and read...
" instead of doing laundry.
"
" SubLibrary::extends NERD Commenter plugin""{{{
"
" This is what we replace if we want to use another commenting function.

function! s:CommentThisLine() "{{{
  execute ':call NERDComment("n","Comment")'
endfunction
" }}}

"}}}

function! s:DrawString(src,length) "{{{
  put =strpart(a:src, 0, a:length)
endfunction
" }}}

function! s:GetMaxLineLength(override) " {{{
  let l:columns_default = 79
  if ( !empty(a:override) && &textwidth > a:override )
    return a:override
  elseif ( &textwidth > l:columns)
    return &textwidth
  else
    reutrn l:columns_default
  endif

endfunction
"}}}
" }}}

" Laundry's Psuedo-Exposed Library for End-Users  {{{

function! s:NewLine(chars) "{{{

  let l:chars = empty(a:chars) ? '=' : a:chars
 
  " length of the line -- should be ie 80 for Basket, and 50 for Fold
  " (using golden ratio of two thirds)
  let l:columns = s:GetMaxLineLength()  * 0.667

  let l:uline = repeat(l:chars, (l:columns / len(l:chars)) + 1)
 
  call s:DrawString(l:uline, l:columns)
 

  call s:CommentThisLine()
endfunction
"}}}

function! s:NewFold(maxcolumns,chars) " {{{
 
  " chars: the character(s) to draw the bar with
  let chars = empty(a:chars) ? '=' : a:chars
  let chars_len = len(chars)
 
  " &commentstring:     managed by commentary plugin
  " commentstring_len:  length of the comment rtring in this context
  let commentstring_len = exists(&commentstring)? 2 : len(&commentstring)

  " maxcolumns:  the maxium width of a line (i.e. &textwidth)
  " columns:       the number of chars to print in an underline
  let columns  = (empty(a:maxcolumns) ? ( &textwidth ? 80 : &textwidth ) : a:maxcolumns )
  let g:columns = columns - commentstring_len


  " blockline: the line of chars to form the block
  let blockline = repeat(chars, (columns / chars_len) + 2)


  put =strpart(blockline, 0, columns)
  call s:CommentThisLine()
  normal k
  put =strpart(blockline, 0, columns)
  call s:CommentThisLine()
  normal 3j

endfunction
" }}}

function! s:NewBasket(maxcolumns,chars) " {{{
 
  " chars: the character(s) to draw the bar with
  let chars = empty(a:chars) ? '=' : a:chars
  let chars_len = len(chars)
 
  " &commentstring:     managed by commentary plugin
  " commentstring_len:  length of the comment rtring in this context
  let commentstring_len = exists(&commentstring)? 2 : len(&commentstring)

  " maxcolumns:  the maxium width of a line (i.e. &textwidth)
  " columns:       the number of chars to print in an underline
  let columns  = (empty(a:maxcolumns) ? ( &textwidth ? 80 : &textwidth ) : a:maxcolumns )
  let g:columns = columns - commentstring_len


  " blockline: the line of chars to form the block
  let blockline = repeat(chars, (columns / chars_len) + 2)
  put =strpart(blockline, 0, columns)
  call s:CommentThisLine()
  normal k
  put =strpart(blockline, 0, columns)
  call s:CommentThisLine()
  normal 3j
endfunction
" }}}

"  Expose the Library to End-Users with Exec Commands. {{{
command! -nargs=? LaundryLine call s:NewLine(<q-args>)
command! -nargs=? LaundryFold call s:NewFold(<q-args>,<q-args>)
command! -nargs=? LaundryBasket call s:NewBasket(<q-args>,<q-args>)
" }}}

"" }}}

" Laundry's Default Key Map {{{
" If you don't want to use the defaults, just put this:
"         let g:laundry_defaultkeys=0
" before this plugin is added to &runtimepath.

" If g:laundry_defaultkeys is not zero...
if ( exists('g:laundry_defaultkeys') && g:laundry_defaultkeys !=? 0 )
  " ... then setup the key maps
  nnoremap <Leader>ll :call s:NewLine()
  vnoremap <Leader>ll :call s:NewLine()

  nnoremap <Leader>lf :call s:NewFold()
  vnoremap <Leader>lf :call s:NewFold()

  nnoremap <Leader>lb :call s:NewBasket()
  vnoremap <Leader>lb :call s:NewBasket()

endif

" }}}

