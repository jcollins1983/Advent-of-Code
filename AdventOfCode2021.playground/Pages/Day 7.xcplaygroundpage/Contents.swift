//: [Previous](@previous)

import Foundation

guard let fileUrl = Bundle.main.url(forResource: "P7", withExtension: ".txt") else { fatalError() }

let crabPositions = try String(contentsOf: fileUrl, encoding: String.Encoding.utf8).split(separator: ",").map{Int($0)!}

// Part 1
// brute force
var fuelBurnBrute = [Int]()
for pos in crabPositions
{
    fuelBurnBrute.append(crabPositions.map { abs($0 - pos)}.reduce(0, +))

}
print("Brute Force Method: \(fuelBurnBrute.min()!)")

// using median https://math.stackexchange.com/questions/113270/the-median-minimizes-the-sum-of-absolute-deviations-the-ell-1-norm
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

// Part 2
// nth triangle number https://math.stackexchange.com/questions/593318/factorial-but-with-addition/593323 and https://i1115.photobucket.com/albums/k544/akinuri/nth%20triangle%20number-01.jpg
// brute force
func costToMove(from: Int, to: Int) -> Int
{
    let distance = abs(to - from)
    return distance * (distance + 1) / 2
}

var fuelBurn2BruteForce = [Int]()
for pos in crabPositions
{
    fuelBurn2BruteForce.append(crabPositions.map{ costToMove(from: $0, to: pos) }.reduce(0, +))
}
print("Part 2 Brute Force \(fuelBurn2BruteForce.min()!)")
//: [Next](@next)
