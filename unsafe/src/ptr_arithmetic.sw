struct SpaceShip {
    x: Int
    y: Int
    speed: Float
}

#[test]
fn ptr_from_int() {
    p: *U8 = 0xffff
    assert(p == 0xffff, 'should be equal at least')
}

#[test]
fn direct_ptr_from_int() {
    *0xffee::<*mut U8> = 3
}

#[test]
fn direct_ptr_from_u32() {
    address: U32 = 0xffee
    *address::<*mut U8> = 3
}

#[test]
fn direct_read_ptr_from_int() {
    _a := *0xffee::<*U8>
}

#[test]
fn ptr_add_u8() {
    mut p: *U8 = 0xffff

    p += 1

    assert(p == 0x10000, 'should be added {p}')
}

#[test]
fn ptr_add_u16() {
    mut p: *U16 = 0xffff

    p += 1 // this should actually add by 2

    assert(p == 0x10001, 'should be added {p}')
}

#[test]
fn ptr_add_u32() {
    mut p: *U32 = 0xffff

    p += 1 // this should actually add by 4

    assert(p == 0x10003, 'should be added {p}')
}


#[test]
fn ptr_sub_u32() {
    mut p: *U32 = 0xffff

    p -= 1 // this should actually decrease by 4

    assert(p == 0xfffb, 'should be subtracted {p}')
}

#[test]
fn ptr_difference_u32() {
    ptr_a: *U32 = 0xffff
    ptr_b: *U32 = ptr_a + 3
    diff := ptr_b - ptr_a

    assert(diff == 3, 'should be three elements apart: {diff}')
}

#[test]
fn ptr_add_spaceship() {
    mut p: *SpaceShip = 0xffff
    p += 1

    assert(p == 0xffff + 12, 'should add spaceship size: {p}')
}

fn receive_pointer(_p: *const U32) {
}

#[test]
fn pointer_as_argument() {
   p: *mut U32 = 0xffff

   receive_pointer(p)
}

fn return_pointer(p: *U32) -> *U8 {
    q: *U8 = p::<Int>

    q
}

fn receive_byte_pointer(_p: *U8) {

}

#[test]
fn pointer_as_return() {
   p: *mut U32 = 0xffff

   receive_byte_pointer(return_pointer(p))
}

fn takes_spaceship(s: *SpaceShip) {
    print('spaceship: {s}, {*s}')
}

#[test]
fn coerce_from_vec_like() {
    spaceships: Vec<SpaceShip; 8> = [ {speed: 1.2 .. }]

    takes_spaceship(spaceships[0])
}


fn spaceship_field_from_pointer(s: *SpaceShip) -> Float {
    print('spaceship pointer: {s}, and as an aggregate: {*s}')
    s.speed
}

#[test]
fn ptr_field() {
    ship := SpaceShip { 
        speed: 4.26
        ..
    }
    returned_speed := spaceship_field_from_pointer(ship)

    assert(returned_speed == 4.26, 'speed: {returned_speed}')
}

#[test]
fn ptr_as_bool() {
    p: *mut U32 = 0xffff
    assert(p, 'it should be set {p}')
    if !p {
        panic('should have not reached this')
    }
}

#[test]
fn ptr_as_not_bool() {
    p: *mut U32 = 0
    assert(!p, 'it should be set {p}')

    if p {
        panic('should have not reached this')
    }
}


fn set_speed(s: *mut SpaceShip) {
    s.speed = 9.5
}

#[test]
fn mutable_pointer_field() {
    mut ship := SpaceShip { speed: 4.26 .. }
    set_speed(&ship)
    assert(ship.speed == 9.5, 'field write failed')
}


fn get_extra_speed(s: *SpaceShip) -> Float {
    s.speed + 1.0
}

#[test]
fn immutable_pointer_field() {
    ship := SpaceShip { speed: 4.26 .. }
    returned_speed := get_extra_speed(ship)
    assert(returned_speed == 5.26, 'returned: {returned_speed}')
    assert(ship.speed == 4.26, 'field should not change')
}


fn return_spaceship_pointer(s: *SpaceShip) -> *SpaceShip {
    s
}

#[test]
fn pointer_as_return_spaceship() {
    ship := SpaceShip {
        x: 20
        y: 30
        speed: 4.26
    }

    returned_ship := return_spaceship_pointer(ship)

    assert(returned_ship.speed == 4.26, 'field failed')
    assert(returned_ship.x == 20, 'x failed {*returned_ship}')
    assert(returned_ship.y == 30, 'y failed {*returned_ship}')
}


const CONSTANT_SPACESHIP = SpaceShip {
    x: 10
    y: 20
    speed: 8.12
}

fn constant_spaceship_pointer() -> *const SpaceShip {
    CONSTANT_SPACESHIP // This is safe since it is returning a `*const`
}

#[test]
fn const_spaceship_pointer_as_return() {
    spaceship := constant_spaceship_pointer()

    assert(spaceship.x == 10, 'constant pointer x failed')
    assert(spaceship.y == 20, 'constant pointer y failed')
    assert(spaceship.speed == 8.12, 'constant pointer speed failed')
}

fn return_const_from_immutable_location(spaceship: *const SpaceShip) -> *const SpaceShip {
    spaceship
}

fn return_mut_from_mutable_location(spaceship: *mut SpaceShip) -> *mut SpaceShip {
    spaceship
}

struct World {
    spaceships: Vec<SpaceShip; 8>
}

impl World {
    fn get_mut(mut self, index: Int) -> *mut SpaceShip {
        .spaceships[index]
    }
}

#[test]
fn get_mut_from_self() {
    mut w := World {
        spaceships: [{ speed: 2.0 .. }]
    }
    mutable := w.get_mut(0)
    mutable.speed = 13.5
    assert(mutable.speed == 13.5, 'mut pointer should write')
}

#[test]
fn pointer_return_preserves_location_mutability() {
    immutable := return_const_from_immutable_location(CONSTANT_SPACESHIP)
    assert(immutable.x == 10, 'const pointer')

    mut source := SpaceShip { speed: 1.0 .. }
    mutable := return_mut_from_mutable_location(&source)
    mutable.speed = 7.5
    assert(source.speed == 7.5, 'mut pointer should write')
}

struct EmbeddedSpaceShip {
    embed spaceship: SpaceShip
}

fn read_spaceship_pointer(spaceship: *const SpaceShip) -> Float {
    spaceship.speed
}

fn write_spaceship_pointer(spaceship: *mut SpaceShip) {
    spaceship.speed = 6.25
}

#[test]
fn embed_coercion_with_pointers() {
    mut embedded := EmbeddedSpaceShip { spaceship: { speed: 2.5 .. } }

    assert(read_spaceship_pointer(embedded) == 2.5
        'unexpected value')

    write_spaceship_pointer(&embedded)
    assert(embedded.spaceship.speed == 6.25
        'should be 6.5')
}
