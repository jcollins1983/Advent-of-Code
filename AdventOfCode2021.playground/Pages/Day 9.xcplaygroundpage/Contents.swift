//: [Previous](@previous)

import Foundation

guard let fileUrl = Bundle.main.url(forResource: "P9", withExtension: ".txt") else { fatalError() }

let data = try String(contentsOf: fileUrl, encoding: String.Encoding.utf8).components(separatedBy: .newlines)
//print(data)

let grid = data.map{ $0.map{ Int(String($0))! } }
//print(grid)

// Part 1 using this one as an exercise on structs, so probably doing a bunch of stuff that isn't necessary
struct Grid
{
    private var rows = 0
    private var cols = 0
    private var lowsCount = 0
    private var lowsIndexes = [(row:Int, col:Int)]()
    private var lowsValues = [Int]()
    private var grid = [[Int]]()
    
    init(gridData:[[Int]])
    {
        grid = gridData
        rows = gridData.count
        cols = gridData[0].count
    }
    
    func printSize()
    {
        print("Grid Size is \(rows) rows x \(cols) columns")
    }
    
    func getSize() -> (rows: Int, cols: Int)
    {
        return (rows: rows, cols: cols)
    }
    
    func getLowsCount() -> Int
    {
        return lowsCount
    }
    
    mutating func getLowsIndexes() -> [(row:Int, col:Int)]
    {
        if lowsIndexes.isEmpty
        {
            findLowsIndexesAndValues()
        }
        return lowsIndexes
    }
    
    mutating private func findLowsIndexesAndValues()
    {
        // start at the top left and iterate through each adjacent col & row
        for row in 0..<rows
        {
            for col in 0..<cols
            {
                if checkNeighboursHigher(row:row, col:col)
                {
                    // we've found a low point
                    lowsCount += 1
                    lowsIndexes.append((row:row, col:col))
                    lowsValues.append(grid[row][col])
                }
            }
        }
    }
    
    private func checkNeighboursHigher(row: Int, col: Int) -> Bool
    {
        func isRightHigher(currVal:Int) -> Bool
        {
            if row == (rows - 1)
            {
                // we're at the right most boundary, return true
                return true
            }
            else
            {
                return grid[row + 1][col] > currVal
            }
        }
        
        func isLeftHigher(currVal:Int) -> Bool
        {
            if row == 0
            {
                // we're at the left most boundary, return true
                return true
            }
            else
            {
                return grid[row - 1][col] > currVal
            }
        }
        
        func isAboveHigher(currVal:Int) -> Bool
        {
            if col == 0
            {
                // we're at the top most boundary, return true
                return true
            }
            else
            {
                return grid[row][col - 1] > currVal
            }
        }
        
        func isBelowHigher(currVal:Int) -> Bool
        {
            if col == (cols - 1)
            {
                // we're at the bottom most boundary, return true
                return true
            }
            else
            {
                return grid[row][col + 1] > currVal
            }
        }
        let currentVal = grid[row][col]
        
        return isAboveHigher(currVal: currentVal) && isBelowHigher(currVal: currentVal) && isRightHigher(currVal: currentVal) && isLeftHigher(currVal: currentVal)
    }
    
    mutating func getRisk() -> Int
    {
        if lowsValues.isEmpty
        {
            // we haven't run findLowsIndexesAndValues
            findLowsIndexesAndValues()
        }
        let risks = lowsValues.map { $0 + 1 }
        return risks.reduce(0, +)
    }
    
}

var myGrid = Grid(gridData: grid)
let risk = myGrid.getRisk()
print("Part 1: \(risk)")
//: [Next](@next)
