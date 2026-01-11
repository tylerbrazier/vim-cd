if exists("g:loaded_cd") || &cp
	finish
endif
let g:loaded_cd = 1

" dictionary of dirname->timestamp
let s:map = {}
let s:file = (has('nvim') ? stdpath('data') : $MYVIMDIR)..'/cd_history'

silent! nnoremap <unique> cd :ChDir <C-D>*

command -nargs=1 -complete=custom,s:complete ChDir silent lcd <args>
command ChHist exec 'new' s:file

augroup vimcd
	autocmd!
	autocmd VimEnter * call s:load()
	autocmd VimLeave * call s:persist()
	autocmd DirChanged,VimEnter * call s:update()
	exec 'autocmd BufWritePost' s:file 'call s:reload()'
augroup END

function s:update()
	let s:map[s:cwd()] = strftime('%s')
endfunction

function s:load() abort
	if !filereadable(s:file)
		call writefile([], s:file)
	endif
	call readfile(s:file)
		\->map('split(v:val, ":")')
		\->foreach('let s:map[v:val[0]] = v:val[1]')
endfunction

function s:reload() abort
	let s:map = {}
	call s:load()
	echo 'Reloaded cd history'
endfunction

function s:persist()
	call writefile(
		\items(s:map)->map('v:val[0]..":"..v:val[1]')->sort(),
		\s:file)
endfunction

function s:cwd()
	return fnamemodify(getcwd(), ':~')
endfunction

" a == b: 0
" a after b: 1
" b after a: -1
function s:sort(a, b)
	" likely you won't cd to the cwd so sort that last
	if a:a == s:cwd()
		return 1
	elseif a:b == s:cwd()
		return -1
	else
		return get(s:map, a:a) < get(s:map, a:b) ? 1 : -1
endfunction

" :help :command-completion-custom
function s:complete(a,l,p)
	return (keys(s:map)->sort(function('s:sort')) +
		\getcompletion(a:a, 'dir')
		\)->join("\n")
endfunction
