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

test_welcome_banner_renders_exactly_once() {
  # The welcome is produced by __zest_welcome_message, defined in the
  # dispatcher and in scope here. We call it directly rather than launching
  # the no-argument REPL: that path spawns a real --zle interactive shell,
  # and ZLE reads the controlling terminal (/dev/tty) regardless of what is
  # piped to stdin, so it hangs waiting for a human on any machine that has
  # a terminal. Counting banner lines guards the same regression either way
  # -- zero lines (a missing final print) or two (the -v side-effect bug)
  # both fail this assertion.
  local output
  output="$(__zest_welcome_message)"
  integer banner_count=${#${(M)${(f)output}:#*now initialized*}}
  assert_equal 1 $banner_count
  assert_contains $output "now initialized"
}
