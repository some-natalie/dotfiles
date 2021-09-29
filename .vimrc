set runtimepath+=~/.vim_runtime

source ~/.vim_runtime/vimrcs/basic.vim
source ~/.vim_runtime/vimrcs/filetypes.vim
source ~/.vim_runtime/vimrcs/plugins_config.vim
source ~/.vim_runtime/vimrcs/extended.vim

try
source ~/.vim_runtime/my_configs.vim
source ~/.vim_runtime/syntax/maillog.vim
catch
endtry

let g:go_version_warning = 0

autocmd BufRead,BufNewFile mail.log set syntax=maillog
