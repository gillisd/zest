test_assert_contains_string_on_success() {
  run assert_contains "hello world" "world"
  assert_equal 0 $rc
}

test_assert_contains_string_on_failure() {
  run assert_contains "hello world" "mars"
  assert_equal 1 $rc
}

test_assert_contains_string_exact_match() {
  run assert_contains "foo" "foo"
  assert_equal 0 $rc
}

test_assert_contains_string_empty_needle() {
  run assert_contains "foo" ""
  assert_equal 0 $rc
}

test_assert_contains_array_ref_on_success() {
  local -a fruit=(apple cherry banana)
  run assert_contains fruit cherry
  assert_equal 0 $rc
}

test_assert_contains_array_ref_on_failure() {
  local -a fruit=(apple cherry banana)
  run assert_contains fruit mango
  assert_equal 1 $rc
}

test_assert_contains_array_ref_empty_array() {
  local -a fruit=()
  run assert_contains fruit apple
  assert_equal 1 $rc
}

test_refute_contains_string_on_success() {
  run refute_contains "hello world" "mars"
  assert_equal 0 $rc
}

test_refute_contains_string_on_failure() {
  run refute_contains "hello world" "world"
  assert_equal 1 $rc
}

test_refute_contains_string_exact_match() {
  run refute_contains "foo" "foo"
  assert_equal 1 $rc
}

test_refute_contains_string_empty_needle() {
  run refute_contains "foo" ""
  assert_equal 1 $rc
}

test_refute_contains_array_ref_on_success() {
  local -a fruit=(apple cherry banana)
  run refute_contains fruit mango
  assert_equal 0 $rc
}

test_refute_contains_array_ref_on_failure() {
  local -a fruit=(apple cherry banana)
  run refute_contains fruit cherry
  assert_equal 1 $rc
}

test_refute_contains_array_ref_empty_array() {
  local -a fruit=()
  run refute_contains fruit apple
  assert_equal 0 $rc
}
