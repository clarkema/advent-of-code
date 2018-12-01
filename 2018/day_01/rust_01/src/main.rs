use std::fs::File;
use std::io::{self, BufRead};
use std::collections::HashSet;

fn part1(drifts: &[i32]) -> i32 {
    drifts.iter().sum()
}

fn part2(drifts: &[i32]) -> i32 {
    let mut seen = HashSet::new();

    drifts.iter().cycle()
        .scan(0, |acc, x| {
            *acc = *acc + x;
            Some(*acc)
        })
        .skip_while(|x| { seen.insert(x.clone()) })
        .nth(0)
        .unwrap()
}

fn main() {
    let filename = "../day_01.input";

    let fh = File::open(filename).expect("Failed to open file");

    let drifts: Vec<i32> = io::BufReader::new(fh).lines()
        .map(|l| l.unwrap().parse::<i32>().unwrap())
        .collect();

    println!("Part 1: {}", part1(&drifts));
    println!("Part 2: {}", part2(&drifts));
}
