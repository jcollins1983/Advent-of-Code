//: [Previous](@previous)

import Foundation

guard let fileUrl = Bundle.main.url(forResource: "P7", withExtension: ".txt") else { fatalError() }

var crabPositions = try String(contentsOf: fileUrl, encoding: String.Encoding.utf8).split(separator: ",").map{Int($0)!}
//print(crabPositions)

// using the mean doesn't work
//let mean = crabPositions.reduce(0, +) / crabPositions.count
//
//let fuelSpend = crabPositions.map { abs($0 - mean) }
//print(fuelSpend)
//let totalFuelSpend = fuelSpend.reduce(0, +)

// maybe the mode will?
//func mostFrequent(array: [Int]) -> (mostFrequent: [Int], count: Int)?
//{
//    var counts: [Int: Int] = [:]
//    // count all the occurrences of a value in the array and put is into counts, with a value: count. If it doesn't exist, initialise with 0 and add one, otherwise add one.
//    array.forEach { counts[$0] = (counts[$0] ?? 0) + 1 }
//    // find the max in the counts, if there is more than one value that has the same count, return a list of those values.
//    if let count = counts.max(by: { $0.value < $1.value })?.value {
//        // check each element in counts to see if it has the max count, if so, add the key, otherwise add nil, which will be removed by the compactMap.
//        return (counts.compactMap { $0.value == count ? $0.key : nil }, count)
//    }
//    return nil
//}
//
//let modes = mostFrequent(array: crabPositions)
//
//for mode in modes!.mostFrequent
//{
//    let fuelSpend = crabPositions.map { abs($0 - mode) }
//    let totalFuelSpend = fuelSpend.reduce(0, +)
//    print("Fuel spend for \(mode) is \(totalFuelSpend)")
//}
// nope!!

//brute force it is!

//: [Next](@next)
