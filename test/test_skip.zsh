test_skip_sets_skipped_flag() {
  zest_current_skipped=false
  skip
  local was_skipped=$zest_current_skipped
  zest_current_skipped=false
  assert_equal true $was_skipped
}

test_skip_sets_message() {
  zest_current_skipped=false
  zest_current_skip_msg=""
  skip "not ready"
  local was_skipped=$zest_current_skipped
  local msg=$zest_current_skip_msg
  zest_current_skipped=false
  zest_current_skip_msg=""
  assert_equal true $was_skipped
  assert_equal "not ready" $msg
}

test_skip_without_message_leaves_empty_msg() {
  zest_current_skip_msg="stale"
  skip
  local msg=$zest_current_skip_msg
  zest_current_skipped=false
  zest_current_skip_msg=""
  assert_empty $msg
}
