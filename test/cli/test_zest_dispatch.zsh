test_zest_function_runs_file_arguments() {
  local tf=$(mktemp)
  print -r -- 'test_sourced_dispatch_marker() { assert_equal 4 $(( 2 + 2 )) }' > $tf

  run zsh -c "source ${(q)__ZEST_ROOT_DIR}/zest; zest ${(q)tf}"

  zf_rm -f $tf

  assert_equal 0 $rc
  assert_contains "$out" 'sourced dispatch marker'
}

test_zest_function_without_arguments_stays_quiet_when_not_interactive() {
  run zsh -c "source ${(q)__ZEST_ROOT_DIR}/zest; zest"

  assert_equal 0 $rc
  assert_empty "$out"
}
