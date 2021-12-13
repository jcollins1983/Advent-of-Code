//: [Previous](@previous)

import Foundation

guard let fileUrl = Bundle.main.url(forResource: "P6", withExtension: ".txt") else { fatalError() }

var data = try String(contentsOf: fileUrl, encoding: String.Encoding.utf8).split(separator: ",").map{Int($0)!}

let numDays = 80
var dayCount = 0

// part 1
//while dayCount < numDays
//{
//    if dayCount > 0
//    {
//        // get the 0s
//        let zeros = data.filter( { $0 == 0 })
//        // add that many 8s to the array
//        let fishToAdd = [Int](repeating: 8, count: zeros.count)
//        // get the non-zeros and subtract 1
//        let nonZeroSubtracted = data.filter{ $0 > 0 }.map{ $0 - 1 }
//        // add the subtracted non-zeros, the added and the zeros + 6
//        data = nonZeroSubtracted + zeros.map { $0 + 6 } + fishToAdd
//    }
//    else
//    {
//        // subtract 1 from all elements, only want to do this on the first day
//        data = data.map{ $0 - 1 }
//    }
//    dayCount += 1
//}
//print("Number of fish after 80 days: \(data.count)")

// part 2
// count how many of each number of fish there are.
var fishCounts: [Int] = []
// there shouldn't be any fish at 0 or above 6 initially, but we'll look anyway
for num in 0...8
{
    fishCounts.append(data.filter{ $0 == num }.count)
}
print(fishCounts)
for _ in 1...256
{
    // get the number of new fish (e.g fish that were moved to 0 on the last round)
    let newFishCount = fishCounts[0]
    for num in 0...8
    {
        switch num
        {
            case 0...5, 7:
                // "decrement" the fish by moving from the next highest index to the current index
                fishCounts[num] = fishCounts[num + 1]
            case 6:
                // "decrement" the fish by moving from the next highest index to the current index
                fishCounts[num] = fishCounts[num + 1]
                // add the 0s aka newFishCount into the 6 column
                fishCounts[num] += newFishCount
            case 8:
                fishCounts[num] = newFishCount
            default:
                print("Whoops, something went wrong!")
        }
    }
    print(fishCounts)
    
}
print("The number of fish is: \(fishCounts.reduce(0, +))")
//: [Next](@next)
