" .gvimrc
" coding: utf-8


" フォントの設定
" 
if has('win32')
  " Windows用
  
  set guifont=MS_Gothic:h10:cSHIFTJIS
  set guifontwide=MS_Gothic:h10:cSHIFTJIS
  
  " 行間隔の設定
  set linespace=1
  
  " 一部のUCS文字の幅を自動計測して決める
  if has('kaoriya')
    set ambiwidth=auto
  endif
  
elseif has('mac')
  " Mac用
  
  set guifont=Osaka-等幅:h14
  
elseif has('xfontset')
  " UNIX用 (xfontsetを使用)
  
  set guifontset=a14,r14,k14
endif


" ウィンドウサイズの設定
" 
set lines=40
set columns=85


" メニューバー、ツールバーを削除
" 以下は1行にまとめられないので注意。('add-option-flags'を参照。)
" 
set guioptions-=m
set guioptions-=T
