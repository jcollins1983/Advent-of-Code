//: [Previous](@previous)

import Foundation

guard let fileUrl = Bundle.main.url(forResource: "P8", withExtension: ".txt") else { fatalError() }

let data = try String(contentsOf: fileUrl, encoding: String.Encoding.utf8).components(separatedBy: .newlines)

let displayData = data.map { (wirePattern: $0.components(separatedBy: " | ")[0], dispOutput: $0.components(separatedBy: " | ")[1] ) }

// part 1
func countUniques(dispOutput str: String) -> Int
{
    let uniques = [2, 3, 4, 7]
    let subStrings = str.split(separator: " ")
    let subStringCounts = subStrings.map { $0.count } // trying to map on the split resulted in an ambiguous use of split error, so had to move to a second line.
    var uniqueCounts = 0
    for count in subStringCounts
    {
        if uniques.contains(count)
        {
            uniqueCounts += 1
        }
    }
    
    return uniqueCounts
}

var uniquesCount = 0
for idx in 0..<displayData.count
{
    uniquesCount += countUniques(dispOutput: displayData[idx].dispOutput)
}

print(uniquesCount)
//: [Next](@next)
