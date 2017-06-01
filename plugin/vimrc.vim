call plug#begin('~/.vim/bundle')
Plug 'johnzeng/vim-erlang', {'for': 'erlang'}
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-grepper'

if has('nvim')
"    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'altercation/vim-colors-solarized'
else
"    Plug 'Shougo/neocomplete.vim'
endif

Plug 'Valloric/YouCompleteMe', {'frozen': 1, 'do': './install.py --all', 'for': ['erlang', 'java', 'go', 'c', 'cpp', 'objc', 'python', 'javascript']}

Plug 'scrooloose/nerdtree'
Plug 'derekwyatt/vim-scala' , { 'for' : 'scala' }
Plug 'plasticboy/vim-markdown' , { 'for' : 'markdown' }
Plug 'fatih/vim-go' , {'for' : 'go'}
Plug 'Yggdroot/indentLine'
"Plug 'justmao945/vim-clang', {'for': ['cpp', 'c', 'objc']}

" snipmate and its dependency
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
"Plug 'garbas/vim-snipmate'
"Plug 'MarcWeber/vim-addon-mw-utils'
"Plug 'tomtom/tlib_vim'
" snipmat plugin end, all aboves are needed for sinpmate

"Plug 'johnzeng/Scala-Completion-vim'
Plug 'johnzeng/vim-erlang-tags' , {'for': 'erlang'}
Plug 'vim-erlang/vim-erlang-omnicomplete' , {'for' : 'erlang'}
Plug 'johnzeng/leader-c'
Plug 'vim-airline/vim-airline'

"Plug 'davidhalter/jedi-vim' ,{'for' : 'python'}
Plug 'vim-airline/vim-airline-themes'
Plug 'gregsexton/MatchTag'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/matchit.zip'
Plug 'artur-shaik/vim-javacomplete2' , {'for' : 'java'}

call plug#end()

"colorscheme elflord
set background=dark

syntax on
"let $LANG = 'en'
let mapleader = " "
set incsearch
set so=5
set hlsearch
set number
set ruler
set hidden 
set mouse=a
set ts=4
set backspace=2
set shiftwidth=4
set expandtab
set smartindent
set pastetoggle=<F10>
set autoread
au BufEnter * set formatoptions-=c formatoptions-=r formatoptions-=o

if has('mac')
    let g:erlangWranglerPath='/Users/johnzeng/bin/wrangler'
elseif has('unix')
endif

nmap <C-b> :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.gcno','\.gcda', '\.o' ,'\~$']

vmap <C-d> "+y
imap <C-d> <F10><C-r>+<F10>
imap <C-f> <Right>
imap <C-b> <Left>
imap <C-a> <Esc>I
imap <C-e> <Esc>A
imap <M-b> <S-Left>
imap <M-f> <S-Right>
nmap <leader>s <Esc>:wa<CR>
nmap <leader>q <Esc>:qa<CR>
" we don't use it usually, so we just use a far funcion
nmap <F11> :%!xxd<CR>
nmap <F12> :%!xxd -r<CR>


set formatoptions=ql

nmap <leader>r :%s/<C-r>=expand("<cword>")<CR>/
vmap <leader>r :s/<C-r>=expand("<cword>")<CR>/
nmap <leader>j :bn<CR>
nmap <leader>k :bp<CR>
nmap <leader>i :tabp<CR>
nmap <leader>o :tabn<CR>
nmap <leader>l :cn<CR>
nmap <leader>h :ccl<CR>
nmap <leader>d "_d
vmap <leader>d "_d
nmap <C-n> :Grepper-cword<CR>
nmap <leader>n :Grepper-query<CR>

nmap <C-p> :History<CR>
nmap <leader>f :FZF<CR>
nmap <M-l> :BLines<CR>
nmap <leader>b :Buffers<CR>
nmap <M-t> :Tags<CR>
imap <M-w> <C-R>=SmartDelete()<CR>
"imap <M-w> <Esc>:set iskeyword-=_<CR>a<C-w><Esc>:set iskeyword+=_<CR>a
let $FZF_DEFAULT_COMMAND='ag --hidden --ignore .git --ignore deps --ignore '."'.swp'".' -g ""'
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)
inoremap <expr> <c-x><c-k> fzf#complete('cat /usr/share/dict/words')


