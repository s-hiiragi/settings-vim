" .vimrc
" coding: utf-8


" ------------------------------------------------------------------------------
" 基本的な設定

set helplang=ja
set tabstop=2 shiftwidth=2 softtabstop=0

" エンコーディング, 改行の設定
" set encoding=
set fileformats=dos,unix,mac

" 行番号を表示
set number

" <Tab>を挿入する時スペースに変換
"set expandtab

" 不可視文字(<Tab>, 行末など)の表示設定
set list
set listchars=tab:^\ 

" オートインデントを有効にする
set autoindent

" 行末と次の行頭をh,l等で行き来できるようにする
set whichwrap=b,s,h,l,<,>,[,]

" 文字コードと改行コードをステータスラインに表示
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P

" ヤンクにクリップボードを使用
set clipboard=unnamed

" セッション
" 起動時にメッセージダイアログが表示されて邪魔なため無効化している
" 
" 終了時にセッションを保存
autocmd VimLeave * mks! ~/.vim/last-session
" 
" 起動時に前回のセッションを復元
"if filereadable(expand('~/.vim/last-session'))
"  source ~/.vim/last-session
"endif


" ------------------------------------------------------------------------------
" キーマップの設定


" カーソルを表示行で移動する。物理行移動は<C-n>, <C-p>
nnoremap j      gj
nnoremap k      gk
nnoremap <Down> gj
nnoremap <Up>   gk


" 左手でカーソル移動したい人生だった
" nnoremap e k
" nnoremap d j
" nnoremap s h
" nnoremap f l


" タブ操作を快適にする
nnoremap <Tab>   gt
nnoremap <S-Tab> gT
"nnoremap <C-Tab> :tabe<CR>i


" C-sで上書き保存
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>i


" vimrc編集を快適にする
"nnoremap <S-s> :tabe ~/.vimrc<CR>
"nnoremap <C-s> :source ~/.vimrc<CR>:source ~/.gvimrc<CR>
nnoremap ev :tabe ~/.vimrc<CR>
nnoremap eg :tabe ~/.gvimrc<CR>
"command! EditVimrc
"command! EditGVimrc
command! LoadSettings source ~/.vimrc|source ~/.gvimrc


" -- コマンドモードを快適にする

cnoremap <C-k> <Up>
cnoremap <C-j> <Down>
cnoremap <C-Space> <Enter>
cnoremap <S-Space> <BS>


" -- 挿入モードを快適にする (なんかEmacs的使い方…)

" 移動
"inoremap <Leader>a <Home>
inoremap <C-a> <Home>
inoremap <C-^> <Home>
"inoremap <Leader>e <End>
inoremap <C-e> <End>
"inoremap <C-$> <End>

inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

" アンドゥ/リドゥ
inoremap <C-u> <Esc>ui
inoremap <C-r> <Esc><C-r>A

" Enter/BkSp
inoremap <C-Space> <Enter>
inoremap <S-Space> <BS>


" ------------------------------------------------------------------------------
" プラグインの設定

" NeoBundle
" 
set nocompatible
filetype off

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))

filetype plugin indent on

