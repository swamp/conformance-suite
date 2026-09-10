#[test]
fn when_works_with_pointers() {
    p: *mut U32 = 0xffff
    assert(p, 'it should be set {p}')
    when p {
        print('worked! {p}')
    } else {
        panic('p is non-zero it should not reach this')
    }
}

#[test]
fn when_works_with_zero_pointers() {
    p: *mut U32 = 0
    assert(!p, 'it should be set to zero {p}')
    when p {
        panic('p is zero it should not reach this: {p}')
    } else {
        print('worked! should be zero: {p}')
    }
}