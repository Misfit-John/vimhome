set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle
call vundle#begin()
Bundle 'gmarik/vundle'
Plugin 'Yggdroot/LeaderF'
Plugin 'scrooloose/nerdtree'
Plugin 'derekwyatt/vim-scala'
Plugin 'fatih/vim-go'
Plugin 'Yggdroot/indentLine'
Plugin 'justmao945/vim-clang'
"Plugin 'rizzatti/dash.vim'
Plugin 'johnzeng/grep'
Plugin 'johnzeng/VimSessionManager'
Plugin 'johnzeng/snipmate.vim'
Plugin 'johnzeng/leader-c'
"Plugin 'Shougo/neocomplete.vim'
Plugin 'vim-airline/vim-airline'

"don't forget to run 'pip install jedi' before you use it.
Plugin 'davidhalter/jedi-vim'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'easymotion/vim-easymotion'
Plugin 'haya14busa/incsearch.vim'
Plugin 'haya14busa/incsearch-fuzzy.vim'
Plugin 'haya14busa/incsearch-easymotion.vim'
Plugin 'gregsexton/MatchTag'
Plugin 'jiangmiao/auto-pairs'
Plugin 'tpope/vim-surround'
Plugin 'vim-scripts/matchit.zip'
Plugin 'artur-shaik/vim-javacomplete2'

call vundle#end()
filetype plugin indent on

colorscheme elflord
syntax on
set incsearch
set hlsearch
set number
set ruler
set hidden 
set backspace=2
set mouse=a
set ts=2
set expandtab
set shiftwidth=2
set smartindent
set pastetoggle=<F10>
set autoread

nmap <C-p> :LeaderfMru<CR>

nmap <C-b> :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.gcno','\.gcda', '\.o' ,'\~$']

vmap <C-e> "+y
imap <C-e> <F10><C-r>+<F10>
nmap <leader>s <Esc>:wa<CR>
nmap <leader>q <Esc>:qa<CR>
" we don't use it usually, so we just use a far funcion
nmap <F11> :%!xxd<CR>
nmap <F12> :%!xxd -r<CR>


set formatoptions=ql

nmap <silent><C-n> :Regrep '<C-r>=expand("<cword>")<CR>' *<CR>
nmap <silent><leader>n mA:call GrepFromInput()<CR>
nmap <leader>r :%s/<C-r>=expand("<cword>")<CR>/
vmap <leader>r :s/<C-r>=expand("<cword>")<CR>/
nmap <leader>j :bn<CR>
nmap <leader>k :bp<CR>
nmap <leader>l :cn<CR>
nmap <leader>h :ccl<CR>
nmap <leader>d "_d
vmap <leader>d "_d

function! GrepFromInput(...)
    let a:inputword = input("Grep:")
    if strlen(a:inputword) == 0
        return
    endif
    let a:exec_command = "Regrep ".a:inputword." *"
    exec a:exec_command
endfunction

let g:Lf_WildIgnore = {
        \ 'dir': ['.svn','.git','target','node_modules','metastore_db', 'vendor'],
        \ 'file': ['*.DS_Store','*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]','*.log','*.class','*.cache','*.jar', '*.gcno','*.gcda']
        \}
let g:Lf_MruFileExclude = ['*.so','*.log',]
"I think I can do something on this so I can set cache for every project
"let g:Lf_CacheDiretory = '~/cloud_lucifer/'

"config about grep
let g:Grep_Skip_Files = '*.bak *~ *.o *.jar *.class, *.log *.gcda *.gcno *.pyc *.pyo' 
"let Grep_Default_Options = '--exclude-dir=node_modules --exclude-dir=target -IR'
let g:Grep_Default_Options = '-I'
let g:Grep_Skip_Dirs = 'project target .git node_modules'

nmap <C-e> :call ListRegAndPaste()<CR>

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
"let g:airline#extensions#tabline#enabled = 1
au VimEnter * :AirlineTheme base16_codeschool

" You can use other keymappings like <C-l> instead of <CR> if you want to
" use these mappings as default search and somtimes want to move cursor with
" EasyMotion.
function! s:incsearch_config(...) abort
  return incsearch#util#deepextend(deepcopy({
  \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
  \   'keymap': {
  \     "\<CR>": '<Over>(easymotion)'
  \   },
  \   'is_expr': 0
  \ }), get(a:, 1, {}))
endfunction

noremap <silent><expr> <leader>/  incsearch#go(<SID>incsearch_config())
noremap <silent><expr> <leader>?  incsearch#go(<SID>incsearch_config({'command': '?'}))

function! s:config_easyfuzzymotion(...) abort
  return extend(copy({
  \   'converters': [incsearch#config#fuzzyword#converter()],
  \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
  \   'keymap': {"\<CR>": '<Over>(easymotion)'},
  \   'is_expr': 0,
  \   'is_stay': 1
  \ }), get(a:, 1, {}))
endfunction

noremap <silent><expr> <Space>/ incsearch#go(<SID>config_easyfuzzymotion())

"jedi , just a little better, it's still not working with other define
let g:jedi#goto_command = "<leader>d"
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = "K"
"let g:jedi#usages_command = "<leader>n"
let g:jedi#completions_command = "<C-n>"
let g:jedi#rename_command = "<leader>r"

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
autocmd FileType go,java,python,c,cpp,objc,csharp imap <C-n> <C-R>=pumvisible() ? "\<lt>C-n>" : "\<lt>C-x>\<lt>C-o>"<CR>
autocmd FileType go,java,python,c,cpp,objc,csharp imap <C-l> <ESC>:pclose<CR>a

