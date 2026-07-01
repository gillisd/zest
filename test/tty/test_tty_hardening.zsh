# Adversarial tests for the tty/ZLE harness.

test_tty_large_buffer_survives_backpressure() {
  # Set the buffer from a widget, not tty_type: a multi-kilobyte single write
  # can deadlock against the child's redraw where pty buffers are small.
  local big=${(l:4000::x:)}
  local wf=$(mktemp)
  print 'zest-big() { BUFFER=${(l:4000::x:)}; CURSOR=$#BUFFER }; zle -N zest-big; bindkey "^T" zest-big' > $wf
  tty_start
  tty_source $wf
  zf_rm -f $wf
  tty_press '^T'
  assert_tty_buffer "$big"
  assert_tty_cursor_at 4000
}

test_tty_multiline_buffer_roundtrips_exactly() {
  local wf=$(mktemp)
  print 'zest-ml() { BUFFER=$'\''one\ntwo\nthree'\''; CURSOR=$#BUFFER }; zle -N zest-ml; bindkey "^T" zest-ml' > $wf
  tty_start
  tty_source $wf
  zf_rm -f $wf
  tty_press '^T'
  assert_tty_buffer $'one\ntwo\nthree'
  assert_tty_cursor_at 13
}

test_tty_control_bytes_compare_exactly_not_by_rendering() {
  local wf=$(mktemp)
  print 'zest-ctl() { BUFFER=$'\''\x01\x02'\''; CURSOR=2 }; zle -N zest-ctl; bindkey "^T" zest-ctl' > $wf
  tty_start
  tty_source $wf
  zf_rm -f $wf
  tty_press '^T'
  assert_tty_buffer $'\x01\x02'
  refute_tty_buffer '^A^B'
}

test_tty_assertions_are_literal_not_glob() {
  tty_start
  tty_type "abc"
  refute_tty_buffer "a*"
  refute_tty_buffer "ab?"
  refute_tty_buffer "*"

  local wf=$(mktemp)
  print 'zest-star() { BUFFER="a*"; CURSOR=2 }; zle -N zest-star; bindkey "^T" zest-star' > $wf
  tty_start
  tty_source $wf
  zf_rm -f $wf
  tty_press '^T'
  assert_tty_buffer "a*"
  refute_tty_buffer "abc"
}

test_tty_metacharacters_in_buffer_roundtrip() {
  local wf=$(mktemp)
  print 'zest-meta() { BUFFER='\''a$b`c"d|e;f&g'\''; CURSOR=$#BUFFER }; zle -N zest-meta; bindkey "^T" zest-meta' > $wf
  tty_start
  tty_source $wf
  zf_rm -f $wf
  tty_press '^T'
  assert_tty_buffer 'a$b`c"d|e;f&g'
}

test_tty_repeated_snapshots_stay_aligned() {
  tty_start
  tty_type "stable"
  local i
  for i in {1..15}; do
    assert_tty_buffer "stable"
    assert_tty_cursor_at 6
  done
}

test_tty_empty_buffer_roundtrips() {
  tty_start
  assert_tty_buffer ""
  assert_tty_cursor_at 0
}

test_tty_dead_session_poisons_without_hanging() {
  tty_start
  tty_type "doomed"
  # White-box: delete the pty under the harness; the snapshot must poison and
  # return rather than block. The guard keeps its intended non-zero from
  # tripping err_return.
  zpty -d $__zest_tty_session
  local rc=0
  __zest_tty_snapshot || rc=$?
  local captured=$zest_tty_buffer
  __zest_tty_cleanup
  assert_equal 1 "$rc"
  assert_equal "<tty snapshot unavailable: session ended>" "$captured"
}

test_tty_midline_cursor_split_is_exact() {
  tty_start
  tty_type "hello world"
  tty_press '^A'
  tty_press '^F' '^F' '^F' '^F' '^F'
  assert_tty_cursor_at 5
  assert_equal "hello" "$zest_tty_lbuffer"
  assert_equal " world" "$zest_tty_rbuffer"
}
