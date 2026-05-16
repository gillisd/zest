test_assert_greater_than_on_success() {
  run assert_greater_than 5 10
  assert_equal 0 $rc
}

test_assert_greater_than_on_failure() {
  run assert_greater_than 10 5
  assert_equal 1 $rc
}

test_assert_greater_than_equal_values() {
  run assert_greater_than 5 5
  assert_equal 1 $rc
}

test_assert_greater_than_negative() {
  run assert_greater_than -10 0
  assert_equal 0 $rc
}

test_refute_greater_than_on_success() {
  run refute_greater_than 10 5
  assert_equal 0 $rc
}

test_refute_greater_than_equal_values() {
  run refute_greater_than 5 5
  assert_equal 0 $rc
}

test_refute_greater_than_negative() {
  run refute_greater_than 0 -10
  assert_equal 0 $rc
}

test_refute_greater_than_on_failure() {
  run refute_greater_than 5 10
  assert_equal 1 $rc
}

test_assert_less_than_on_success() {
  run assert_less_than 10 5
  assert_equal 0 $rc
}

test_assert_less_than_on_failure() {
  run assert_less_than 5 10
  assert_equal 1 $rc
}

test_assert_less_than_equal_values() {
  run assert_less_than 5 5
  assert_equal 1 $rc
}

test_assert_less_than_negative() {
  run assert_less_than 0 -10
  assert_equal 0 $rc
}

test_refute_less_than_on_success() {
  run refute_less_than 5 10
  assert_equal 0 $rc
}

test_refute_less_than_equal_values() {
  run refute_less_than 5 5
  assert_equal 0 $rc
}

test_refute_less_than_negative() {
  run refute_less_than -10 0
  assert_equal 0 $rc
}

test_refute_less_than_on_failure() {
  run refute_less_than 10 5
  assert_equal 1 $rc
}
