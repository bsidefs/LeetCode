//
//  week2.swift
//  dsa
//
//  Created by Brian Tamsing on 12/24/21.
//

import Foundation

///
/// Week 2: Data Structures
/// (i.e., linked-lists, matrices, arrays/strings...)
///

///
/// "reverse a linked list"
///
/// iterative
///
func reverseList(_ head: ListNode?) -> ListNode? {
    var node = head
    var prev: ListNode?
    
    var newHead = head
    while let currentNode = node {
        node = currentNode.next
        
        swap(&currentNode.next, &prev)
        prev = currentNode
        
        newHead = currentNode
    }
    
    return newHead
}

///
/// "reverse a linked list"
///
/// recursive
///
func reverseList(_ head: ListNode?) -> ListNode? {
    guard let head = head else { return nil }
    
    var newHead: ListNode? = head
    if head.next != nil {
        newHead = reverseList(head.next)
        head.next?.next = head
    }
    
    head.next = nil
    
    return newHead
}

///
/// "detect cycle in a linked list"
///
func hasCycle(_ head: ListNode?) -> Bool {
    var s = head, f = head
    
    while f != nil && f?.next != nil { 
        s = s?.next
        f = f!.next!.next
        
        if s === f {
            return true
        }
    }
    
    return false
}

///
/// "container with most water"
///
func maxArea(_ height: [Int]) -> Int {
    var maxArea = 0
    var l = 0, r = height.count - 1
    
    while l < r {
        let currentArea = (r - l) * min(height[l], height[r])
        maxArea = max(maxArea, currentArea)
        
        if height[l] < height[r] {
            l += 1
        } else {
            r -= 1
        }
    }
    
    return maxArea
}

///
/// "find minimum in rotated sorted array"
///
func findMin(_ nums: [Int]) -> Int {
    var minimum = nums[0]
    var low = 0, high = nums.count - 1
    
    while low <= high {
        if nums[low] < nums[high] {
            minimum = min(minimum, nums[low])
            break
        }
        
        let midpoint = (low + high) / 2
        minimum = min(minimum, nums[midpoint])
        
        if nums[midpoint] >= nums[low] {
            low = midpoint + 1
        } else {
            high = midpoint - 1
        }
    }
    
    return minimum
}

///
/// "longest substring without repeating characters"
///
func lengthOfLongestSubstring(_ s: String) -> Int {
    var len = 0
    var l = 0
    
    var charSet = Set<Character>()
    for (r, char) in s.enumerated() {
        while charSet.contains(char) {
            charSet.remove(s[s.index(s.startIndex, offsetBy: l)])
            l += 1
        }
        
        charSet.insert(char)
        len = max(len, r - l + 1)
    }
    
    return len
}

///
/// "number of islands"
///
func numIslands(_ grid: [[Character]]) -> Int {
    var numIslands = 0
    var grid = grid
    
    for i in 0..<grid.count {
        for j in 0..<grid[i].count {
            if grid[i][j] == "1" {
                numIslands += dfs(&grid, i, j)
            }
        }
    }
    
    return numIslands
}

func dfs(_ grid: inout [[Character]], _ i: Int, _ j: Int) -> Int {
    guard i >= 0 && i < grid.count, j >= 0 && j < grid[i].count, grid[i][j] != "0" else {
        return 0
    }
    
    grid[i][j] = "0"
    
    dfs(&grid, i-1, j)
    dfs(&grid, i, j+1)
    dfs(&grid, i+1, j)
    dfs(&grid, i, j-1)
    
    return 1
}

///
/// "remove nth node from end of list"
///
func removeNthFromEnd(_ head: ListNode?, _ n: Int) -> ListNode? {
    var dummy = ListNode(-1, head)
    var l: ListNode? = dummy, r = head
    
    var n = n
    while n > 0 {
        r = r?.next
        n -= 1
    }
    
    while r != nil {
        l = l?.next
        r = r!.next
    }
    
    l?.next = l?.next?.next
    
    return dummy.next
}

