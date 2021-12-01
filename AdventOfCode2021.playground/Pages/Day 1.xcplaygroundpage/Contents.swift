//: [Previous](@previous)

import Cocoa

let file = "P1.txt"

guard let fileUrl = Bundle.main.url(forResource: "P1", withExtension: ".txt") else { fatalError()}
let text = try String(contentsOf: fileUrl, encoding: String.Encoding.utf8)

let vals = text.split(separator: "\n")

var p1_list:[Int] = []

for val in vals
{
    p1_list.append(Int(val) ?? 0)
}

var increased = 0

// find total increased
for idx in 1...p1_list.count - 1
{
    if p1_list[idx] > p1_list[idx - 1]
    {
        increased += 1
    }
}
print(increased)

// find increased from moving window of three
increased = 0
for idx in 0...p1_list.count - 1
{
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