nmap <C-d> :call ListRegAndPaste()<CR>

func! SmartDelete()
    set paste
    let delete_num = CallDeleteNumber()
    if delete_num != -100
        let ret_str = ""
        while delete_num > 0
            echom delete_num
            let ret_str = ret_str . "\<BS>"
            let delete_num = delete_num - 1
        endwhile
    else
        let ret_str = "\<C-w>"
    endif

    set nopaste
    echom ret_str
    return ret_str
endfunc

func! CallDeleteNumber()
    let cur_col = col('.')
    let curpos = getpos('.')
    normal b
    let word_head_col = col('.')
    call setpos('.', curpos)
    let cur_line = getline('.')

    "current col is still in input mode, so you should start search from cur_col - 1 col
    "col is not index of cur_line, col - 2 is the index of the cur_col - 1
    let first_upper_case_index = cur_col - 2
    let first_under_score_index = cur_col - 2

    "should not equal the word_head_col's index
    while first_under_score_index >= word_head_col - 1
        if cur_line[first_under_score_index] == '_'
            while first_under_score_index >= word_head_col - 1 && cur_line[first_under_score_index - 1] == '_'
                let first_under_score_index = first_under_score_index - 1
            endwhile
            break
        endif
        let first_under_score_index = first_under_score_index - 1
    endwhile

    "should not equal the word_head_col's index
    if first_under_score_index > word_head_col - 1
        echom first_under_score_index
        if first_under_score_index == cur_col - 2
            return cur_col - first_under_score_index - 1
        else
            return cur_col - first_under_score_index - 2
        endif
    endif
        
    "should not equal the word_head_col's index
    while first_upper_case_index >= word_head_col - 1
        if 'A' <= cur_line[first_upper_case_index] && cur_line[first_upper_case_index] <= 'Z'
            while first_upper_case_index >= word_head_col - 1 && 'A' <= cur_line[first_upper_case_index] && cur_line[first_upper_case_index] <= 'Z'
                let first_upper_case_index = first_upper_case_index - 1
            endwhile
            break
        endif
        let first_upper_case_index = first_upper_case_index - 1
    endwhile

    "should not equal the word_head_col's index
    if first_upper_case_index > word_head_col - 1
        echom first_upper_case_index
        return cur_col - first_upper_case_index - 1
    endif
    echom 'first_upper_case_index:'.first_upper_case_index.",first_under_score_index:".first_under_score_index.',wordhead:'.word_head_col.',cur_col'.cur_col
    return -100
endfunc

func! ListRegAndPaste()
  exec "reg 0123456789\""
  let a:regId = input("which reg do you want?[0-9,\"]:")
  if strlen(a:regId) != 0 && -1 == match(a:regId, "[0-9\"]")
    exec "redraw"
    echon 'illegal register id'
    return 
  endif
  exec "set paste"
  exec "normal \"".a:regId."p"
  exec "set nopaste"
endfunc

au BufEnter *.pig set filetype=pig

"config for indent
let g:indentLine_enabled = 0
nmap <F3> :IndentLinesToggle<CR>

"config for airline
let g:airline_left_sep='>'
let g:airline_theme='solarized'

"jedi , just a little better, it's still not working with other define
"let g:jedi#goto_command = "<leader>d"
"let g:jedi#goto_assignments_command = "<leader>g"
"let g:jedi#goto_definitions_command = ""
"let g:jedi#documentation_command = "K"
"let g:jedi#usages_command = "<leader>d"
"let g:jedi#completions_command = "<C-n>"
"let g:jedi#rename_command = "<leader>e"

nmap J :call ListMarksAndJump()<CR>

func! ListMarksAndJump()
  exec "marks"
  let a:markId = input("which mark do you want?[0-9,\"a-zA-Z]:")
  if strlen(a:markId) != 0 && -1 == match(a:markId, "[0-9\"a-zA-Z]")
    exec "redraw"
    echon 'illegal mark id'
    return 
  endif
  exec "normal `".a:markId
endfunc

"java complete 2
autocmd FileType java setlocal omnifunc=javacomplete#Complete

