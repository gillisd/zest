test_assert_empty_array_ref_on_success() {
  local -a fruit=()
  run assert_empty fruit
  assert_equal 0 $rc
}

test_assert_empty_array_on_success() {
  local -a fruit=()
  run assert_empty $fruit
  assert_equal 0 $rc
}

test_assert_empty_array_ref_on_error() {
  local -a fruit=(cherry)
  run assert_empty fruit
  assert_equal 1 $rc
}

test_assert_empty_array_on_error() {
  local -a fruit=(cherry)
  run assert_empty $fruit
  assert_equal 1 $rc
}

test_refute_empty_array_ref_on_success() {
  local -a fruit=(cherry)
  run refute_empty fruit
  assert_equal 0 $rc
}

test_refute_empty_array_on_success() {
  local -a fruit=(cherry)
  run refute_empty $fruit
  assert_equal 0 $rc
}

test_refute_empty_array_ref_on_error() {
  local -a fruit=()
  run refute_empty fruit
  assert_equal 1 $rc
}

test_refute_empty_array_on_error() {
  local -a fruit=()
  run refute_empty $fruit
  assert_equal 1 $rc
}

test_assert_empty_string_on_success() {
  local string=""
  run assert_empty $string
  assert_equal 0 $rc
}

test_assert_empty_string_on_error() {
  local string="foo"
  run assert_empty $string
  assert_equal 1 $rc
}

test_refute_empty_string_on_success() {
  local string="foo"
  run refute_empty $string
  assert_equal 0 $rc
}

test_refute_empty_string_on_error() {
  local string=""
  run refute_empty $string
  assert_equal 1 $rc
}
