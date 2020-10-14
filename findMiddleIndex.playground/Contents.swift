import UIKit

func findMiddleIndex(data: [Int]) {
    if data.count > 2 {
        for index in 1..<data.count where index + 1 != data.count {
            let leftSum = data[0..<index].reduce(0, +)
            let rightSum = data[index + 1..<data.count].reduce(0, +)
            if leftSum == rightSum {
                print("middle index is \(index)")
                return
            }
        }
    }
    
    print("index not found")
}

findMiddleIndex(data: [1, 3, 5, 7, 9])
findMiddleIndex(data: [3, 6, 8, 1, 5, 10, 1, 7])
findMiddleIndex(data: [3, 5, 6])
findMiddleIndex(data: [3, 10, 3])
findMiddleIndex(data: [0, 5, 0])
findMiddleIndex(data: [1, 0, 1, 1])
