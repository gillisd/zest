test_setup_hook_called() {
  integer count=0
  setup() { (( ++count )) }
  test_check_ran() { assert_greater_than $count 0 }

  run run_tests test_check_ran
  unfunction setup test_check_ran
  assert_equal 0 $rc
}

test_teardown_hook_called() {
  integer count=0
  teardown() { (( ++count )) }
  test_td_first() { assert_equal 0 $count }
  test_td_second() { assert_equal 1 $count }

  run run_tests test_td_first test_td_second
  unfunction teardown test_td_first test_td_second
  assert_equal 0 $rc
}

test_setup_failure_is_recorded() {
  setup() { return 1 }
  test_after_bad_setup() { assert_true 1 }

  run run_tests test_after_bad_setup
  unfunction setup test_after_bad_setup
  assert_equal 1 $rc
}

test_setup_failure_skips_test_body() {
  setup() { return 1 }
  test_st_inner_marker() { print BODY_EXECUTED_MARKER }

  run run_tests test_st_inner_marker
  unfunction setup test_st_inner_marker
  assert_equal 1 $rc
  refute_contains $out BODY_EXECUTED_MARKER
}

test_teardown_still_runs_after_setup_failure() {
  setup() { return 1 }
  teardown() { print TEARDOWN_RAN_MARKER }
  test_st_inner_td() { print BODY_EXECUTED_MARKER }

  run run_tests test_st_inner_td
  unfunction setup teardown test_st_inner_td
  assert_equal 1 $rc
  assert_contains $out TEARDOWN_RAN_MARKER
  refute_contains $out BODY_EXECUTED_MARKER
}
