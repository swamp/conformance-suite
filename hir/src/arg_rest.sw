enum Mode {
    Up
    Down Int
}

fn function_with_mode(_a: Int, _m: Mode) {

}

#[test]
fn set_tag_for_rest_mode() {
    function_with_mode(23, ..)
}

//< hir
fn set_tag_for_rest_mode
fn set_tag_for_rest_mode()
; function_with_mode(23, ..)
t0: Mode := alloc Mode (temp)
t0.0 = 0
crate::arg_rest::function_with_mode(23, t0)
//>

struct Point {
    x: Int
    y: Int
}

impl Point {
    fn default() -> Point {
        [42, -1]
    }
}

struct Something {
    a: Point
}

fn function_with_something(_a: Int, _m: Something) {
}

#[test]
fn call_default_for_something() {
    function_with_something(23, ..)
}

//< hir
fn call_default_for_something
fn call_default_for_something()
; function_with_something(23, ..)
t0: Something := alloc Something (temp)
t1: Point := @t0: Something.0
crate::arg_rest::Point::default(t1)
crate::arg_rest::function_with_something(23, t0)
//>


#[test]
fn create_something_with_default_should_zero() {
    mut something : Something

    something.a.x = 1
}

//< hir
fn create_something_with_default_should_zero
fn create_something_with_default_should_zero()
; mut something : Something
t0: Something := alloc Something
t0.0.0 = 0
t0.0.1 = 0
; something.a.x = 1
t0.0.0 = 1
//>

#[test]
fn create_something_with_init_should_not_zero() {
    mut something : Something = {
        a : [10, 20]
    }

    something.a.x = 1
}
//< hir
fn create_something_with_init_should_not_zero
fn create_something_with_init_should_not_zero()
; mut something : Something = {
t0: Something := alloc Something
; a : [10, 20]
t0.0.0 = 10
t0.0.1 = 20
; something.a.x = 1
t0.0.0 = 1
//>

