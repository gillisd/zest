test_assert_equal_on_success() {
  run assert_equal foo foo
  assert_equal 0 $rc
}

test_assert_equal_on_failure() {
  run assert_equal foo bar
  assert_equal 1 $rc
}

test_assert_equal_empty_strings() {
  run assert_equal "" ""
  assert_equal 0 $rc
}

test_assert_equal_empty_vs_nonempty() {
  run assert_equal "" "foo"
  assert_equal 1 $rc
}

test_assert_equal_with_spaces() {
  run assert_equal "hello world" "hello world"
  assert_equal 0 $rc
}

test_assert_equal_with_spaces_mismatch() {
  run assert_equal "hello world" "hello  world"
  assert_equal 1 $rc
}

test_assert_equal_numeric_strings() {
  run assert_equal 42 42
  assert_equal 0 $rc
}

test_assert_equal_numeric_string_mismatch() {
  run assert_equal 42 043
  assert_equal 1 $rc
}

test_refute_equal_on_success() {
  run refute_equal foo bar
  assert_equal 0 $rc
}

test_refute_equal_on_failure() {
  run refute_equal foo foo
  assert_equal 1 $rc
}

test_refute_equal_empty_strings() {
  run refute_equal "" ""
  assert_equal 1 $rc
}

test_refute_equal_empty_vs_nonempty() {
  run refute_equal "" "foo"
  assert_equal 0 $rc
}

test_assert_equal_trailing_newline_mismatch() {
  run assert_equal $'foo\n' "foo"
  assert_equal 1 $rc
}

test_assert_equal_trailing_newline_match() {
  run assert_equal $'foo\n' $'foo\n'
  assert_equal 0 $rc
}

test_assert_equal_embedded_newlines() {
  run assert_equal $'foo\nbar' $'foo\nbar'
  assert_equal 0 $rc
}

test_assert_equal_embedded_newline_mismatch() {
  run assert_equal $'foo\nbar' $'foobar'
  assert_equal 1 $rc
}

test_assert_equal_crlf_vs_lf() {
  run assert_equal $'foo\r\n' $'foo\n'
  assert_equal 1 $rc
}

test_assert_equal_newline_only_vs_empty() {
  run assert_equal $'\n' ""
  assert_equal 1 $rc
}
