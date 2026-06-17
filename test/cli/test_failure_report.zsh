test_failure_report_golden() {
  local fixture=$(mktemp)
  cat > $fixture <<'FIX'
test_g1_assert_fails() {
  assert_equal "100%" "99%"
}
test_g2_nonzero() {
  false
}
test_g3_skipped() {
  skip "later"
}
test_g4_passes() {
  assert_equal 1 1
}
FIX
  run zsh $__ZEST_ROOT_DIR/zest $fixture
  local fixture_path=$fixture
  zf_rm -f $fixture

  assert_equal 1 $rc
  assert_contains $out "1) g1 assert fails"
  assert_contains $out "${fixture_path}:2"
  assert_contains $out "Failure/Error: 100% != 99%"
  assert_contains $out "2) g2 nonzero"
  assert_contains $out "test returned non-zero: 1"
  refute_contains $out "(unknown)"
  refute_contains $out "(:"
  assert_contains $err "1 passed, 2 failed, 1 skipped"
}

test_summary_omits_zero_skips() {
  local fixture=$(mktemp)
  print 'test_fr_inner_only() { assert_equal 1 1 }' > $fixture
  run zsh $__ZEST_ROOT_DIR/zest $fixture
  zf_rm -f $fixture
  refute_contains $out "skipped"
}

test_repeated_run_tests_is_stable() {
  local fixture=$(mktemp)
  cat > $fixture <<'FIX'
test_x_reentry_fails() { assert_equal a b }
run_tests test_x_reentry_fails || true
run_tests test_x_reentry_fails || true
FIX
  run zsh $__ZEST_ROOT_DIR/zest $fixture
  local fixture_path=$fixture
  zf_rm -f $fixture

  assert_equal 1 $rc
  # three runs (two explicit, one from the file-mode runner): every failure
  # reports the same real location and numbering restarts at 1 each run
  integer location_hits=${#${(M)${(f)out}:#*${fixture_path}:1*}}
  assert_equal 3 $location_hits
  refute_contains $out "(:"
  refute_contains $out "2)"
}
