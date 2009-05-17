"=============================================================================
" Author:  Takeshi NISHIDA <ns9tks@DELETE-ME.gmail.com>
" Licence: MIT Licence
" Version: 0.1.0, for Vim 7.2
"=============================================================================
" LOAD GUARD: {{{1

if exists('g:loaded_minscm') || v:version < 702
  finish
endif
let g:loaded_minscm = 000100 " Version xx.xx.xx


" }}}1
"=============================================================================
" GLOBAL FUNCTION: {{{1

let s:statusReports = {}
"
function! g:minscm_getStatus()
  return minscm#getStatusReport(minscm#getTargetDir())
endfunction

" }}}1
"=============================================================================
" LOCAL FUNCTION: {{{1

"
function! s:initialize()
  " --------------------------------------------------------------------------
  if !exists('g:minscm_availableScms')
    let g:minscm_availableScms = filter(['git', 'mercurial', 'bazaar'], 'minscm#{v:val}#isExecutable()')
  endif
  if !exists('g:minscm_mapLeader')
    let g:minscm_mapLeader = '\s'
  endif
  if !exists('g:minscm_mapLeaderAlternate')
    let g:minscm_mapLeaderAlternate = '\S'
  endif
  " --------------------------------------------------------------------------
  command! -bang MinSCMCommand          call minscm#executeCommand         (len(<q-bang>), minscm#getTargetDir())
  command! -bang MinSCMCommitFile       call minscm#executeCommitFile      (len(<q-bang>), minscm#getTargetDir())
  command! -bang MinSCMCommitTracked    call minscm#executeCommitTracked   (len(<q-bang>), minscm#getTargetDir())
  command! -bang MinSCMCommitAll        call minscm#executeCommitAll       (len(<q-bang>), minscm#getTargetDir())
  command! -bang MinSCMCheckout         call minscm#executeCheckout        (len(<q-bang>), minscm#getTargetDir())
  command! -bang MinSCMMerge            call minscm#executeMerge           (len(<q-bang>), minscm#getTargetDir())
  command! -bang MinSCMBranch           call minscm#executeBranch          (len(<q-bang>), minscm#getTargetDir())
  command! -bang MinSCMBranchDelete     call minscm#executeBranchDelete    (len(<q-bang>), minscm#getTargetDir())
  command! -bang MinSCMRebase           call minscm#executeRebase          (len(<q-bang>), minscm#getTargetDir())
  command! -bang MinSCMDiffFile         call minscm#executeDiffFile        (len(<q-bang>), minscm#getTargetDir())
  command! -bang MinSCMDiffAll          call minscm#executeDiffAll         (len(<q-bang>), minscm#getTargetDir())
  command! -bang MinSCMLog              call minscm#executeLog             (len(<q-bang>), minscm#getTargetDir())
  command! -bang MinSCMStatus           call minscm#executeStatus          (len(<q-bang>), minscm#getTargetDir())
  command! -bang MinSCMGrep             call minscm#executeGrep            (len(<q-bang>), minscm#getTargetDir())
  command! -bang MinSCMLoadAll          call minscm#executeLoadAll         (len(<q-bang>), minscm#getTargetDir())
  " --------------------------------------------------------------------------
  let tableMapping = [
        \   [':     ', ':MinSCMCommand'      ],
        \   ['C     ', ':MinSCMCommitFile'   ],
        \   ['<C-c> ', ':MinSCMCommitTracked'],
        \   ['c     ', ':MinSCMCommitAll'    ],
        \   ['o     ', ':MinSCMCheckout'     ],
        \   ['m     ', ':MinSCMMerge'        ],
        \   ['b     ', ':MinSCMBranch'       ],
        \   ['B     ', ':MinSCMBranchDelete' ],
        \   ['r     ', ':MinSCMRebase'       ],
        \   ['D     ', ':MinSCMDiffFile'     ],
        \   ['d     ', ':MinSCMDiffAll'      ],
        \   ['l     ', ':MinSCMLog'          ],
        \   ['s     ', ':MinSCMStatus'       ],
        \   ['g     ', ':MinSCMGrep'         ],
        \   ['<CR>  ', ':MinSCMLoadAll'      ],
        \ ]
  for [leader, bang] in [ [g:minscm_mapLeader, ''], [g:minscm_mapLeaderAlternate, '!'] ]
    execute printf('nnoremap <silent> %s      <Nop>', leader)
    execute printf('nnoremap <silent> %s<Esc> <Nop>', leader)
    for [key, cmd] in tableMapping
      execute printf('nnoremap <silent> %s%s %s%s<CR>', leader, key, cmd, bang)
    endfor
  endfor
  " --------------------------------------------------------------------------
  augroup MinSCMGlobal
    autocmd!
    autocmd CursorHold   * call minscm#invalidateStatusReport(minscm#getTargetDir())
    autocmd CursorHoldI  * call minscm#invalidateStatusReport(minscm#getTargetDir())
    "autocmd BufWritePost * call minscm#invalidateStatusReport(minscm#getTargetDir())
  augroup END
  " --------------------------------------------------------------------------
endfunction

" }}}1
"=============================================================================
" INITIALIZATION: {{{1

call s:initialize()

" }}}1
"=============================================================================
" vim: set fdm=marker:
