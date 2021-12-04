//: [Previous](@previous)

import Foundation

let file = "P3.txt"

// get file handle
guard let fileUrl = Bundle.main.url(forResource: "P3", withExtension: ".txt") else { fatalError() }
// read the file: trying another method this time
let lines = try String(contentsOf: fileUrl, encoding: String.Encoding.utf8).components(separatedBy: .newlines)
// get the length of the binary data (assume uniform length for the data set)
let binLength = lines[0].count
let dataSetLength = lines.count
// convert to BinaryInteger type
let binVals = lines.map{Int16($0, radix: 2)}

// part 1
var gammaRate:UInt16 = 0
// find the most common in each bit position
func getCommons(arr: [Int16?], bitpos: Int) -> (ones:Bool, zeros:Bool, equals:Bool)
{
    var retVal = (ones: false, zeros: false, equals: false)
    var ones_count = 0
    for itm in arr
    {
        if itm! & (1 << bitpos) != 0
        {
            ones_count += 1
        }
    }
    // check what's most common
    switch ones_count
    {
        case arr.count / 2:
            // it's equal
            retVal.equals = true
        case 0..<(arr.count / 2):
            // zeros are most common
            retVal.zeros = true
        case (arr.count / 2)+1...arr.count:
            // ones are most common
            retVal.ones = true
        default:
            // should never get here
            break
        
    }
    return retVal
}
for bitpos in 0..<binLength
{
    if getCommons(arr: binVals, bitpos: bitpos).ones
    {
        gammaRate += (1 << bitpos)
    }
    // we don't need to do anything else as the 0 positions will be skipped
}
print("Gamma Bin: \(String(gammaRate, radix: 2))\tDec: \(gammaRate)")
// the epsiolon rate is just the complement of the gamma rate, need to mask the bits from position 12 - 15
let epsilonRate = ~gammaRate & 0b0000111111111111
print("Epsilon Bin: \(String(epsilonRate, radix: 2))\tDec: \(epsilonRate)")
let power = Int32(epsilonRate) * Int32(gammaRate)
print("Power: \(power)")

// part 2


//: [Next](@next)
