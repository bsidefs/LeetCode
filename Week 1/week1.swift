//
//  week1.swift
//  dsa
//
//  Created by Brian Tamsing on 12/15/21.
//

import Foundation

///
/// Week 1: Sequences
///

///
/// "two sum"
///
func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
    var table = [Int: Int]()
    for (index, num) in nums.enumerated() {
        if let indexOfComplement = table[target-num] {
            return [index, indexOfComplement]
        }
        table[num] = index
    }
    
    return []
}

///
/// "contains duplicate"
///
func containsDuplicate(_ nums: [Int]) -> Bool {
    var uniques = Set<Int>()
    for num in nums {
        if !uniques.insert(num).inserted {
            return true
        }
    }
    
    return false
}

///
/// "best time to buy and sell stock"
///
func maxProfit(_ prices: [Int]) -> Int {
    var maxProfit = 0, minPrice = Int.max
    
    for i in 0..<prices.count {
        if (prices[i] < minPrice) {
            minPrice = prices[i]
        }
        maxProfit = max(maxProfit, prices[i] - minPrice)
    }
    
    return maxProfit
}

///
/// "best time to buy and sell stock"
///
/// 2-ptr version
///
func maxProfit(_ prices: [Int]) -> Int {
    var maxProfit = 0
    var l = 0, r = 1
    
    while r < prices.count {
        if prices[l] < prices[r] {
            maxProfit = max(maxProfit, prices[r] - prices[l])
        } else {
            l = r
        }
        r += 1
    }
    
    return maxProfit
}

///
/// "valid anagram"
///
func isAnagram(_ s: String, _ t: String) -> Bool {
    var sMap = [Character: Int]()
    for char in s {
        if let count = sMap[char] {
            sMap.updateValue(count + 1, forKey: char)
        } else {
            sMap[char] = 1
        }
    }
    
    var tMap = [Character: Int]()
    for char in t {
        if let count = tMap[char] {
            tMap.updateValue(count + 1, forKey: char)
        } else {
            tMap[char] = 1
        }
    }
    
    return sMap == tMap
}

///
/// "valid parentheses"
///
func isValid(_ s: String) -> Bool {
    var stack = [Character]()
    var openParentheses: Set<Character> = ["(", "{", "["]
    var pairs: [Character: Character] = ["(": ")",
                                         "{": "}",
                                         "[": "]"]
    
    for char in s {
        if let openParenthesis = stack.last, char == pairs[openParenthesis] {
            stack.popLast()
        } else if openParentheses.contains(char) {
            stack.append(char)
        } else {
            return false
        }
    }
    
    return stack.isEmpty
}

///
/// "product of array except self"
///
func productExceptSelf(_ nums: [Int]) -> [Int] {
    var answer = [Int]()
    
    var leftProducts = Array(repeating: 1, count: nums.count), rightProducts = Array(repeating: 1, count: nums.count)
    var currentLeftProduct = 1
    for i in 0..<nums.count {
        if i == 0 {
            continue
        }
        
        currentLeftProduct *= nums[i-1]
        leftProducts[i] = currentLeftProduct
    }
    
    var currentRightProduct = 1
    for i in stride(from: nums.count-1, through: 0, by: -1) {
        if i == nums.count-1 {
            continue
        }
        
        currentRightProduct *= nums[i+1]
        rightProducts[i] = currentRightProduct
    }
    
    for i in 0..<nums.count {
        answer.append(leftProducts[i]*rightProducts[i])
    }
    
    return answer
}

///
/// "maximum subarray"
///
func maxSubArray(_ nums: [Int]) -> Int {
    var maxSum = Int.min, currentSum = 0
    
    for num in nums {
        currentSum += num
        
        if currentSum < num {
            currentSum = num
        }
        
        maxSum = max(maxSum, currentSum)
    }
    
    return maxSum
}

///
/// "3sum"
///
func threeSum(_ nums: [Int]) -> [[Int]] {
    guard !nums.isEmpty else { return [] }
    
    var solution = [[Int]]()
    
    var arr = nums
    arr.sort()
    
    for i in 0..<max(0, arr.count-2) {
        if i == 0 || i > 0 && arr[i] != arr[i-1] {
            var low = i + 1
            var high = arr.count - 1
            let sum = 0 - arr[i]
            
            while low < high {
                if arr[low] + arr[high] == sum {
                    solution.append([arr[i], arr[low], arr[high]])
                    
                    while low < high && arr[low] == arr[low+1] {
                        low += 1
                    }
                    
                    while low < high && arr[high] == arr[high-1] {
                        high -= 1
                    }
                    
                    low += 1
                    high -= 1
                } else if arr[low] + arr[high] > sum {
                    high -= 1
                } else {
                    low += 1
                }
            }
        }
    }
    
    return solution
}

///
/// "merge intervals"
///
func merge(_ intervals: [[Int]]) -> [[Int]] {
    guard intervals.count > 1 else {
        return intervals
    }
    
    var intervals = intervals
    intervals.sort(by: { arr1, arr2 in
        arr1.first! < arr2.first!
    })
    
    var solution = [[Int]]()
    var currentInterval = intervals[0]
    solution.append(currentInterval)
    
    var i = 0
    for interval in intervals {
        let currentStart = solution[i][0]
        let currentEnd = solution[i][1]
        
        let nextStart = interval.first!
        let nextEnd = interval.last!
        
        if currentEnd >= nextStart {
            solution[i][1] = max(currentEnd, nextEnd)
        } else {
            currentInterval = interval
            solution.append(currentInterval)
            i += 1
        }
    }
    
    return solution
}

///
/// "group anagrams"
///
func groupAnagrams(_ strs: [String]) -> [[String]] {
    var map = [[Int]: [String]]()
    
    for str in strs {
        var counts = Array(repeating: 0, count: 26)
        
        let charA: Character = "a"
        for char in str {
            if char.isASCII {
                let ithIndex = Int(char.asciiValue! - charA.asciiValue!)
                let currentCount = counts[ithIndex]
                counts[ithIndex] += 1
            }
        }
        
        if map[counts] != nil {
            map[counts]!.append(str)
        } else {
            map[counts] = [str]
        }
    }
    
    return Array(map.values)
}