" Installation check.
if neobundle#exists_not_installed_bundles()
  echomsg 'Not installed bundles : ' .
        \ string(neobundle#get_not_installed_bundle_names())
  echomsg 'Please execute ":NeoBundleInstall" command.'
  "finish
endif

NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neocomplcache.vim'
NeoBundle 'rhysd/clever-f.vim'
NeoBundle 'bling/vim-airline'
NeoBundle 'thinca/vim-quickrun'


" vim-airline
let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#left_sep = ' '
"let g:airline#extensions#tabline#left_alt_sep = '|'


" ref.vim
"
"nmap ,ra :<C-u>Ref alc<Space>
"
"let g:ref_alc_start_linenumber = 39 " 表示する行数


"-------------------------------------------------------------------------------
" コマンドの定義


" 常に画面中央にカーソルを移動
" 
"function! s:scroll_cursor_to_center()
"  if line("$") > winheight(0)
"    テキストが38行以上のとき、カーソルを末尾に移動できないバグが発生した。
"    下の行が原因だったっぽい。挿入モードでnormalコマンドを使うとカーソルがずれる？
"    normal! zz
"  endif
"endfunction
"
"augroup CursorScroll
"  autocmd!
"  autocmd CursorMoved,CursorMovedI * call s:scroll_cursor_to_center()
"augroup END
" 
" 以下覚書
" function     => 41.7  関数定義
" function!    => 41.7  上書き定義
" s:           => スクリプトスコープ
" 
" line("$")    => :h line       最後の行の行番号(=行数)を取得
" winheight(0) => :h winheight  行数を表示
" normal! zz   => :h normal     ノーマルコマンドを実行(!: キーマップは適用しない)
" 
" augroup      => autocmd.txt 8  以降のautocmdをこのグループに加える
" augroup END  => autocmd.txt 8  以降のautocmdをデフォルトのグループに加える
" autocmd!     => autocmd.txt 2  現在のグループ内のautocmdを全て削除
" autocmd      => autocmd.txt 2  イベント処理を定義


" カレントディレクトリ移動コマンド
" 
" <Space>cd  
" :CD[!]        現在開いているドキュメントのディレクトリに移動
"               !を付けなかった場合、移動先ディレクトリパスをechoする
" :CD[!] {dir}  指定されたディレクトリに移動
" 
command! -nargs=? -complete=dir -bang CD  call s:ChangeCurrentDir('<args>', '<bang>')
function! s:ChangeCurrentDir(directory, bang)
  if a:directory == ''
    lcd %:p:h
  else
    execute 'lcd ' . a:directory
  endif
  
  if a:bang == ''
    pwd
  endif
endfunction

" Change current directory.
nnoremap <silent> <Space>cd :<C-u>CD<CR>


" ファイル名を変更
" http://vim-users.jp/2009/05/hack17/
" 
command! -nargs=1 -complete=file  Rename file <args>|call delete(expand('$'))
" 
" command! => :h command  コマンドを上書き定義する
" |        => :h :bar     続けてコマンドを実行 


" メニューバー・ツールバーの表示を切り替える
" http://sourceforge.jp/magazine/07/11/06/0151231/2
" 
" C-F2  切り替え
" 
map <silent> <C-F2> :if &guioptions =~# 'T' <Bar>
    \set guioptions-=T <Bar>
    \set guioptions-=m <Bar>
  \else <Bar>
    \set guioptions+=T <Bar>
    \set guioptions+=m <Bar>
  \endif<CR>
" 
" 以下覚書
" =~# => :h =~#  正規表現による比較演算子 (#: 大文字/小文字を区別)


" smartchr.vim
" 
" for JavaScript
augroup Ujihisa " {{{
  autocmd!
"  autocmd FileType javascript inoremap <buffer> <expr> \ smartchr#one_of('function', '\')
  
  " -- for JavaScript
  
  autocmd FileType javascript inoremap <buffer> <expr> <S-Space>f smartchr#one_of("function () {}<Left><Left><Left><Left><Left>", "f")
  " af: anonymous function
  autocmd FileType javascript inoremap <buffer> <expr> <S-Space>af smartchr#one_of("function () {}<Left>", "af")
  " ns: namespace
  autocmd FileType javascript inoremap <buffer> <expr> <S-Space>ns smartchr#one_of("(function() {})();<Left><Left><Left><Left><Left>", "ns")
  
  " -- for WSH/JScript
  
  " ax: activex
  autocmd FileType javascript inoremap <buffer> <expr> <S-Space>ax smartchr#one_of("new ActiveXObject('')<Left><Left>", "ax")
  " fso: file system object
  autocmd FileType javascript inoremap <buffer> <expr> <S-Space>fso smartchr#one_of("var fso = new ActiveXObject('Scripting.FileSystemObject');<CR>", "fso")
  " req: require
"  autocmd FileType javascript inoremap <buffer> <expr> <S-Space>req smartchr#one_of("", "req")
augroup END


" ヘルプをqで閉じれるようにする
" 
if !exists("autocommands_help_loaded")
  let autocommands_help_loaded = 1
  autocmd FileType help nnoremap <buffer> q <C-w>c
  autocmd FileType help nnoremap <buffer> <Space> <C-]>
  autocmd FileType help nnoremap <buffer> <S-Space> <C-t>
endif
