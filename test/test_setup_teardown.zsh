test_setup_hook_called() {
  integer count=0
  setup() { (( ++count )) }
  test_check_ran() { assert_greater_than 0 $count }

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
