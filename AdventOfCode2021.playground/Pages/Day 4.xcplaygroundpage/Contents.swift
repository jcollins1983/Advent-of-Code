//: [Previous](@previous)

import Foundation

// get file handle
guard let fileUrl = Bundle.main.url(forResource: "P4", withExtension: ".txt") else { fatalError() }
// read the file: trying another method this time
let data = try String(contentsOf: fileUrl, encoding: String.Encoding.utf8).components(separatedBy: .newlines)

// get the number sequence from the first line and map to Int
let num_seq = data[0].split(separator: ",").map{Int($0)!}

// get the board data from rest of the file, the below results in each element being an array containing the 5 rows.
let boardData = data[1...].split(separator: "")

struct BingoBoard
{
    let numRows = 5
    let numCols = 5
    var board = [[Int]]()
    private var matched = [[Bool]](repeating: [Bool](repeating: false, count: 5), count: 5)
    private var matchRowCounts:[Int:Int] = [0: 0, 1: 0, 2: 0, 3: 0, 4: 0]
    private var matchColCounts:[Int:Int] = [0: 0, 1: 0, 2: 0, 3: 0, 4: 0]
    var winner: Bool = false
    
    init(boardVal:ArraySlice<String>)
    {
        // a list of strings is passed in, this is then assigned as necessary to each element.
        for vals in boardVal
        {
            // read the line into board array, split by whitespace and filter out the empty strings from the single digit numbers
            board.append(vals.components(separatedBy: .whitespaces).filter{$0 != ""}.map{Int($0)!})
        }
        
    }
    
    mutating func checkNum(num:Int)
    {
        // check to see if the number is on this board.
        for row in 0..<numRows
        {
            for col in 0..<numCols
            {
                if num == board[row][col]
                {
                    matched[row][col] = true
                    matchColCounts[col]! += 1
                    matchRowCounts[row]! += 1
                }
            }
        }
    }
    
    private mutating func checkMatchedCounts()
    {
        for key in 0..<numRows
        {
            if matchRowCounts[key] == numRows
            {
                winner = true
            }
        }
        for key in 0..<numCols
        {
            if matchColCounts[key] == numCols
            {
                winner = true
            }
        }
    }
    
    mutating func isWinner() -> Bool
    {
        // check the match counts
        checkMatchedCounts()
        return winner
    }
}

// create the boards
var board = BingoBoard(boardVal: boardData[0])

// check the numbers in the boards. Stop on winner. Get sum.
board.checkNum(num: 5)
board.checkNum(num: 31)
board.checkNum(num: 70)
board.checkNum(num: 8)
board.checkNum(num: 88)
board.isWinner()
//: [Next](@next)
