//: [Previous](@previous)

import Foundation

guard let fileUrl = Bundle.main.url(forResource: "P7", withExtension: ".txt") else { fatalError() }

var crabPositions = try String(contentsOf: fileUrl, encoding: String.Encoding.utf8).split(separator: ",").map{Int($0)!}
// part 1
var fuelBurn = [Int]()
// brute force
for pos in crabPositions
{
    fuelBurn.append(crabPositions.map { abs($0 - pos)}.reduce(0, +))
    
}
print("\(fuelBurn.min()!)")

//: [Next](@next)
