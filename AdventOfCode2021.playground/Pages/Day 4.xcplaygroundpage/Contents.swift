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

print(boardData[0])
struct BingoBoard
{
    let rows = 5
    let cols = 5
    var board = [[Int]]()//(repeating: [0, 0, 0, 0, 0], count: 5)
    
    init(boardVal:[[ArraySlice<String>]])
    {
        // a list of strings is passed in, this is then assigned as necessary to each element.
        for board_row in boardVal
        {
            print(board_row)
        }
        
    }
    
    func check_num(num:Int)
    {
        for itm in board
        {
            print(itm)
        }
    }
}


var board = BingoBoard(boardVal: boardData[0])
//: [Next](@next)
