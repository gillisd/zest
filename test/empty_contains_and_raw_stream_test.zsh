# Regression tests for two fixes:
#   1. assert_contains/refute_contains with an empty scalar haystack must
#      fail or pass like any assertion -- not abort the runner via the
#      ${1:?} in __zest_is_array.  (Upstream home: test/assertions/
#      test_assert_contains.zsh)
#   2. $zest_tty_raw is the README-documented public raw stream: defined,
#      populated by snapshots, reset by tty_start, and it survives session
#      death while the editor state is poisoned.  (Upstream home:
#      test/tty/test_tty_hardening.zsh)
#
# Unpatched, the tests sort so the diagnosis reads top to bottom: the two
# run-wrapped tests fail cleanly, then refute_contains kills the runner
# mid-file and everything after it silently never runs.

test_assert_contains_empty_string_haystack_fails_normally() {
  local out=''
  run assert_contains "$out" needle
  assert_equal 1 $rc
  refute_contains "$err" 'parameter not'
}

test_is_array_declines_a_missing_or_empty_name() {
  # White-box: this is the helper whose ${1:?} could escape and kill the
  # shell; both the zero-argument and the empty-argument form must simply
  # answer "not an array".
  run __zest_is_array
  assert_equal 1 $rc
  refute_contains "$err" 'parameter not'
  run __zest_is_array ''
  assert_equal 1 $rc
  refute_contains "$err" 'parameter not'
}

test_refute_contains_empty_string_haystack_passes() {
  local out=''
  refute_contains "$out" needle
}

test_tty_raw_is_populated_by_snapshot() {
  tty_start
  tty_type 'rawtruth'
  tty_snapshot
  assert_defined zest_tty_raw
  assert_contains "$zest_tty_raw" rawtruth
  assert_contains "$zest_tty_raw" ZESTSNAPSTART
}

test_tty_raw_is_reset_by_tty_start() {
  tty_start
  tty_type 'rawtruth'
  tty_snapshot
  assert_contains "$zest_tty_raw" rawtruth
  tty_start
  assert_empty "$zest_tty_raw"
}

test_tty_dead_session_keeps_raw_while_poisoning_state() {
  tty_start
  tty_type 'doomed'
  tty_snapshot
  # White-box, matching the existing dead-session test: delete the pty
  # under the harness, then take the poisoned snapshot.  The guard keeps
  # its intended non-zero from tripping err_return.
  zpty -d $__zest_tty_session
  local rc=0
  __zest_tty_snapshot || rc=$?
  local buffer=$zest_tty_buffer raw=$zest_tty_raw
  __zest_tty_cleanup
  assert_equal 1 "$rc"
  assert_equal '<tty snapshot unavailable: session ended>' "$buffer"
  assert_contains "$raw" doomed
  refute_contains "$raw" 'snapshot unavailable'
}
