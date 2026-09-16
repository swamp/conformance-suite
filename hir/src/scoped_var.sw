#[test]
fn scoped_result_loop_break() {
    a ::= 0 loop {
        a += 1
        if a >= 3 {
            break
        }
    }
    assert(a == 3, 'test')
}
//< hir
fn scoped_result_loop_break ()
fn scoped_result_loop_break()
{
  ; a ::= 0 loop {
  t0: Int := 0
  loop
  {
    ; a += 1
    t0: Int := t0 + 1

    ; if a >= 3 {
    if t0 >= 3
    {
      ; break
      break
    }
  
  }
  ; assert(a == 3, 'test')
  if t0 != 3
  {
    #Panic("test")
  }
}
//>