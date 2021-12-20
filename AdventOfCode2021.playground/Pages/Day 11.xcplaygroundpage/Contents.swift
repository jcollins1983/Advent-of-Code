//: [Previous](@previous)

import Foundation
import CoreGraphics

guard let fileUrl = Bundle.main.url(forResource: "P11", withExtension: ".txt") else { fatalError() }

let data = try String(contentsOf: fileUrl, encoding: String.Encoding.utf8).components(separatedBy: .newlines)

let grid = data.map{ $0.map{ Int(String($0))! } }

struct Grid
{
    private var grid:[[Int]]
    private let rows:Int
    private let cols:Int
    private var numFlashes:Int = 0
    
    init(gridData:[[Int]])
    {
        grid = gridData
        rows = gridData.count
        cols = gridData[0].count
    }
    subscript(x: Int, y: Int) -> Int
    {
        get
        {
            return grid[y][x]
        }
    }
    
    func printGrid()
    {
        print("* * * * * * * * * *")
        for row in grid
        {
            print(row)
        }
        print("* * * * * * * * * *")
    }
    
    private mutating func incrementGrid()
    {
        // increment all elements - grid is 2d so need to do 2 levels of map
        grid = grid.map { $0.map { $0 + 1 } }
    }
    
    private mutating func incrementElement(row: Int, col:Int)
    {
        // increment an element only if it is not 0
        if grid[row][col] == 0
        {
            return
        }
        else
        {
            grid[row][col] += 1
        }
    }
    
