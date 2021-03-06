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
    private var matchedArray = [[Bool]](repeating: [Bool](repeating: false, count: 5), count: 5)
    private var matchRowCounts:[Int:Int] = [0: 0, 1: 0, 2: 0, 3: 0, 4: 0]
    private var matchColCounts:[Int:Int] = [0: 0, 1: 0, 2: 0, 3: 0, 4: 0]
    var lastNum = 0
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
        // record the last number for use with calculating the puzzle solution
        lastNum = num
        for row in 0..<numRows
        {
            for col in 0..<numCols
            {
                if num == board[row][col]
                {
                    matchedArray[row][col] = true
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
    
    func getSum() -> Int
    {
        // add all numbers from board that were'nt called.
        var sum = 0
        for row in 0..<numRows
        {
            for col in 0..<numCols
            {
                if matchedArray[row][col] == false
                {
                    sum += board[row][col]
                }
            }
        }
        return sum
    }
}

// create the boards
var boards = [BingoBoard]()

for idx in 0..<boardData.count
{
    boards.append(BingoBoard(boardVal: boardData[idx]))
}

// part 1
// check the numbers in the boards. Stop on winner. Get sum.
for num in num_seq
{
    // need to do this because Swift won't let you mutate the thing after the for statement.
    var foundWinner = false
    for (idx, _) in boards.enumerated()
    {
        boards[idx].checkNum(num: num)
        if boards[idx].isWinner()
        {
            // we've found our winner, get the sum
            let sum = boards[idx].getSum()
            let lastNum = boards[idx].lastNum
            print("The sum of the winning board is: \(sum) and the winning number was \(lastNum)\tPuzzle Answer: \(sum * lastNum)")
            // don't need to keep going
            foundWinner = true
            break
        }
    }
    // we don't want to keep processing numbers
    if foundWinner
    {
        break
    }
}

// part 2
// need to reinit the boards from step 1, or comment out the part 1 block, otherwise this block will give rubbish answers...don't ask how lok it too me to work that out... :(
var lastWinnerIdx = 0
for num in num_seq
{
    for idx in 0..<boards.count
    {
        // if board is already a winner, we don't need to count it.
        if !boards[idx].isWinner()
        {
            boards[idx].checkNum(num: num)
            // see if the board is a winner now
            if boards[idx].isWinner()
            {
                lastWinnerIdx = idx
            }
        }
    }
}
let sum = boards[lastWinnerIdx].getSum()
let winningNumber = boards[lastWinnerIdx].lastNum
print("Last winner is at index: \(lastWinnerIdx)\tSum is: \(sum)\tWinning Number was: \(winningNumber)\tPuzzle solution: \(sum * winningNumber)")
//: [Next](@next)
