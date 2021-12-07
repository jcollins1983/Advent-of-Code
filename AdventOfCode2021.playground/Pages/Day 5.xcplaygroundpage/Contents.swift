//: [Previous](@previous)

import Foundation

guard let fileUrl = Bundle.main.url(forResource: "P5", withExtension: ".txt") else { fatalError() }
// read the file: trying another method this time
let data = try String(contentsOf: fileUrl, encoding: String.Encoding.utf8).components(separatedBy: .newlines)

// read the lines from data, split on separator -> then split on , in each pair and map to Int followed by assignment to NSPoint in named tuple with p1 and p2 names. There's probably a cleaner way to do this, but it works.
//let lines = data.map{ (p1:NSPoint(x:$0.components(separatedBy: " -> ")[0].split(separator: ",").map{Int($0)!}[0],
//                              y:$0.components(separatedBy: " -> ")[0].split(separator: ",").map{Int($0)!}[1]),
//                       p2:NSPoint(x:$0.components(separatedBy: " -> ")[1].split(separator: ",").map{Int($0)!}[0],
//                               y:$0.components(separatedBy: " -> ")[1].split(separator: ",").map{Int($0)!}[1]))}
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
}
// count the points that were encountered more than once, flatten the grid first, then filter.
let flatGrid = grid.flatMap { $0 }
let countGreater2 = flatGrid.filter{ $0 >= 2 }
print("Number of points >2: \(countGreater2.count)")
////: [Next](@next)
