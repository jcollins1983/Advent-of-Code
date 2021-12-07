//: [Previous](@previous)

import Foundation

guard let fileUrl = Bundle.main.url(forResource: "P5", withExtension: ".txt") else { fatalError() }
// read the file: trying another method this time
let data = try String(contentsOf: fileUrl, encoding: String.Encoding.utf8).components(separatedBy: .newlines)

// read the lines from data, split on separator -> then split on , in each pair and map to Int followed by assignment to NSPoint in named tuple with p1 and p2 names. There's probably a cleaner way to do this, but it works.
let lines = data.map{ (p1:NSPoint(x:$0.components(separatedBy: " -> ")[0].split(separator: ",").map{Int($0)!}[0],
                              y:$0.components(separatedBy: " -> ")[0].split(separator: ",").map{Int($0)!}[1]),
                       p2:NSPoint(x:$0.components(separatedBy: " -> ")[1].split(separator: ",").map{Int($0)!}[0],
                               y:$0.components(separatedBy: " -> ")[1].split(separator: ",").map{Int($0)!}[1]))}

// there has to be a better way to do this, but I'm still learning how these closures work, or maybe my chosen data structure was a poor choice. 🤷‍♂️
// get the max x & y values to be used on the grid
// the first bit here maps the largest x value from each set of points into one array, then call max on that array to get the largest x
// also need to cast from CGFloat to Int
let maxX = Int(lines.map { max($0.p1.x, $0.p1.x, $0.p2.x, $0.p2.x) }.max() ?? 0)
let maxY = Int(lines.map { max($0.p1.y, $0.p1.y, $0.p2.y, $0.p2.y) }.max() ?? 0)

var grid = [[Int]](repeating: [Int](repeating: 0, count: maxX), count: maxY)

// put lines on a grid, 1:1 mapping of array index to point (probs shouldn't be using swift keywords, but I read that if you do you should enclose them in back ticks.
for `line` in lines
{
    // outer loop
    for xVal in stride(from: `line`.p1.x, to: `line`.p2.x, by: 1)
    {
        // inner loop
        for yVal in stride(from: `line`.p1.y, to: `line`.p2.y, by: 1)
        {
            // add one to the point on the grid, need to cast to Int because the values take on the type of the strideable which in this case is CGFLoat because of the NSPoint object (as above, probably a poor choice in data structure.
            grid[Int(xVal)][Int(yVal)] += 1
        }
    }
}

// get the elements where the number is 2 or more
let flatGrid = grid.flatMap { $0 }
let countGreater2 = flatGrid.filter{ $0 >= 2 }
print("Number of points >2: \(countGreater2.count)")
//: [Next](@next)
