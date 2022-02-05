//
//  week4.swift
//  dsa
//
//  Created by Brian Tamsing on 1/15/22.
//

import Foundation

///
/// Week 4: More Data Structures
/// (i.e., trees, graphs, heaps, tries, etc.)
///

///
/// "implement trie (prefix tree)"
///
class TrieNode {
    var val: Character?
    weak var parent: TrieNode?
    var children: [Character: TrieNode] = [:]
    var isTerminating = false
    
    init(val: Character? = nil, parent: TrieNode? = nil) {
        self.val = val
        self.parent = parent
    }
    
    func add(child: Character) {
        guard children[child] == nil else { return }
        
        children[child] = TrieNode(val: child, parent: self)
    }
}

class Trie {
    var root = TrieNode()
    
    init() {}
    
    func insert(_ word: String) {
        var currentNode = root
        var chars = Array(word)
        
        var i = 0
        while i < chars.count {
            let c = chars[i]
            
            if let child = currentNode.children[c] {
                currentNode = child
            } else {
                currentNode.add(child: c)
                currentNode = currentNode.children[c]!
            }
            i += 1
        }
        
        currentNode.isTerminating = true
    }
    
    func search(_ word: String) -> Bool {
        var currentNode = root
        var chars = Array(word)
        
        var i = 0
        while i < chars.count, let child = currentNode.children[chars[i]] {
            currentNode = child
            i += 1
        }
        
        return i == chars.count && currentNode.isTerminating ? true : false
    }
    
    func startsWith(_ prefix: String) -> Bool {
        var currentNode = root
        var chars = Array(prefix)
        
        var i = 0
        while i < chars.count, let child = currentNode.children[chars[i]] {
            currentNode = child
            i += 1
        }
        
        return i == chars.count ? true : false
    }
}

///
/// "design add/search word data structure"
///
class TrieNode {
    var val: Character?
    weak var parent: TrieNode?
    var children: [Character: TrieNode] = [:]
    var isTerminating = false
    
    init(val: Character? = nil, parent: TrieNode? = nil) {
        self.val = val
        self.parent = parent
    }
    
    func add(child: Character) {
        guard children[child] == nil else { return }
        
        children[child] = TrieNode(val: child, parent: self)
    }
}

class WordDictionary {
    var root = TrieNode()
    
    init() {}
    
    func addWord(_ word: String) {
        var currentNode = root
        var chars = Array(word)
        
        var i = 0
        while i < chars.count {
            let c = chars[i]
            
            if let child = currentNode.children[c] {
                currentNode = child
            } else {
                currentNode.add(child: c)
                currentNode = currentNode.children[c]!
            }
            
            i += 1
        }
        
        currentNode.isTerminating = true
    }
    
    func search(_ word: String) -> Bool {
        var chars = Array(word)
        
        func dfs(_ node: TrieNode, _ i: Int) -> Bool {
            var currentNode = node
            var i = i
            
            while i < chars.count {
                let c = chars[i]
                
                if c == "." {
                    for child in currentNode.children.values {
                        if dfs(child, i+1) {
                            return true
                        }
                    }
                    return false
                } else if let child = currentNode.children[c] {
                    currentNode = child
                } else {
                    break
                }
                
                i += 1
            }
            
            return i == chars.count && currentNode.isTerminating ? true : false
        }
        
        return dfs(root, 0)
    }
}

///
/// "subtree of another tree"
///
class Solution {
    func isSubtree(_ root: TreeNode?, _ subRoot: TreeNode?) -> Bool {
        guard subRoot != nil else { return true }
        guard let root = root else { return false }
        
        if isSameTree(root, subRoot) { return true }
        
        return isSubtree(root.left, subRoot) || isSubtree(root.right, subRoot)
    }
    
    func isSameTree(_ s: TreeNode?, _ t: TreeNode?) -> Bool {
        if s == nil && t == nil { return true }
        
        if let s = s, let t = t, s.val == t.val {
            return isSameTree(s.left, t.left) && isSameTree(s.right, t.right)
        }
        
        return false
    }
}

