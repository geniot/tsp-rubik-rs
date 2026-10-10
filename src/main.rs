use raylib::prelude::*;

fn main() {
    let (mut rl, thread) = raylib::init().size(1280, 720).title("Hello, World").build();

    let gamepad: i32 = 0; // which gamepad to display
    let mut should_close = false;

    while !rl.window_should_close() && !should_close {
        let mut d = rl.begin_drawing(&thread);

        d.clear_background(Color::WHITE);
        d.draw_text("Hello, world!", 12, 12, 100, Color::BLACK);

        if d.is_gamepad_button_down(gamepad, GamepadButton::GAMEPAD_BUTTON_LEFT_FACE_UP) {
            should_close = true;
        }
    }
}
