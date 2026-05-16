test_filter_runs_only_matching() {
  test_filterme_yes() { assert_true 1 }
  test_filterme_also_yes() { assert_true 1 }
  test_nope_not_this() { assert_true 1 }

  run run_tests -n filterme
  unfunction test_filterme_yes test_filterme_also_yes test_nope_not_this

  assert_equal 0 $rc
  assert_contains $out "2 passed"
}

test_filter_no_match_returns_error() {
  run run_tests -n zzz_no_such_test
  assert_equal 1 $rc
}
