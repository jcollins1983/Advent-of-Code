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
    
    private mutating func incrementNeighbours(idx: (row: Int, col: Int))
    {
        // if we're on a boundary we can't increment in all directions
        // note, this is Xcodes formatting and it looks like balls!
        switch idx
        {
            case (0, 0):
                // we're on the upper left boundary, increment right, down and down/right
                grid[idx.row][idx.col + 1] += 1  // right
                grid[idx.row + 1][idx.col + 1] += 1 // down/right
                grid[idx.row + 1][idx.col] += 1 // down
            case (0, cols - 1):
                // we're on the upper right boundary, increment left, down and down/left
                grid[idx.row][idx.col - 1] += 1 // left
                grid[idx.row + 1][idx.col - 1] += 1 // down/left
                grid[idx.row + 1][idx.col] += 1 // down
            case (rows - 1, 0):
                // we're on the lower left boundary, increment right, up and up/right
                grid[idx.row][idx.col + 1] += 1 // right
                grid[idx.row - 1][idx.col + 1] += 1 // up/right
                grid[idx.row - 1][idx.col] += 1 // up
            case (rows - 1, cols - 1):
                // we're on the lower right boundary, increment left, up and up/left
                grid[idx.row][idx.col - 1] += 1 // left
                grid[idx.row - 1][idx.col - 1] += 1 // up/left
                grid[idx.row - 1][idx.col] += 1 // up
            case let (row, col) where row == 0 && col > 0 && col < (cols - 2):
                // we're on the top row between the corners, we can go left, right, down, down/right, down/left
                grid[idx.row][idx.col - 1] += 1 // left
                grid[idx.row][idx.col + 1] += 1 // right
                grid[idx.row + 1][idx.col] += 1 // down
                grid[idx.row + 1][idx.col + 1] += 1 // down/right
                grid[idx.row + 1][idx.col - 1] += 1 // down/left
            case let (row, col) where col == (cols - 1) && row > 0 && row < (rows - 2):
                // we're on the right column between the corners, we can go left, up, down, up/left, down/left
                grid[idx.row][idx.col - 1] += 1 // left
                grid[idx.row - 1][idx.col] += 1 // up
                grid[idx.row + 1][idx.col] += 1 // down
                grid[idx.row + 1][idx.col - 1] += 1 // down/left
                grid[idx.row - 1][idx.col - 1] += 1 // up/left
            case let (row, col) where row == (rows - 1) && col > 0 && col < (cols - 2):
                // we're on the bottom row between the corners, we can go left, right, up, up/right, up/left
                grid[idx.row][idx.col - 1] += 1 // left
                grid[idx.row][idx.col + 1] += 1 // right
                grid[idx.row - 1][idx.col] += 1 // up
                grid[idx.row - 1][idx.col + 1] += 1 // up/right
                grid[idx.row - 1][idx.col - 1] += 1 // up/left
            case let (row, col) where col == 0 && row > 0 && row < (rows - 2):
                // we're on the left column between the corners, we can go up, right, down, up/right, down/right
                grid[idx.row - 1][idx.col] += 1 // up
                grid[idx.row][idx.col + 1] += 1 // right
                grid[idx.row + 1][idx.col] += 1 // down
                grid[idx.row - 1][idx.col + 1] += 1 // up/right
                grid[idx.row + 1][idx.col + 1] += 1 // down/right
            case let (row, col) where row > 0 && row < (rows - 1) && col > 0 && col < (cols - 1):
                // in the middle somewhere, increment in all directions
                grid[idx.row - 1][idx.col] += 1 // up
                grid[idx.row - 1][idx.col + 1] += 1 // up/right
                grid[idx.row - 1][idx.col - 1] += 1 // up/left
                grid[idx.row + 1][idx.col] += 1 // down
                grid[idx.row + 1][idx.col + 1] += 1 // down/right
                grid[idx.row + 1][idx.col - 1] += 1 // down/left
                grid[idx.row][idx.col + 1] += 1 // right
                grid[idx.row][idx.col - 1] += 1 // left
            default:
                print("Something went wrong!")
                break
        }
    }
    
    private mutating func doFlash()
    {
        // starting at the top left, check the value and process the flash if necessary
//        for row in 0..<rows
//        {
//
//        }
        // count the flash
        numFlashes += 1
        // set back to 0
//        grid[idx.row][idx.col] = 0
        
    }
    
    mutating func runStep()
    {
        incrementGrid()
        self.printGrid()
        incrementNeighbours(idx: (4, 5))
        self.printGrid()
    }
}

var myGrid = Grid(gridData: grid)
myGrid.printGrid()
myGrid.runStep()
//: [Next](@next)
