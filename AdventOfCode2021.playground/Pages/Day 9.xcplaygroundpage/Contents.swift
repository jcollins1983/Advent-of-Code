//: [Previous](@previous)

import Foundation

guard let fileUrl = Bundle.main.url(forResource: "P9", withExtension: ".txt") else { fatalError() }

let data = try String(contentsOf: fileUrl, encoding: String.Encoding.utf8).components(separatedBy: .newlines)
//print(data)

// have to cast the SubString (aka Character) to String before casting to Int, because Swift that's why!
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
    // Part 2 variable
    private var basinSizes = [Int]()
    
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
        // if we haven't run the findLowsIndexesAndValues method yet, let's do that
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
        // if we haven't run the findLowsIndexesAndValues method yet, let's do that
        if lowsValues.isEmpty
        {
            findLowsIndexesAndValues()
        }
        let risks = lowsValues.map { $0 + 1 }
        return risks.reduce(0, +)
    }
    
    // Part 2 additions
    mutating func getBasinSizes() -> [Int]
    {
        // if we haven't run findLowsIdexesAndValues before, let's do it now.
        if lowsIndexes.isEmpty
        {
            findLowsIndexesAndValues()
        }
        findBasinSizes()
        return basinSizes
    }
    
    private mutating func findBasinSizes()
    {
        for low in lowsIndexes
        {
            basinSizes.append(countBasin(idx: low))
        }
    }
    // using flood-fill / boundary fill https://www.freecodecamp.org/news/flood-fill-algorithm-explained/
    private mutating func countBasin(idx:(row:Int, col:Int)) -> Int
    {
        let countedVal = 10 // mark counted basin values with 10
        var count = 0
        let val = grid[idx.row][idx.col]
        // we're at a boundary or we've been counted before, return 0
        if val == 9 || val == countedVal
        {
            return 0
        }
        // we'll count it
        count += 1
        // and mark it
        grid[idx.row][idx.col] = countedVal
        
        // if we're in from the left boundary we can search left
        if idx.row > 0
        {
            count += countBasin(idx: (row: idx.row - 1, col: idx.col))
        }
        // if we're in from the right boundary we can search right
        if (idx.row < (rows - 1))
        {
            count += countBasin(idx: (row: idx.row + 1, col: idx.col))
        }
        // if we're in from the upper boundary we can search up
        if idx.col > 0
        {
            count += countBasin(idx: (row: idx.row, col: idx.col - 1))
        }
        // if we're in from the upper boundary we can search down
        if idx.col < (cols - 1)
        {
            count += countBasin(idx: (row: idx.row, col: idx.col + 1))
        }
        
        return count
    }
}

var myGrid = Grid(gridData: grid)
let risk = myGrid.getRisk()
print("Part 1: \(risk)")
// Part 2
let basinSizes = myGrid.getBasinSizes()
// sort the the basin sizes from largest to smallest, then take the first 3 elements and multiply them (note: you need to have an initial value with one for reduce when multiplying, otherwise you will always get 0... which took me longer than I care to admit to work out... :( )
print("\(basinSizes.sorted() { $0 > $1 }[0...2].reduce(1, { $0 * $1}))")

//print(basinSizes)
//: [Next](@next)