///
/// "lowest common ancestor of a bst"
///
func lowestCommonAncestor(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
    guard let root = root, let p = p, let q = q else { return nil }
    
    var current: TreeNode? = root
    while let node = current {
        if p.val < node.val && q.val < node.val {
            current = node.left
        } else if node.val < p.val && node.val < q.val {
            current = node.right
        } else {
            return node
        }
    }
    
    return nil
}

///
/// "kth smallest element in a bst"
///
func kthSmallest(_ root: TreeNode?, _ k: Int) -> Int {
    var inorder = [Int]()
    
    func inorderTraversal(_ node: TreeNode?) {
        guard let node = node else { return }
        
        inorderTraversal(node.left)
        inorder.append(node.val)
        inorderTraversal(node.right)
    }
    
    inorderTraversal(root)
    
    return inorder[k-1]
}

///
/// "insert interval"
///
func insert(_ intervals: [[Int]], _ newInterval: [Int]) -> [[Int]] {
    var res = [[Int]]()
    var newInterval = newInterval
    
    for i in 0..<intervals.count {
        if newInterval[1] < intervals[i][0] {
            res.append(newInterval)
            return res + Array(intervals[i...])
        } else if newInterval[0] > intervals[i][1] {
            res.append(intervals[i])
        } else {
            newInterval[0] = min(newInterval[0], intervals[i][0])
            newInterval[1] = max(newInterval[1], intervals[i][1])
        }
    }
    
    res.append(newInterval)
    
    return res
}

///
/// "merge k sorted linked lists"
///
class Solution {
    func mergeKLists(_ lists: [ListNode?]) -> ListNode? {
        let lists = lists.compactMap { $0 }
        
        if lists.count < 2 {
            return lists.first
        }
        
        let midpoint = lists.count / 2
        let left = mergeKLists(Array(lists[..<midpoint]))
        let right = mergeKLists(Array(lists[midpoint...]))
        
        return merge(left, right)
    }
    
    func merge(_ left: ListNode?, _ right: ListNode?) -> ListNode? {
        var res = [ListNode]()
        
        var left = left
        var right = right
        
        while let l = left, let r = right {
            if l.val < r.val {
                res.append(l)
                left = l.next
            } else if r.val < l.val {
                res.append(r)
                right = r.next
            } else {
                res.append(l)
                res.append(r)
                left = l.next
                right = r.next
            }
        }
        
        while let l = left {
            res.append(l)
            left = l.next
        }
        
        while let r = right {
            res.append(r)
            right = r.next
        }
        
        for i in 0..<res.count-1 {
            res[i].next = res[i+1]
        }

        return res.first
    }
}

///
/// "find median in data stream"
///
struct Heap {
    var nodes = [Int]()
    var orderCriteria: (Int, Int) -> Bool
    
    init(sortedBy orderCriteria: @escaping (Int, Int) -> Bool) {
        self.orderCriteria = orderCriteria
    }
    
    mutating func insert(_ val: Int) {
        nodes.append(val)
        heapifyUpwards(atIndex: nodes.count - 1)
    }
    
    mutating func heapify(atIndex index: Int, until endIndex: Int) {
        let left = (2 * index) + 1
        let right = (2 * index) + 2
        
        var replacement = index
        if left < endIndex && orderCriteria(nodes[left], nodes[replacement]) {
            replacement = left
        }
        
        if right < endIndex && orderCriteria(nodes[right], nodes[replacement]) {
            replacement = right
        }
        
        if replacement != index {
            nodes.swapAt(index, replacement)
            heapify(atIndex: replacement, until: endIndex)
        }
    }
    
    mutating func extract() -> Int {
        if nodes.count == 1 {
            return nodes.removeLast()
        } else {
            let value = nodes[0]
            
            nodes[0] = nodes.removeLast()
            heapify(atIndex: 0, until: nodes.count)
            
            return value
        }
    }
    
    mutating func heapifyUpwards(atIndex index: Int) {
        let parent = (index - 1) / 2
        
        var replacement = index
        if index > 0 && orderCriteria(nodes[replacement], nodes[parent]) {
            replacement = parent
        }
        
        if replacement != index {
            nodes.swapAt(index, replacement)
            heapifyUpwards(atIndex: replacement)
        }
    }
    
