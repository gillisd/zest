test_assert_truthy_no_message() {
  run assert 1
  assert_equal 0 $rc
}

test_assert_falsey_no_message() {
  run assert 0
  assert_equal 1 $rc
}

test_assert_with_message_on_success_passes() {
  test_pr_inner_q1() { assert 1 "this is true" }
  run run_tests test_pr_inner_q1
  unfunction test_pr_inner_q1
  assert_equal 0 $rc
  assert_contains $out "1 passed, 0 failed"
  refute_contains $out "this is true"
}

test_assert_with_message_on_failure_fails_with_message() {
  test_pr_inner_q2() { assert 0 "zero is falsey" }
  run run_tests test_pr_inner_q2
  unfunction test_pr_inner_q2
  assert_equal 1 $rc
  assert_contains $out "zero is falsey"
}

test_refute_falsey_no_message() {
  run refute 0
  assert_equal 0 $rc
}

test_refute_truthy_no_message() {
  run refute 1
  assert_equal 1 $rc
}

test_refute_with_message_on_success_passes() {
  test_pr_inner_q3() { refute 0 "zero stays falsey" }
  run run_tests test_pr_inner_q3
  unfunction test_pr_inner_q3
  assert_equal 0 $rc
  assert_contains $out "1 passed, 0 failed"
  refute_contains $out "zero stays falsey"
}

test_refute_with_message_on_failure_fails_with_message() {
  test_pr_inner_q4() { refute 1 "one is not falsey" }
  run run_tests test_pr_inner_q4
  unfunction test_pr_inner_q4
  assert_equal 1 $rc
  assert_contains $out "one is not falsey"
}
