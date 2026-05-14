define_assertion__defined() {
  arg actual

  assertion_message "expected {actual} to be defined but was not"
  refution_message "expected {actual} to be undefined but was not"

  check() {
    assert $+parameters[$actual]
  }
}

define_assertion__greater_than() {
  arg needle integer
  arg actual integer

  assertion_message "expected {actual} to be greater than {needle} but was not"
  refution_message "expected {actual} to not be greater than {needle} but was"

  check() {
    assert $(( actual > needle ))
  }
}

define_assertion__less_than() {
  arg needle integer
  arg actual integer

  assertion_message "expected {actual} to be less than {needle} but was not"
  refution_message "expected {actual} to not be less than {needle} but was"

  check() {
    assert $(( actual < needle ))
  }
}

define_assertion__true() {
  arg actual
  assertion_message "expected {actual} to be %Btruthy%b but was not"
  refution_message "expected {actual} to not be %Btruthy%b but was"

  check() {
    assert $actual
  }
}

define_assertion__false() {
  arg actual
  assertion_message "expected {actual} to be %Bfalsey%b but was not"
  refution_message "expected {actual} to not be %Bfalsey%b but was"

  check() {
    refute $actual
  }
}

define_assertion__equal() {
  arg actual
  arg needle
  assertion_message "{needle} != {actual}"
  refution_message "{needle} == {actual}"

  check() {
    if [[ $actual = $needle ]]; then
      return 0
    else
      return 1
    fi
  }
}

define_assertion__match() {
  arg actual
  arg needle

  assertion_message "expected {actual} to match {needle} but did not"
  refution_message "expected {actual} to not match {needle} but did"

  check() {
    [[ $actual =~ $needle ]]
  }
}

define_assertion__contains() {
  arg actual
  arg needle

  assertion_message "expected {actual} to contain {needle} but did not"
  refution_message "expected {actual} to not contain {needle} but did"

  check() {
    if __zest_is_array $actual; then
      integer filtered_length=${#${${(P)actual}:#$needle}}
      integer actual_length=${#${(P)actual}}
      (( filtered_length < actual_length ))
    else
      [[ $actual = *${needle}* ]]
    fi
  }
}

define_assertion__file_exists() {
  arg actual

  assertion_message "expected file {actual} to exist but did not"
  refution_message "expected file {actual} to not exist but did"

  check() {
    [[ -e $actual ]]
  }
}

define_assertion__empty() {
  arg actual

  assertion_message "expected {actual} to be empty but was not"
  refution_message "expected {actual} to not be empty but was"

  check() {
    if [[ -n $actual ]] && __zest_is_array $actual; then
      (( ${#${(P)${actual}}} == 0 ))
    else
      [[ -z $actual ]]
    fi
  }
}