    mutating func remove(atIndex index: Int) -> Int {
        let lastValidIndex = nodes.count - 1
        
        if lastValidIndex != index {
            nodes.swapAt(index, lastValidIndex)
            
            heapify(atIndex: index, until: lastValidIndex)
            heapifyUpwards(atIndex: index)
        }
        
        return nodes.removeLast()
    }
    
    var count: Int {
        return nodes.count
    }
    
    var isEmpty: Bool {
        return nodes.isEmpty
    }
}

class MedianFinder {
    var small = Heap(sortedBy: >)
    var large = Heap(sortedBy: <)

    init() {}
    
    func addNum(_ num: Int) {
        small.insert(num)
        
        if !small.isEmpty && !large.isEmpty && small.nodes[0] > large.nodes[0] {
            let val = small.remove(atIndex: 0)
            large.insert(val)
        }
        
        if small.count > large.count + 1 {
            let val = small.remove(atIndex: 0)
            large.insert(val)
        }

        if large.count > small.count + 1 {
            let val = large.remove(atIndex: 0)
            small.insert(val)
        }
    }
    
    func findMedian() -> Double {
        if small.count < large.count {
            return Double(large.nodes[0])
        } else if large.count < small.count {
            return Double(small.nodes[0])
        } else {
            let num1 = small.nodes[0]
            let num2 = large.nodes[0]
            
            return Double(num1 + num2) / 2
        }
    }
}

///
/// "longest consecutive sequence"
///
func longestConsecutive(_ nums: [Int]) -> Int {
    guard !nums.isEmpty else { return 0 }
    
    var elements = Set<Int>()
    for num in nums {
        elements.insert(num)
    }
    
    var longest = 1
    for num in nums {
        var currentLongest = 1
        if !elements.contains(num - 1) {
            while elements.contains(num + currentLongest) {
                currentLongest += 1
            }
            longest = max(longest, currentLongest)
        }
    }
    
    return longest
}

///
/// "word search ii"
///
class TrieNode {
    var val: Character?
    weak var parent: TrieNode?
    var children: [Character: TrieNode] = [:]
    var isTerminating = false
    
    init(val: Character? = nil, parent: TrieNode? = nil) {
        self.val = val
        self.parent = parent
    }
    
    func add(_ child: Character) {
        guard children[child] == nil else { return }
        
        children[child] = TrieNode(val: child, parent: self)
    }
    
    subscript(_ char: Character) -> TrieNode? {
        return children[char]
    }
}

class Trie {
    var root = TrieNode()
    
    func insert(_ word: String) {
        var currentNode = root
        let chars = Array(word)
        
        var i = 0
        while i < chars.count {
            let c = chars[i]
            
            if let child = currentNode.children[c] {
                currentNode = child
            } else {
                currentNode.add(c)
                currentNode = currentNode.children[c]!
            }
            i += 1
        }
        
        currentNode.isTerminating = true
    }
    
    subscript(_ char: Character) -> TrieNode? {
        return root[char]
    }
}

class Solution {
    func findWords(_ board: [[Character]], _ words: [String]) -> [String] {
        var res = Set<String>()
        var board = board
        
        let trie = Trie()
        for word in words {
            trie.insert(word)
        }
        
        var currentWord = ""
        
        func dfs(_ node: TrieNode?, _ i: Int, _ j: Int) {
            guard
                i >= 0 && i < board.count,
                j >= 0 && j < board[i].count,
                let node = node, let next = node[board[i][j]],
                board[i][j] != "#"
            else { return }
            
            currentWord.append(next.val!)
            if next.isTerminating {
                res.insert(currentWord)
            }
            
            let c = board[i][j]
            board[i][j] = "#"
            
            dfs(next, i-1, j)
            dfs(next, i, j+1)
            dfs(next, i+1, j)
            dfs(next, i, j-1)
            
            currentWord.removeLast()
            board[i][j] = c
        }
        
        for i in 0..<board.count {
            for j in 0..<board[i].count {
                if trie[board[i][j]] != nil  {
                    dfs(trie.root, i, j)
                }
            }
        }
        
        return Array(res)
    }
}