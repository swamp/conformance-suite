struct Aggregate {
    first: Int
    second: Int
}

enum Value {
    Empty
    Data Aggregate
    Other Aggregate
}

#[test]
fn enum_match_expression_uses_switch_for_aggregate_payload() {
    value := Value::Data { first: 10, second: 20 }
    result := match value {
        Data { first, second } -> first + second
        Other { first, second } -> first - second
        Empty -> 0
    }
    assert(result == 30, 'match expression should select Data')
}

//< hir
fn enum_match_expression_uses_switch_for_aggregate_payload
fn enum_match_expression_uses_switch_for_aggregate_payload()
; value := Value::Data { first: 10, second: 20 }
t0: Value := alloc Value
t0.0 = 1
t0.2.0 = 10
t0.2.1 = 20
; result := match value {
t2: Int := @t0: Value.0
t1: Int := switch t2
1 ->
  ; Data { first, second } -> first + second
  t3: Int := @t0: Value.2.0
  t4: Int := @t0: Value.2.1
  <- t3 + t4
2 ->
  ; Other { first, second } -> first - second
  t5: Int := @t0: Value.3.0
  t6: Int := @t0: Value.3.1
  <- t5 - t6
0 ->
  ; Empty -> 0
  <- 0
_  ->
  ; result := match value {
  <- Unreachable!
; assert(result == 30, 'match expression should select Data')
if t1 != 30
  #Panic("match expression should select Data")
//>

#[test]
fn match_statement_uses_switch_for_aggregate_payload() {
    value := Value::Other { first: 10, second: 20 }
    mut result := 0
    match value {
        Data payload -> { result = payload.first + payload.second }
        Other payload -> { result = payload.first - payload.second }
        Empty -> { result = 0 }
    }
    assert(result == -10, 'match statement should select Other')
}

//< hir
fn match_statement_uses_switch_for_aggregate_payload
fn match_statement_uses_switch_for_aggregate_payload()
; value := Value::Other { first: 10, second: 20 }
t0: Value := alloc Value
t0.0 = 2
t0.3.0 = 10
t0.3.1 = 20
; mut result := 0
t1: Int := 0
; match value {
t2: Int := @t0: Value.0
switch t2
1 ->
  ; Data payload -> { result = payload.first + payload.second }
  t3: Aggregate := @t0: Value.2
  t4: Int := @t3: Aggregate.0
  t5: Int := @t3: Aggregate.1
  t1: Int := t4 + t5
2 ->
  ; Other payload -> { result = payload.first - payload.second }
  t6: Aggregate := @t0: Value.3
  t7: Int := @t6: Aggregate.0
  t8: Int := @t6: Aggregate.1
  t1: Int := t7 - t8
0 ->
  ; Empty -> { result = 0 }
  t1 = 0
_ ->
; assert(result == -10, 'match statement should select Other')
if t1 != -10
  #Panic("match statement should select Other")

//>




#[test]
fn match_statement_uses_switch_for_aggregate_payload_rest() {
    value : Value = Other { second: 20 .. }
    mut result := 0
    match value {
        Data payload -> { result = payload.first + payload.second }
        Other { second } -> { result = second }
        Empty -> { result = 0 }
    }
    assert(result == 20, 'match statement should select Other')
}

//< hir
fn match_statement_uses_switch_for_aggregate_payload_rest
fn match_statement_uses_switch_for_aggregate_payload_rest()
; value : Value = Other { second: 20 .. }
t0: Value := alloc Value
t0.0 = 2
t0.3.1 = 20
t0.3.0 = 0
; mut result := 0
t1: Int := 0
; match value {
t2: Int := @t0: Value.0
switch t2
1 ->
  ; Data payload -> { result = payload.first + payload.second }
  t3: Aggregate := @t0: Value.2
  t4: Int := @t3: Aggregate.0
  t5: Int := @t3: Aggregate.1
  t1: Int := t4 + t5
2 ->
  ; Other { second } -> { result = second }
  t6: Int := @t0: Value.3.1
  t1 = t6
0 ->
  ; Empty -> { result = 0 }
  t1 = 0
_ ->
; assert(result == 20, 'match statement should select Other')
if t1 != 20
  #Panic("match statement should select Other")
//>
