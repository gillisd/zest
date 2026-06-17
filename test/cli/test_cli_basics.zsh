test_cli_passing_file_exits_zero() {
  local fixture=$(mktemp)
  print 'test_cli_inner_ok() { assert_equal 1 1 }' > $fixture
  run zsh $__ZEST_ROOT_DIR/zest $fixture
  zf_rm -f $fixture
  assert_equal 0 $rc
  assert_contains $out "1 passed, 0 failed"
}

test_cli_failing_file_exits_one() {
  local fixture=$(mktemp)
  print 'test_cli_inner_bad() { assert_equal a b }' > $fixture
  run zsh $__ZEST_ROOT_DIR/zest $fixture
  zf_rm -f $fixture
  assert_equal 1 $rc
  assert_contains $err "0 passed, 1 failed"
}

test_cli_runs_without_zshrc() {
  local fixture=$(mktemp)
  local fakehome=$(mktemp -d)
  print 'test_cli_inner_norc() { assert_equal 1 1 }' > $fixture
  run env HOME=$fakehome ZDOTDIR=$fakehome zsh $__ZEST_ROOT_DIR/zest $fixture
  zf_rm -rf $fixture $fakehome
  assert_equal 0 $rc
  assert_contains $out "1 passed, 0 failed"
}

test_sourcing_noninteractively_loads_and_returns() {
  run zsh -c "source ${(q)__ZEST_ROOT_DIR}/zest; print LOADED_OK"
  assert_equal 0 $rc
  assert_contains $out LOADED_OK
  refute_contains $out "now initialized"
}

test_interactive_banner_appears_once() {
  local fakehome=$(mktemp -d)
  integer zstat=0
  local output
  output="$(print exit | env HOME=$fakehome ZDOTDIR=$fakehome TERM=dumb zsh $__ZEST_ROOT_DIR/zest 2>&1)" || zstat=$?
  zf_rm -rf $fakehome
  assert_equal 0 $zstat
  integer banner_count=${#${(M)${(f)output}:#*now initialized*}}
  assert_equal 1 $banner_count
}
