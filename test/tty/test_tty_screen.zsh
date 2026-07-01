test_screen_captures_command_output() {
  tty_start
  tty_run 'foo() { print bar }'
  tty_run 'functions foo'
  assert_tty_screen 'foo () {'
  assert_tty_screen 'print bar'
}

test_screen_excludes_what_was_not_printed() {
  tty_start
  tty_run 'true'
  refute_tty_screen 'this was never printed'
}

test_snapshot_populates_editor_buffer_without_asserting() {
  tty_start
  tty_type "hello"
  tty_snapshot
  [[ $zest_tty_buffer == "hello" ]] || { __zest_record_failure "tty_snapshot did not populate \$zest_tty_buffer (got ${(qqq)zest_tty_buffer})"; return 1 }
}

test_screen_variable_is_directly_readable() {
  tty_start
  tty_run 'print marker-xyz'
  tty_snapshot
  [[ $zest_tty_screen == *marker-xyz* ]] || { __zest_record_failure "\$zest_tty_screen not directly readable"; return 1 }
}
