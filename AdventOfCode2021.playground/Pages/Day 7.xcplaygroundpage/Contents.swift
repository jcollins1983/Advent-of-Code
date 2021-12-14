//: [Previous](@previous)

import Foundation

guard let fileUrl = Bundle.main.url(forResource: "P7", withExtension: ".txt") else { fatalError() }

var crabPositions = try String(contentsOf: fileUrl, encoding: String.Encoding.utf8).split(separator: ",").map{Int($0)!}

// brute force
var fuelBurnBrute = [Int]()
for pos in crabPositions
{
    fuelBurnBrute.append(crabPositions.map { abs($0 - pos)}.reduce(0, +))

}
print("Brute Force Method: \(fuelBurnBrute.min()!)")

// using median
func getMedian(array: [Int]) -> Float
{
    // sort the array
    let sorted = array.sorted()
    let numElements = sorted.count
    if numElements % 2 != 0
    {
        // median is the last index / 2
        return Float(sorted[((numElements - 1) / 2)])
    }
    else
    {
        // median is the average of the 2 values in the middle
        return Float((sorted[(numElements / 2) - 1] + sorted[numElements / 2]) / 2)
    }
}
let median = getMedian(array: crabPositions)
let fuelBurnMedian = crabPositions.map { abs(Float($0) - median) }.reduce(0, +)
print("Median method: \(fuelBurnMedian)")
//: [Next](@next)
