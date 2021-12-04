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
let binVals: [Int16] = lines.map{Int16($0, radix: 2)!}

// part 1
var gammaRate:UInt16 = 0
// find the most common in each bit position
func getCommons(arr: [Int16], bitpos: Int) -> (ones:Bool, zeros:Bool, equals:Bool)
{
    var retVal = (ones: false, zeros: false, equals: false)
    var ones_count = 0
    for itm in arr
    {
        if itm & (1 << bitpos) != 0
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
// want to keep part 1 and part 2 code independent but would refactor the above to accomodate this.
enum valTypes
{
    case ones, zeros
}
func bitIsSet(val:Int16, bitpos:Int) -> Bool
{
    return val & (1 << bitpos) != 0
}

func getIdx(arr:[Int16], valType:valTypes, bitpos:Int) -> [Int]
{
    var ones_idx = [Int]()
    var zeros_idx = [Int]()
    for (idx, itm) in arr.enumerated()
    {
        if bitIsSet(val: itm, bitpos: bitpos)
        {
            ones_idx.append(idx)
        }
        else
        {
            zeros_idx.append(idx)
        }
    }
    if valType == .ones
    {
        return ones_idx
    }
    else
    {
        return zeros_idx
    }
}
// get first lot of indexes, need to work left to right in this case
var ones_idx = getIdx(arr: binVals, valType: .ones, bitpos: 11)
var zeros_idx = getIdx(arr: binVals, valType: .zeros, bitpos: 11)

var oxVals = [Int16]()
//
for bitpos in 1..<binLength
{

    if ones_idx.count >= zeros_idx.count
    {
        // ones are the most (or equal), want to use them for the oxygen generator rating
        // take the index array and map to the binVals data for the first position only
        if bitpos == 1
        {
            oxVals = ones_idx.map {binVals[$0]}
        }
        else
        {
            oxVals = ones_idx.map{oxVals[$0]}
        }
    }
    else if ones_idx.count < zeros_idx.count
    {
        // zeros are the most, want to use them for the oxygen generator rating
        if bitpos == 1
        {
            oxVals = zeros_idx.map {binVals[$0]}
        }
        else
        {
            oxVals = zeros_idx.map {oxVals[$0]}
        }
    }
    ones_idx = getIdx(arr: oxVals, valType: .ones, bitpos: binLength - 1 - bitpos)
//    print("Ones Bitpos: \(bitpos): \(ones_idx)")
    zeros_idx = getIdx(arr: oxVals, valType: .zeros, bitpos: binLength - 1 - bitpos)
//    print("Zeros Bitpos: \(bitpos): \(zeros_idx)")
    if oxVals.count == 1
    {
        // we don't want to keep going
        break
    }
}
print(oxVals)
// some horrible copy and pasting here, but right now IDGAF.
// get first lot of indexes, need to work left to right in this case
ones_idx = getIdx(arr: binVals, valType: .ones, bitpos: 11)
zeros_idx = getIdx(arr: binVals, valType: .zeros, bitpos: 11)
var co2Vals = [Int16]()

for bitpos in 1..<binLength
{

    if ones_idx.count >= zeros_idx.count
    {
        // zeros are the least (or equal), want to use them for the CO2 scrubber rating
        // take the index array and map to the binVals data for the first position only
        if bitpos == 1
        {
            co2Vals = zeros_idx.map {binVals[$0]}
        }
        else
        {
            co2Vals = zeros_idx.map {co2Vals[$0]}
        }
    }
    else if ones_idx.count < zeros_idx.count
    {
        // ones are the least, want to use them for the CO2 Scrubber rating
        if bitpos == 1
        {
            co2Vals = ones_idx.map {binVals[$0]}
        }
        else
        {
            co2Vals = ones_idx.map {co2Vals[$0]}
        }
    }
    ones_idx = getIdx(arr: co2Vals, valType: .ones, bitpos: binLength - 1 - bitpos)
    zeros_idx = getIdx(arr: co2Vals, valType: .zeros, bitpos: binLength - 1 - bitpos)
    if co2Vals.count == 1
    {
        // we don't want to keep going
        break
    }
}
print(co2Vals)

// for the answer to the problem, take the output of the 2 print statements and multiply.
// this is a horrible hacky mess and I hate it, but it got me the right answer and it took more effort to get here than it was worth.
//: [Next](@next)
