//: [Previous](@previous)

import Cocoa

let file = "P1.txt"

// get file handle
guard let fileUrl = Bundle.main.url(forResource: "P1", withExtension: ".txt") else { fatalError() }
// read the file
let text = try String(contentsOf: fileUrl, encoding: String.Encoding.utf8)
// split the file into individual elements
let vals = text.split(separator: "\n")
// map to Int
var p1_list:[Int] = vals.map {Int($0)!}

var increased = 0

// find total increased starting from second element
for idx in 1...p1_list.count - 1
{
    if p1_list[idx] > p1_list[idx - 1]
    {
        increased += 1
    }
}
print(increased)

// find increased from moving window of three
increased = 0 // reusing increased because lazy
for idx in 0...p1_list.count - 1
{
    // I had two options, only iterate up to the end of the array - 4 for the last set or use this guard statement.
    guard idx <= p1_list.count - 4 else {
        break // we don't have enough to sum 3
    }
    let first_sum = p1_list[idx] + p1_list[idx + 1] + p1_list[idx + 2]
    let second_sum = p1_list[idx + 1] + p1_list[idx + 2] + p1_list[idx + 3]
    if second_sum > first_sum
    {
        increased += 1
    }
}
print(increased)


//: [Next](@next)
