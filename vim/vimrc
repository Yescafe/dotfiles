" 配置参考 https://zhuanlan.zhihu.com/p/69725463

set nu
set relativenumber
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

" 基本配置
" 禁用 swap 恢复文件
set noswapfile
" 编码
set encoding=utf-8
" 文件检测编码
" 防止 Windows 下保存的中文文本文件乱码
set fileencodings=utf-8,gb18030
" 插入模式自动锁进
set autoindent
" 修正 vim 退格键行为
set backspace=eol,start,indent
" 双行显示状态
set laststatus=2
" 80 列高亮
set colorcolumn=80
" 高亮所在行
set cursorline
" 自动折行
set linebreak
" 语法高亮
syntax on
" 自动识别文件类型
filetype plugin indent on

" keymaps
" ESC
imap jj <Esc>
imap kk <Esc>
imap kj <Esc>
" leader
let mapleader=","

" 主题 tender
" git clone https://github.com/jacoborus/tender.vim ~/.vim/pack/vendor/start/tendor
" 开启 24 位真彩色支持
" 24位真彩色信息请参考 https://gist.github.com/XVilka/8346728
set termguicolors
" 设置主题
color tender
" tender 默认背景色是一种亮灰色，晚上特别不舒服，改成纯黑
highlight Normal guibg=#000001
" 改背景后选中区域无法高亮，也得调一下
highlight Visual guibg=#323232
" 灰色的状态栏很扎眼，调一下
highlight StatusLine guibg=#444444 guifg=#b3deef
" vim 的 terminal 状态栏需要单独配置
highlight StatusLineTerm guibg=#444444 guifg=#b3deef
highlight StatusLineTermNC guibg=#444444 guifg=#999999

" nerdtree
" git clone https://github.com/scrooloose/nerdtree ~/.vim/pack/vendor/start/nerdtree
nnoremap <silent> <leader>e :NERDTreeToggle<cr>
nnoremap <silent> <leader>f :NERDTreeFind<cr>

" fzf
" brew install fzf
" git clone https://github.com/lvht/fzf ~/.vim/pack/vendor/start/fzf
" 模糊路径搜索
nnoremap <silent> <c-p> :call fzf#Open()<cr>

" Mru
" git clone https://github.com/lvht/mru ~/.vim/pack/vendor/start/mru
" 最近打开文件列表
nnoremap <silent> <c-u> :Mru<cr>

" ack
" 文件搜索
" git clone https://github.com/mileszs/ack.vim ~/.vim/pack/vendor/start/ack
