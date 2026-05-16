test_run_out() {
  run print foo
  assert_equal foo $out
}

test_run_err() {
  run print -u2 foo
  assert_equal foo $err
}
