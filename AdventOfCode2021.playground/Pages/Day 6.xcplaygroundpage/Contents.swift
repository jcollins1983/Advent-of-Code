//: [Previous](@previous)

import Foundation

guard let fileUrl = Bundle.main.url(forResource: "P6", withExtension: ".txt") else { fatalError() }

var data = try String(contentsOf: fileUrl, encoding: String.Encoding.utf8).split(separator: ",").map{Int($0)!}

let numDays = 80
var dayCount = 0

while dayCount < numDays
{
    if dayCount > 0
    {
        // get the 0s
        let zeros = data.filter( { $0 == 0 })
        // add that many 8s to the array
        let fishToAdd = [Int](repeating: 8, count: zeros.count)
        // get the non-zeros and subtract 1
        let nonZeroSubtracted = data.filter{ $0 > 0 }.map{ $0 - 1 }
        // add the subtracted non-zeros, the added and the zeros + 6
        data = nonZeroSubtracted + zeros.map { $0 + 6 } + fishToAdd
    }
    else
    {
        // subtract 1 from all elements, only want to do this on the first day
        data = data.map{ $0 - 1 }
    }
    dayCount += 1
}
print("Number of fish after 80 days: \(data.count)")

//: [Next](@next)
