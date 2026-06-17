test_zest_print_v_stores_into_variable() {
  local captured=""
  zest_print -v captured "hello"
  assert_equal hello $captured
}

test_zest_print_v_with_color_stores_expanded() {
  local captured=""
  zest_print -v captured --color=green "hi"
  assert_contains $captured "hi"
  refute_equal hi $captured
}

test_zest_print_plain_to_stdout() {
  run zest_print "plain words here"
  assert_equal "plain words here" $out
}

test_zest_print_u2_routes_to_stderr() {
  run zest_print -u2 "to stderr"
  assert_equal "to stderr" $err
  assert_empty "$out"
}

test_zest_print_separator_allows_dash_message() {
  run zest_print -- "-starts with dash"
  assert_equal "-starts with dash" $out
}

test_no_leaked_message_global() {
  run typeset -p message
  assert_equal 1 $rc
}

test_no_leaked_failure_index_global() {
  run typeset -p failure_index
  assert_equal 1 $rc
}
