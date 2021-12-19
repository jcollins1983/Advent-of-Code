//: [Previous](@previous)

import Foundation

guard let fileUrl = Bundle.main.url(forResource: "P10", withExtension: ".txt") else { fatalError() }

let data = try String(contentsOf: fileUrl, encoding: String.Encoding.utf8).components(separatedBy: .newlines)
//print(data)

// common code
struct Syntax
{
    let openChars:[Character] = ["(", "{", "[", "<"]
    let closeChars:[Character] = [")", "}", "]", ">"]
    // map open with closed and closed with open to map both ways
    let charPairsMap:[Character:Character] = ["(": ")", "{": "}", "<": ">", ")": "(", "}": "{", "]": "[", ">": "<"]
    let errorPointMap:[Character:Int] = [")": 3, "]": 57, "}": 1197, ">": 25137]
}

// common code
func checkSyntax(line ln:String) -> (syntaxOk: Bool, idxOfError: Int?, errorChar: Character?)
{
    // start out with true, and change if error is found, and idxOfError starts as nil
    var syntaxResult = true
    var idxOfError:Int? = nil
    var openChars = [Character]()
    var errorChar:Character? = nil
    
    for (idx, char) in ln.enumerated()
    {
        switch idx
        {
            case 0:
                // the char MUST be an open char
                if Syntax().openChars.contains(char)
                {
                    openChars.append(char)
                }
                else
                {
                    syntaxResult = false
                    idxOfError = idx
                    errorChar = char
                    return (syntaxResult, idxOfError, errorChar)
                }
            case 1...:
                if Syntax().openChars.contains(char)
                {
                    // it's an opening char, add it to the array
                    openChars.append(char)
                }
                else if Syntax().closeChars.contains(char)
                {
                    // it's a closing char
                    // check if it matches with the last appened open char
                    if !openChars.isEmpty && (Syntax().charPairsMap[char] == openChars.last)
                    {
                        // match OK, pop the last value off the openChars list.
                        openChars.popLast()
                    }
                    else
                    {
                        // we either got an extra closing char, or it was wrong.
                        syntaxResult = false
                        idxOfError = idx
                        errorChar = char
                        return (syntaxResult, idxOfError, errorChar)
                    }
                }
            default:
                print("Something went wrong")
                break
        }
    }
    
    return (syntaxOk: syntaxResult, idxOfError: idxOfError, errorChar: errorChar)
}

// Part 1
var errorPoints = 0
for line in data
{
    let check = checkSyntax(line: line)
    if check.syntaxOk == false
    {
        // we found a problem, add the error value
        errorPoints += Syntax().errorPointMap[check.errorChar!]!
    }
}
print("Part 1: Error value = \(errorPoints)")

//: [Next](@next)
