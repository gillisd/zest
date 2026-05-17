test_assert_defined_on_success() {
  local myvar="hello"
  run assert_defined myvar
  assert_equal 0 $rc
}

test_assert_defined_empty_string_is_defined() {
  local myvar=""
  run assert_defined myvar
  assert_equal 0 $rc
}

test_assert_defined_on_failure() {
  unset myvar 2>/dev/null
  run assert_defined myvar
  assert_equal 1 $rc
}

test_assert_defined_array() {
  local -a myarr=(one two)
  run assert_defined myarr
  assert_equal 0 $rc
}

test_refute_defined_on_success() {
  unset myvar 2>/dev/null
  run refute_defined myvar
  assert_equal 0 $rc
}

test_refute_defined_on_failure() {
  local myvar="hello"
  run refute_defined myvar
  assert_equal 1 $rc
}

test_refute_defined_empty_string_is_still_defined() {
  local myvar=""
  run refute_defined myvar
  assert_equal 1 $rc
}

test_refute_defined_array() {
  local -a myarr=(one two)
  run refute_defined myarr
  assert_equal 1 $rc
}
