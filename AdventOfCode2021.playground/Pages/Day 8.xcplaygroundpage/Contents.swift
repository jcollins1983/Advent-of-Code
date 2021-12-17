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

print("Part 1: \(uniquesCount)")

// part 2
func decodeDisplay(wirePattern str: String, displayData disp:String) -> Int
{
    var decodeMap = [String:Int]()
    var tempDict = [Int:String]()
    let patternSubStrings = str.split(separator: " ")
    var length5SubStrings = [String]()
    var length6SubStrings = [String]()
    for subString in patternSubStrings
    {
        // we already know which elements are 1, 4, 7 & 8
        switch subString.count
        {
            case 2:
                // we have a 1
                tempDict[1] = String(subString)
                decodeMap[String(subString.sorted())] = 1
            case 3:
                // we have a 7
                tempDict[7] = String(subString)
                decodeMap[String(subString.sorted())] = 7
            case 4:
                // we have a 4
                tempDict[4] = String(subString)
                decodeMap[String(subString.sorted())] = 4
            case 7:
                // we have an 8
                tempDict[8] = String(subString)
                decodeMap[String(subString.sorted())] = 8
            case 5:
                // it could be a 2, 3, or 5, we need to parse all strings before determining, so need to store for later.
                length5SubStrings.append(String(subString))
            case 6:
                // it could be a 6, 9, or 0, we need to parse all strings before determining, so need to store for later.
                length6SubStrings.append(String(subString))
            default:
                break
        }
    }
    
    // find the 6, 9 & 0
    for subStr in length6SubStrings
    {
        if Set(subStr).union(Set(tempDict[4]!)) == Set(subStr)
        {
            // this is a 9
            decodeMap[String(subStr.sorted())] = 9
            // add to tempDict for use in working out the length 5 codes.
            tempDict[9] = subStr
        }
        else if Set(subStr).union(Set(tempDict[1]!)) == Set(subStr)
        {
            // it's a 0
            decodeMap[String(subStr.sorted())] = 0
            // add to tempDict for use in working out the length 5 codes.
            tempDict[0] = subStr
        }
        else
        {
            // it's a 6
            decodeMap[String(subStr.sorted())] = 6
            // add to tempDict for use in working out the length 5 codes.
            tempDict[6] = subStr
        }
    }
    
    // find the 2, 3 & 5
    for subStr in length5SubStrings
    {
        if Set(subStr).union(tempDict[1]!) == Set(subStr)
        {
            // we have a 3
            decodeMap[String(subStr.sorted())] = 3
        }
        // create union with 1, if it looks like a 9, it's a 5
        else if Set(subStr).union(tempDict[9]!) == Set(subStr).union(tempDict[1]!)
        {
            // we have a 5
            decodeMap[String(subStr.sorted())] = 5
        }
        else
        {
            // we have a 2
            decodeMap[String(subStr.sorted())] = 2
        }
    }
    
    // work out the displa value
    let dispSubStrings = disp.split(separator: " ")
    var val = 0
    val += decodeMap[String(dispSubStrings[0].sorted())]! * 1000
    val += decodeMap[String(dispSubStrings[1].sorted())]! * 100
    val += decodeMap[String(dispSubStrings[2].sorted())]! * 10
    val += decodeMap[String(dispSubStrings[3].sorted())]!
    return val
}

let dispValSum = displayData.map{ decodeDisplay(wirePattern: $0.wirePattern, displayData: $0.dispOutput) }.reduce(0, +)
print("Part 2: \(dispValSum)")
//: [Next](@next)
