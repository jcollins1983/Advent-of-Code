//: [Previous](@previous)

import Foundation

guard let fileUrl = Bundle.main.url(forResource: "P5", withExtension: ".txt") else { fatalError() }
// read the file: trying another method this time
let data = try String(contentsOf: fileUrl, encoding: String.Encoding.utf8).components(separatedBy: .newlines)

// read the lines from data, split on separator -> then split on , in each pair and map to Int followed by assignment to point in named tuple with x1, x2, y1, y2 names. There's probably a cleaner way to do this, but it works.
// split the data into point pairs
let linesRaw = data.map { $0.components(separatedBy: " -> ") }
// set up list of named tuples for the points and cast to int.
let lines = linesRaw.map { (x1: Int($0[0].split(separator: ",")[0]) ?? 0,
                            y1: Int($0[0].split(separator: ",")[1]) ?? 0,
                            x2: Int($0[1].split(separator: ",")[0]) ?? 0,
                            y2: Int($0[1].split(separator: ",")[1]) ?? 0) }

// get max x and y values for creating the grid to keep track of line intersections/overlaps.
let maxX  = lines.map { max($0.x1, $0.x2)}.max() ?? 1
let maxY  = lines.map { max($0.y1, $0.y2)}.max() ?? 1
// create empty grid maxX x maxY
print("Grid needs to be \(maxX) x \(maxY)")
var grid = [[Int]](repeating: [Int](repeating: 0, count: maxX + 2), count: maxY + 2)

// put the lines on the grid
// probably shouldn't be using swift keywords, but I read that if you do you should enclose it in back ticks
for `line` in lines
{
    print("Looking at line \(`line`)")
    // add one to the each point on the line
    if `line`.x1 == `line`.x2
    {
        // the line is vertical
        // don't know which point will be higher
        for py in min(`line`.y1, `line`.y2)...max(`line`.y1, `line`.y2)
        {
            print("Adding point: x: \(`line`.x1) y: \(py)")
            grid[`line`.x1][py] += 1
        }
    }
    else if `line`.y1 == `line`.y2
    {
        // the line is horizontal
        // don't know which point will be higher
        for px in min(`line`.x1, `line`.x2)...max(`line`.x1, `line`.x2)
        {
            print("Adding point: x: \(px) y: \(`line`.y1)")
            grid[px][`line`.y1] += 1
        }
    }
    else
    {
        // we're in a diagonal line.
        // Δx = Δy, however as x is increasing, y could be increasing or descreasing and vice versa
        // either need to go from min x and min y up to Δ or start at min x and max y
        let Δ = (x: `line`.x2 - `line`.x1, y: `line`.y2 - `line`.y1)
        
        for oset in 0...abs(Δ.x) // doesn't matter which element we use as they should be the same. but needs to be positive
        {
            switch Δ
            {
                case let (x, y) where x > 0 && y > 0:
                    // we're going positive in both directions, so start at x1, y1 and increment each until delta is reached.
                    grid[`line`.x1 + oset][`line`.y1 + oset] += 1
                case let (x, y) where x < 0 && y > 0:
                    // we're going negative in the x direction, so start at x2, y1 and increment each until delta is reached.
                    grid[`line`.x2 + oset][`line`.y1 + oset] += 1
                case let (x, y) where x < 0 && y < 0:
                    // we're going negative in both directions, so start at x2, y2 and increment each until delta is reached.
                    grid[`line`.x2 + oset][`line`.y2 + oset] += 1
                case let (x, y) where x > 0 && y < 0:
                    // we're going negative in the y direction, so start at x1, y2 and increment each until delta is reached.
                    grid[`line`.x1 + oset][`line`.y2 + oset] += 1
                default:
                    break // should never get here.
                    
            }
        }
    }
}
// count the points that were encountered more than once, flatten the grid first, then filter.
let flatGrid = grid.flatMap { $0 }
let countGreater2 = flatGrid.filter{ $0 >= 2 }
print("Number of points >2: \(countGreater2.count)")
////: [Next](@next)
