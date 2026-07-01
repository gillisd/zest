test_tty_typing_fills_buffer() {
  tty_start
  tty_type "hello world"
  assert_tty_buffer "hello world"
  assert_tty_cursor_at 11
}

test_tty_widget_transforms_buffer() {
  tty_start
  tty_run 'zest-demo-upcase() { LBUFFER=${(U)LBUFFER} }; zle -N zest-demo-upcase; bindkey "^T" zest-demo-upcase'
  tty_type "hello world"
  tty_press '^T'
  assert_tty_buffer "HELLO WORLD"
  assert_tty_cursor_at 11
}

test_tty_widget_can_call_builtin_widgets() {
  # the fidelity proof: a faked ZLE cannot do this
  tty_start
  tty_run 'zest-demo-kill() { zle backward-kill-word }; zle -N zest-demo-kill; bindkey "^T" zest-demo-kill'
  tty_type "rm -rf precious"
  tty_press '^T'
  assert_tty_buffer "rm -rf "
  assert_tty_cursor_at 7
}

test_tty_builtin_motion_moves_cursor() {
  tty_start
  tty_type "hello"
  tty_press '^A'
  assert_tty_cursor_at 0
  assert_tty_buffer "hello"
  tty_press '^E'
  assert_tty_cursor_at 5
}

test_tty_source_loads_a_file() {
  local widget_file=$(mktemp)
  cat > $widget_file <<'WF'
zest-demo-shout() {
  BUFFER="${BUFFER}!"
  CURSOR=$#BUFFER
}
zle -N zest-demo-shout
bindkey '^T' zest-demo-shout
WF
  tty_start
  tty_source $widget_file
  zf_rm -f $widget_file
  tty_type "ship it"
  tty_press '^T'
  assert_tty_buffer "ship it!"
  assert_tty_cursor_at 8
}

test_tty_exposes_split_buffers() {
  tty_start
  tty_type "hello"
  tty_press '^A'
  assert_tty_cursor_at 0
  assert_equal "" "$zest_tty_lbuffer"
  assert_equal "hello" "$zest_tty_rbuffer"
}

test_tty_refute_buffer() {
  tty_start
  tty_type "abc"
  refute_tty_buffer "xyz"
  refute_tty_cursor_at 99
}

test_tty_restart_gives_fresh_session() {
  tty_start
  tty_type "leftover state"
  tty_start
  tty_type "clean"
  assert_tty_buffer "clean"
}

test_tty_source_copies_a_function() {
  zest-demo-newline() { LBUFFER+=$'\n' }
  tty_start
  tty_source zest-demo-newline
  tty_run 'zle -N zest-demo-newline; bindkey "^T" zest-demo-newline'
  tty_type "a"
  tty_press '^T'
  tty_type "b"
  assert_tty_buffer $'a\nb'
  assert_tty_cursor_at 3
}