    private mutating func doFlash(idx: (row: Int, col: Int))
    {
        // if we've already flashed, we don't want to flash again OR if we're not at a flash level
        if grid[idx.row][idx.col] == 0 || grid[idx.row][idx.col] <= 9
        {
            return
        }
        // count the flash, then set the value to 0
        numFlashes += 1
        grid[idx.row][idx.col] = 0
        
        // if we're on a boundary we can't increment in all directions, then process any flashes.
        switch idx
        {
            case (0, 0):
                // we're on the upper left boundary, increment right, down and down/right
                incrementElement(row: idx.row, col: idx.col + 1)  // right
                incrementElement(row: idx.row + 1, col: idx.col + 1) // down/right
                incrementElement(row: idx.row + 1, col: idx.col) // down
                doFlash(idx: (idx.row, idx.col + 1))
                doFlash(idx: (idx.row + 1, idx.col + 1))
                doFlash(idx: (idx.row + 1, idx.col + 1))
            case (0, cols - 1):
                // we're on the upper right boundary, increment left, down and down/left
                incrementElement(row: idx.row, col: idx.col - 1) // left
                incrementElement(row: idx.row + 1, col: idx.col - 1) // down/left
                incrementElement(row: idx.row + 1, col: idx.col) // down
                doFlash(idx: (idx.row, idx.col - 1))
                doFlash(idx: (idx.row + 1, idx.col - 1))
                doFlash(idx: (idx.row + 1, idx.col))
            case (rows - 1, 0):
                // we're on the lower left boundary, increment right, up and up/right
                incrementElement(row: idx.row, col: idx.col + 1) // right
                incrementElement(row: idx.row - 1, col: idx.col + 1) // up/right
                incrementElement(row: idx.row - 1, col: idx.col) // up
                doFlash(idx: (idx.row, idx.col + 1))
                doFlash(idx: (idx.row - 1, idx.col + 1))
                doFlash(idx: (idx.row - 1, idx.col))
            case (rows - 1, cols - 1):
                // we're on the lower right boundary, increment left, up and up/left
                incrementElement(row: idx.row, col: idx.col - 1) // left
                incrementElement(row: idx.row - 1, col: idx.col - 1) // up/left
                incrementElement(row: idx.row - 1, col: idx.col) // up
                doFlash(idx: (idx.row, idx.col - 1))
                doFlash(idx: (idx.row - 1, idx.col - 1))
                doFlash(idx: (idx.row - 1, idx.col))
            case let (row, col) where row == 0 && col > 0 && col < (cols - 1):
                // we're on the top row between the corners, we can go left, right, down, down/right, down/left
                incrementElement(row: idx.row, col: idx.col - 1) // left
                incrementElement(row: idx.row, col: idx.col + 1) // right
                incrementElement(row: idx.row + 1, col: idx.col) // down
                incrementElement(row: idx.row + 1, col: idx.col + 1) // down/right
                incrementElement(row: idx.row + 1, col: idx.col - 1) // down/left
                doFlash(idx: (idx.row, idx.col - 1))
                doFlash(idx: (idx.row, idx.col + 1))
                doFlash(idx: (idx.row + 1, idx.col))
                doFlash(idx: (idx.row + 1, idx.col + 1))
                doFlash(idx: (idx.row + 1, idx.col - 1))
            case let (row, col) where col == (cols - 1) && row > 0 && row < (rows - 1):
                // we're on the right column between the corners, we can go left, up, down, up/left, down/left
                incrementElement(row: idx.row, col: idx.col - 1) // left
                incrementElement(row: idx.row - 1, col: idx.col) // up
                incrementElement(row: idx.row + 1, col: idx.col) // down
                incrementElement(row: idx.row + 1, col: idx.col - 1) // down/left
                incrementElement(row: idx.row - 1, col: idx.col - 1) // up/left
                doFlash(idx: (idx.row, idx.col - 1))
                doFlash(idx: (idx.row - 1, idx.col))
                doFlash(idx: (idx.row + 1, idx.col))
                doFlash(idx: (idx.row + 1, idx.col - 1))
                doFlash(idx: (idx.row - 1, idx.col - 1))
            case let (row, col) where row == (rows - 1) && col > 0 && col < (cols - 1):
                // we're on the bottom row between the corners, we can go left, right, up, up/right, up/left
                incrementElement(row: idx.row, col: idx.col - 1) // left
                incrementElement(row: idx.row, col: idx.col + 1) // right
                incrementElement(row: idx.row - 1, col: idx.col) // up
                incrementElement(row: idx.row - 1, col: idx.col + 1) // up/right
                incrementElement(row: idx.row - 1, col: idx.col - 1) // up/left
                doFlash(idx: (idx.row, idx.col - 1))
                doFlash(idx: (idx.row, idx.col + 1))
                doFlash(idx: (idx.row - 1, idx.col))
                doFlash(idx: (idx.row - 1, idx.col + 1))
                doFlash(idx: (idx.row - 1, idx.col - 1))
            case let (row, col) where col == 0 && row > 0 && row < (rows - 1):
                // we're on the left column between the corners, we can go up, right, down, up/right, down/right
                incrementElement(row: idx.row - 1, col: idx.col) // up
                incrementElement(row: idx.row, col: idx.col + 1) // right
                incrementElement(row: idx.row + 1, col: idx.col) // down
                incrementElement(row: idx.row - 1, col: idx.col + 1) // up/right
                incrementElement(row: idx.row + 1, col: idx.col + 1) // down/right
                doFlash(idx: (idx.row - 1, idx.col))
                doFlash(idx: (idx.row, idx.col + 1))
                doFlash(idx: (idx.row + 1, idx.col))
                doFlash(idx: (idx.row - 1, idx.col + 1))
                doFlash(idx: (idx.row + 1, idx.col + 1))
            case let (row, col) where row > 0 && row < (rows - 1) && col > 0 && col < (cols - 1):
                // in the middle somewhere, increment in all directions
                incrementElement(row: idx.row - 1, col: idx.col) // up
                incrementElement(row: idx.row - 1, col: idx.col + 1) // up/right
                incrementElement(row: idx.row - 1, col: idx.col - 1) // up/left
                incrementElement(row: idx.row + 1, col: idx.col) // down
                incrementElement(row: idx.row + 1, col: idx.col + 1) // down/right
                incrementElement(row: idx.row + 1, col: idx.col - 1) // down/left
                incrementElement(row: idx.row, col: idx.col + 1) // right
                incrementElement(row: idx.row, col: idx.col - 1) // left
                doFlash(idx: (idx.row - 1, idx.col))
                doFlash(idx: (idx.row - 1, idx.col + 1))
                doFlash(idx: (idx.row - 1, idx.col - 1))
                doFlash(idx: (idx.row + 1, idx.col))
                doFlash(idx: (idx.row + 1, idx.col + 1))
                doFlash(idx: (idx.row + 1, idx.col - 1))
                doFlash(idx: (idx.row, idx.col + 1))
                doFlash(idx: (idx.row, idx.col - 1))
            default:
                print("Something went wrong! \(idx)")
                break
        }
    }
    
    func getFlashes() -> Int
    {
        return numFlashes
    }
    
    mutating func runStep()
    {
        incrementGrid()
        for row in 0..<rows
        {
            for col in 0..<cols
            {
                doFlash(idx: (row, col))
            }
        }
    }
}

var myGrid = Grid(gridData: grid)
for _ in 0..<100
{
    myGrid.runStep()
}
print("Part 1: number of flashes was \(myGrid.getFlashes())")
//: [Next](@next)
