test_run_out() {
  run print foo
  assert_equal foo $out
}

test_run_err() {
  run print -u2 foo
  assert_equal foo $err
}

test_run_rc_on_success() {
  run true
  assert_equal 0 $rc
}

test_run_rc_on_failure() {
  run false
  assert_equal 1 $rc
}

test_run_preserves_empty_args() {
  run assert_contains "" "foo"
  assert_equal 1 $rc
}
