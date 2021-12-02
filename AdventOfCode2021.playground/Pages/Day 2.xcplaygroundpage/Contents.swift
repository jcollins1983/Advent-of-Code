//: [Previous](@previous)

import Foundation

let file = "P2.txt"

// get file handle
guard let fileUrl = Bundle.main.url(forResource: "P2", withExtension: ".txt") else { fatalError() }
// read the file
let lines = try String(contentsOf: fileUrl, encoding: String.Encoding.utf8).split(separator: "\n")

// part 1
var total_horizontal = 0
var total_depth = 0

for line in lines {
    let cmd = line.split(separator: " ")
    switch cmd[0]
    {
        case "forward":
            total_horizontal += Int(cmd[1])!
        case "up":
            total_depth -= Int(cmd[1])!
        case "down":
            total_depth += Int(cmd[1])!
        default:
            break
    }
}

print("Total forward: \(total_horizontal)\tTotal depth: \(total_depth)\tProduct: \(total_horizontal * total_depth)")

// part 2
total_horizontal = 0
total_depth = 0
var aim = 0

for line in lines {
    let cmd = line.split(separator: " ")
    switch cmd[0]
    {
        case "forward":
            total_horizontal += Int(cmd[1])!
            total_depth += aim * Int(cmd[1])!
        case "up":
            aim -= Int(cmd[1])!
        case "down":
            aim += Int(cmd[1])!
        default:
            break
    }
}
print("Total Horizontal: \(total_horizontal)\tTotal Depth: \(total_depth)\t Product: \(total_depth * total_horizontal)")
//: [Next](@next)
