" Move line up
function! MoveLineUp()
  if line('.') != 1
    exec "move -2"
  endif
endfunction
nnoremap <silent> <leader>w :call MoveLineUp()<cr>

" Move line down
function! MoveLineDown()
  if line('.') != line('$')
    exec "move +1"
  endif
endfunction
nnoremap <silent> <leader>s :call MoveLineDown()<cr>

" Delete Inactive Buffers
function! CloseInactiveBuffers()
  let tablist = []
  for i in range(tabpagenr('$'))
    call extend(tablist, tabpagebuflist(i + 1))
  endfor
  for i in range(1, bufnr('$'))
    if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1
      silent exec 'bwipeout' i
    endif
  endfor
  echomsg 'Closed inactive buffers.'
endfunction
nnoremap <leader>q :call CloseInactiveBuffers()<cr>

" Reindent File
function Reindent()
  let line = line('.')
  let col = col('.')
  execute "normal! ggVG="
  call cursor(line, col)
endfunction
nnoremap <silent> <leader>= :call Reindent()<CR>

function ProfileStart()
  profile start profile.log
  profile func *
  profile file *
  echomsg "Starting Profiling..."
endfunction
noremap <silent> <leader>d> :call ProfileStart()<CR>

function ProfileEnd()
  echomsg "Ending Profiling... Open profile.log for details."
  sleep 2
  profile pause
  noautocmd qall!
endfunction
noremap <silent> <leader>d< :call ProfileEnd()<CR>

function Enter()
  cd %:h
  echomsg "Set working directory to " . getcwd()
endfunction
noremap <silent> <leader>e :call Enter()<CR>

function JsonFormat()
  exec "'<,'>!python -m json.tool"
  call Reindent()
endfunction
vmap <silent> F :call JsonFormat()<CR>

function ToggleZoomPane()
  let wincount = winnr('$')
  if wincount > 1
    tab split
  else
    let tabcount = tabpagenr('$')
    let currenttab = tabpagenr()
    if tabcount > 1 && currenttab == tabcount
      quit
    end
  end
endfunction
nmap <silent> ;z :call ToggleZoomPane()<CR>

function! GlobalReplace()
  let find = input('Find: ')
  if len(find) == 0
    return
  endif
  let replace = input('Replace: ')
  if len(replace) == 0
    return
  endif
  let filematcher = input('File Matcher (**/*.rb): ')
  if len(filematcher) == 0
    return
  endif
  execute 'args `grep -nl ' . find . ' ' . filematcher . '`'
  execute 'argdo %s/' . find . '/' . replace . '/ge | w'
endfunction
command! GlobalReplace call GlobalReplace()

function! PluginExists(plugin)
  return isdirectory(g:plugs[a:plugin].dir)
endfunction
