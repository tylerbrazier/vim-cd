if exists("g:loaded_cd") || &cp
	finish
endif
let g:loaded_cd = 1

" dictionary of dirname->timestamp
let s:dirs = {}

silent! nnoremap <unique> c<Tab> :Cd<Space>

command -nargs=1 -complete=customlist,s:complete Cd cd <args>

augroup vimcd
	autocmd!
	autocmd VimEnter * call s:load()
	autocmd VimLeave * call s:persist()
	autocmd DirChanged,VimEnter * call s:update()
augroup END

function s:update()
	let s:dirs[s:cwd()] = strftime('%s')
endfunction

function s:load()
	silent! call readfile(s:file())
		\->map('split(v:val, ":")')
		\->foreach('let s:dirs[v:val[0]] = v:val[1]')
endfunction

function s:persist()
	call writefile(items(s:dirs)->map('v:val[0]..":"..v:val[1]'), s:file())
endfunction

function s:file()
	let d = has('nvim') ? stdpath('data') : $MYVIMDIR
	return d..'/vimcd'
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
		return get(s:dirs, a:a) < get(s:dirs, a:b) ? 1 : -1
endfunction

" :help :command-completion-customlist
function s:complete(a,l,p)
	return keys(s:dirs)
		\->filter({i,v -> stridx(v, a:a) >= 0})
		\->sort(function('s:sort'))
endfunction