///
/// "palindromic substrings"
///
func countSubstrings(_ s: String) -> Int {
    var numPalindromes = 0
    
    for i in 0..<s.count {
        numPalindromes += countPalindromes(in: s, expandingFrom: (l: i, r: i))
        numPalindromes += countPalindromes(in: s, expandingFrom: (l: i, r: i + 1))
    }
    
    return numPalindromes
}

func countPalindromes(in s: String, expandingFrom: (l: Int, r: Int)) -> Int {
    var numPalindromes = 0
    var l = expandingFrom.l, r = expandingFrom.r
    
    var str = Array(s)
    
    while l >= 0 && r < str.count && str[l] == str[r] {
        numPalindromes += 1
        l -= 1
        r += 1
    }
    
    return numPalindromes
}

///
/// "pacific atlantic water flow"
///
func pacificAtlantic(_ heights: [[Int]]) -> [[Int]] {
    let rows = heights.count, cols = heights[0].count
    var pac = Set<[Int]>(), atl = Set<[Int]>()
    
    func dfs(_ r: Int, _ c: Int, _ visited: inout Set<[Int]>, _ prevHeight: Int) {
        guard
            !visited.contains([r,c]),
            r >= 0 && r < rows, c >= 0 && c < cols,
            heights[r][c] >= prevHeight
        else {
            return
        }
        
        visited.insert([r,c])
        dfs(r-1, c, &visited, heights[r][c])
        dfs(r, c+1, &visited, heights[r][c])
        dfs(r+1, c, &visited, heights[r][c])
        dfs(r, c-1, &visited, heights[r][c])
    }
    
    for col in 0..<cols {
        dfs(0, col, &pac, heights[0][col])
        dfs(rows-1, col, &atl, heights[rows-1][col])
    }
    
    for row in 0..<rows {
        dfs(row, 0, &pac, heights[row][0])
        dfs(row, cols-1, &atl, heights[row][cols-1])
    }
    
    return Array(pac.intersection(atl))
}

///
/// "longest repeating character replacement"
///
func characterReplacement(_ s: String, _ k: Int) -> Int {
    var result = 0
    
    var str = Array(s)
    var l = 0
    var counts = [Character: Int]()
    
    for r in 0..<str.count {
        counts[str[r]] = 1 + (counts[str[r]] ?? 0)
        
        guard
            (r - l + 1) - (counts.max(by: {
                return $0.value < $1.value
            })!.value) <= k
        else {
            counts[str[l]] = counts[str[l]]! - 1
            l += 1
            continue
        }
        
        result = max(result, r - l + 1)
    }
    
    return result
}

///
/// "minimum window substring" 
///
func minWindow(_ s: String, _ t: String) -> String {
    guard !t.isEmpty else { return "" }
    
    var minWindow = (start: -1, end: -1), minWindowLength = Int.max
    
    var charsNeeded = [Character: Int](), charsInWindow = [Character: Int]()
    for char in t {
        charsNeeded[char] = 1 + (charsNeeded[char] ?? 0)
    }
    
    var have = 0, need = charsNeeded.count
    let str = Array(s)
    
    var l = 0
    for r in 0..<str.count {
        let c = str[r]
        
        charsInWindow[c] = 1 + (charsInWindow[c] ?? 0)
        
        if charsNeeded[c] != nil && charsInWindow[c] == charsNeeded[c] {
            have += 1
        }
        
        while have == need {
            if (r - l + 1) < minWindowLength {
                minWindow = (l, r)
                minWindowLength = (r - l + 1)
            }
            
            charsInWindow[str[l]] = charsInWindow[str[l]]! - 1
            
            if let countNeeded = charsNeeded[str[l]], let countHave = charsInWindow[str[l]], countHave < countNeeded {
                have -= 1
            }
            
            l += 1
        }
    }
    
    if minWindowLength == Int.max {
        return ""
    } else {
        return String(str[minWindow.start...minWindow.end])
    }
}