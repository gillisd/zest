test_skip_marks_test_as_skipped() {
  skip
  assert_equal "this should not run" "but it does"
}

test_skip_with_message() {
  skip "not implemented yet"
  assert_equal "this should not run" "but it does"
}
