test_assert_file_exists_on_success() {
  local tmpfile=$(mktemp)
  run assert_file_exists $tmpfile
  assert_equal 0 $rc
  zf_rm -f $tmpfile
}

test_assert_file_exists_on_failure() {
  run assert_file_exists /nonexistent/path/to/file
  assert_equal 1 $rc
}

test_assert_file_exists_directory() {
  run assert_file_exists /tmp
  assert_equal 1 $rc
}

test_refute_file_exists_on_success() {
  run refute_file_exists /nonexistent/path/to/file
  assert_equal 0 $rc
}

test_refute_file_exists_on_failure() {
  local tmpfile=$(mktemp)
  run refute_file_exists $tmpfile
  assert_equal 1 $rc
  zf_rm -f $tmpfile
}

test_refute_file_exists_directory() {
  run refute_file_exists /tmp
  assert_equal 0 $rc
}
