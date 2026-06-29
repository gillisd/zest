test_tty_typing_fills_buffer() {
  tty_available || { skip "zsh/zpty unavailable"; return 0 }
  tty_start
  tty_type "hello world"
  assert_buffer "hello world"
  assert_cursor_at 11
}

test_tty_widget_transforms_buffer() {
  tty_available || { skip "zsh/zpty unavailable"; return 0 }
  tty_start
  tty_run 'zest-demo-upcase() { LBUFFER=${(U)LBUFFER} }; zle -N zest-demo-upcase; bindkey "^T" zest-demo-upcase'
  tty_type "hello world"
  tty_press '^T'
  assert_buffer "HELLO WORLD"
  assert_cursor_at 11
}

test_tty_widget_can_call_builtin_widgets() {
  # the fidelity proof: a faked ZLE cannot do this
  tty_available || { skip "zsh/zpty unavailable"; return 0 }
  tty_start
  tty_run 'zest-demo-kill() { zle backward-kill-word }; zle -N zest-demo-kill; bindkey "^T" zest-demo-kill'
  tty_type "rm -rf precious"
  tty_press '^T'
  assert_buffer "rm -rf "
  assert_cursor_at 7
}

test_tty_builtin_motion_moves_cursor() {
  tty_available || { skip "zsh/zpty unavailable"; return 0 }
  tty_start
  tty_type "hello"
  tty_press '^A'
  assert_cursor_at 0
  assert_buffer "hello"
  tty_press '^E'
  assert_cursor_at 5
}

test_tty_start_sources_widget_files() {
  tty_available || { skip "zsh/zpty unavailable"; return 0 }
  local widget_file=$(mktemp)
  cat > $widget_file <<'WF'
zest-demo-shout() {
  BUFFER="${BUFFER}!"
  CURSOR=$#BUFFER
}
zle -N zest-demo-shout
bindkey '^T' zest-demo-shout
WF
  tty_start $widget_file
  zf_rm -f $widget_file
  tty_type "ship it"
  tty_press '^T'
  assert_buffer "ship it!"
  assert_cursor_at 8
}

test_tty_exposes_split_buffers() {
  tty_available || { skip "zsh/zpty unavailable"; return 0 }
  tty_start
  tty_type "hello"
  tty_press '^A'
  assert_cursor_at 0
  assert_equal "" "$zest_tty_lbuffer"
  assert_equal "hello" "$zest_tty_rbuffer"
}

test_tty_refute_buffer() {
  tty_available || { skip "zsh/zpty unavailable"; return 0 }
  tty_start
  tty_type "abc"
  refute_buffer "xyz"
  refute_cursor_at 99
}

test_tty_restart_gives_fresh_session() {
  tty_available || { skip "zsh/zpty unavailable"; return 0 }
  tty_start
  tty_type "leftover state"
  tty_start
  tty_type "clean"
  assert_buffer "clean"
}
