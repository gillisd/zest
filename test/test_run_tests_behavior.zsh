test_unknown_explicit_name_is_a_failure() {
  test_rb_known_sibling() { assert_equal 1 1 }
  run run_tests test_rb_known_sibling test_rb_no_such_thing
  unfunction test_rb_known_sibling
  assert_equal 1 $rc
  assert_contains $out "no such test function: test_rb_no_such_thing"
  assert_contains $err "1 passed, 1 failed"
}

test_run_tests_survives_hostile_caller_options() {
  test_rb_hostile_fail() { assert_equal a b }
  test_rb_hostile_pass() { assert_equal 1 1 }
  setopt ksharrays shwordsplit
  run run_tests test_rb_hostile_fail test_rb_hostile_pass
  unsetopt ksharrays shwordsplit
  unfunction test_rb_hostile_fail test_rb_hostile_pass
  assert_equal 1 $rc
  assert_contains $out "FAIL"
  assert_contains $err "1 passed, 1 failed"
}

test_failing_test_under_caller_errreturn_still_summarizes() {
  # test bodies already run under errreturn; run_tests inherits it through
  # the subshell and must still print the FAIL line and the summary
  test_rb_err_fail() { assert_equal a b }
  test_rb_err_pass() { assert_equal 1 1 }
  run run_tests test_rb_err_fail test_rb_err_pass
  unfunction test_rb_err_fail test_rb_err_pass
  assert_equal 1 $rc
  assert_contains $out "FAIL"
  assert_contains $out "rb err fail"
  assert_contains $out "rb err pass"
  assert_contains $err "1 passed, 1 failed"
}
