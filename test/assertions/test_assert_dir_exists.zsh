test_assert_dir_exists_on_success() {
  local tmpdir=$(mktemp -d)
  run assert_dir_exists $tmpdir
  assert_equal 0 $rc
  zf_rm -f $tmpdir
}

test_assert_dir_exists_on_failure() {
  run assert_dir_exists /nonexistent/path/to/dir
  assert_equal 1 $rc
}

test_assert_dir_exists_file() {
  local tmpfile=$(mktemp)
  run assert_dir_exists $tmpfile
  assert_equal 1 $rc
}

test_refute_dir_exists_on_success() {
  run refute_dir_exists /nonexistent/path/to/dir
  assert_equal 0 $rc
}

test_refute_dir_exists_on_failure() {
  local tmpdir=$(mktemp -d)
  run refute_dir_exists $tmpdir
  assert_equal 1 $rc
  zf_rm -f $tmpdir
}

test_refute_dir_exists_file() {
  local tmpfile=$(mktemp)
  run refute_dir_exists $tmpfile
  assert_equal 0 $rc
}
