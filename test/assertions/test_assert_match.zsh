test_assert_match_on_success() {
  run assert_match "hello world" "^hello"
  assert_equal 0 $rc
}

test_assert_match_on_failure() {
  run assert_match "hello world" "^world"
  assert_equal 1 $rc
}

test_assert_match_full_line() {
  run assert_match "abc123" "^[a-z]+[0-9]+$"
  assert_equal 0 $rc
}

test_assert_match_partial() {
  run assert_match "foo-bar-baz" "bar"
  assert_equal 0 $rc
}

test_assert_match_special_chars() {
  run assert_match "file.txt" "\.txt$"
  assert_equal 0 $rc
}

test_refute_match_on_success() {
  run refute_match "hello world" "^world"
  assert_equal 0 $rc
}

test_refute_match_on_failure() {
  run refute_match "hello world" "^hello"
  assert_equal 1 $rc
}

test_refute_match_full_line() {
  run refute_match "abc123" "^[a-z]+[0-9]+$"
  assert_equal 1 $rc
}

test_refute_match_partial() {
  run refute_match "foo-bar-baz" "bar"
  assert_equal 1 $rc
}

test_refute_match_special_chars() {
  run refute_match "file.txt" "\.txt$"
  assert_equal 1 $rc
}
