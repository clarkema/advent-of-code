use std::fs::File;
use std::io::Read;

fn captcha_sum(input: &str, rotation: usize) -> u32 {
    let mut acc = 0;

    let digits = input.chars()
                    .map(|c| c.to_digit(10).unwrap())
                    .collect::<Vec<u32>>();

    for (i, c) in digits.iter().enumerate() {
        if digits[(i + rotation) % digits.len()] == *c {
            acc += *c;
        }
    }

    acc
}

fn main() {
    let filename = "../day_01.input";
    let mut input = String::new();

    let mut fh = File::open(filename).expect("file not found");

    fh.read_to_string(&mut input)
        .expect("something went wrong reading the file");

    let input = input.trim();

    println!("Part 1: {:?}", captcha_sum(&input, 1));
    println!("Part 2: {:?}", captcha_sum(&input, input.len() / 2));
}