"file type setting
autocmd FileType scala nmap <leader>t :SortScalaImports<CR>
autocmd FileType erlang,go,java,python,c,cpp,objc,csharp,scala imap <C-l> <ESC>:pclose<CR>a
autocmd FileType erlang,go,java,python,c,cpp,objc,csharp,scala map <C-l> :pclose<CR>

"auto source
nmap <F4> :TagbarToggle<CR>

let g:html_indent_script1 = "inc" 
let g:html_indent_style1 = "inc" 
let g:html_indent_inctags = "html,body,head"
function! FormatHtml()
  execute "normal ggVGgJ"
  execute "%s/>\s*</>\r</g"
  execute "normal ggVG="
endfunction

au BufEnter *.erl,*.hrl imap <buffer> << <<>><Esc>hi
let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', '`':'`'}
let g:AutoPairsShortcutBackInsert="<M-d>"

" seting about markdown
let g:vim_markdown_folding_disabled = 1
set nofoldenable

au BufNewFile,BufRead SConstruct set filetype=python
au BufNewFile,BufRead SConscript set filetype=python

" I believe I should split them into different files, but, since they are just begined, let's just do it here
let g:completor_erlang_omni_trigger = '([^. *\t]:\w*)$'
if(has('nvim'))
    colorscheme solarized
    let g:python_host_prog= '/usr/local/bin/python'
    let g:ycm_server_python_interpreter  = '/usr/local/bin/python'
    let g:ycm_semantic_triggers =  {
  \   'c' : ['->', '.'],
  \   'objc' : ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s',
  \             're!\[.*\]\s'],
  \   'ocaml' : ['.', '#'],
  \   'cpp,objcpp' : ['->', '.', '::'],
  \   'perl' : ['->'],
  \   'php' : ['->', '::'],
  \   'cs,java,javascript,typescript,d,python,perl6,scala,vb,elixir,go' : ['.'],
  \   'ruby' : ['.', '::'],
  \   'lua' : ['.', ':'],
  \   'erlang' : [':\w*'],
  \ }
    let g:ycm_cache_omnifunc = 1
    let g:ycm_collect_identifiers_from_comments_and_strings = 1

"    let g:ycm_key_list_select_completion = []
"    let g:ycm_key_list_previous_completion = []
    let g:ycm_collect_identifiers_from_tags_files = 1


"    let g:deoplete#enable_at_startup = 1
"    if !exists('g:deoplete#omni#input_patterns')
"        let g:deoplete#omni#input_patterns = {}
"        let g:deoplete#omni#input_patterns.erlang = '[^. *\t]:\w*'
"    endif
"
"    if !exists('g:deoplete#sources')
"        let g:deoplete#sources = {}
"        let g:deoplete#sources._ = ['buffer']
"        let g:deoplete#sources.cpp = ['buffer', 'tag']
"    endif

else
"    if !exists('g:neocomplete#keyword_patterns')
"        let g:neocomplete#keyword_patterns = {}
"    endif
"    let g:neocomplete#keyword_patterns['default'] = '\h\w*'
"
"    if !exists('g:neocomplete#sources#omni#input_patterns')
"      let g:neocomplete#sources#omni#input_patterns = {}
"    endif
"    let g:neocomplete#sources#omni#input_patterns.erlang = '[^. *\t]:\w*'
endif

"au BufEnter *.erl call CreateAleOpts()

function! CreateAleOpts()
    if exists('g:ale_erlang_erlc_options') && g:ale_erlang_erlc_options != ''
        return 0
    endif
    let $ERL_LIBS='deps:.'
    let alllibs = finddir('lib', '**/', -1)
    for one_lib in alllibs
        let $ERL_LIBS.=':' . one_lib
    endfor 
    let g:ale_erlang_erlc_options = ''
    let allinclude = finddir('include', '**/', -1)
    for path in allinclude
        let g:ale_erlang_erlc_options .= '-I ' . path . ' '
    endfor
endfunction

let g:unstack_mapkey="<leader>u"
command! JsonFormat execute('%!python -m json.tool')
let g:yankstack_map_keys = 0
nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>P <Plug>yankstack_substitute_newer_paste
