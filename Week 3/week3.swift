//
//  week3.swift
//  dsa
//
//  Created by Brian Tamsing on 1/2/22.
//

import Foundation

///
/// Week 3: Non-linear Data Structures
/// (i.e., trees, graphs, and heaps...)

///
/// "validate binary search tree"
///
func isValidBST(_ root: TreeNode?) -> Bool {
    func isValid(_ node: TreeNode?, min: Int, max: Int) -> Bool {
        guard let node = node else { return true }
        guard node.val > min && node.val < max else { return false }
        
        let isLeftValid = isValid(node.left, min: min, max: node.val)
        let isRightValid = isValid(node.right, min: node.val, max: max)
        
        return isLeftValid && isRightValid
    }
    
    return isValid(root, min: Int.min, max: Int.max)
}

///
/// "invert/flip a binary tree"
///
func invertTree(_ root: TreeNode?) -> TreeNode? {
    guard let node = root else { return nil }
    
    swap(&node.left, &node.right)
    
    invertTree(node.left)
    invertTree(node.right)
    
    return node
}

///
/// "construct binary tree from preorder and inorder traversal"
///
func buildTree(_ preorder: [Int], _ inorder: [Int]) -> TreeNode? {
    if preorder.isEmpty || inorder.isEmpty { return nil }
    
    let root = TreeNode(preorder[0])
    let mid = inorder.firstIndex(of: root.val)!
    
    let leftSubTree = Array(inorder[..<mid])
    let rightSubTree = Array(inorder[(mid+1)...])
    
    root.left = buildTree(Array(preorder[1..<(mid+1)]), leftSubTree)
    root.right = buildTree(Array(preorder[(mid+1)...]), rightSubTree)
    
    return root
}

///
/// "top k frequent elements"
///
func topKFrequent(_ nums: [Int], _ k: Int) -> [Int] {
    var counts = [Int: Int]()
    for num in nums {
        counts[num] = 1 + (counts[num] ?? 0)
    }

    var buckets = Array(repeating: [Int](), count: nums.count+1)
    for (k, v) in counts {
        buckets[v].append(k)
    }
    
    var res = [Int]()
    
    outer:
    for i in stride(from: buckets.count-1, through: 0, by: -1) {
        for num in buckets[i] {
            res.append(num)
            
            if res.count == k {
                break outer
            }
        }
    }
    
    return res
}

///
/// "non-overlapping intervals" 
///
func eraseOverlapIntervals(_ intervals: [[Int]]) -> Int {
    var res = 0
    
    var intervals = intervals
    intervals.sort(by: { arr1, arr2 in
        arr1[0] < arr2[0]
    })
    
    var endComparator = intervals[0][1]
    for i in 1..<intervals.count {
        if intervals[i][0] >= endComparator {
            endComparator = intervals[i][1]
        } else { // else, we are overlapping
            res += 1 // increase removal count
            endComparator = min(endComparator, intervals[i][1])
        }
    }
    
    return res
}

///
/// "same tree" 
///
class Solution {
    func isSameTree(_ p: TreeNode?, _ q: TreeNode?) -> Bool {
        if p != q { return false }
        if p == nil && q == nil { return true }
        
        let isLeftSame = isSameTree(p?.left, q?.left)
        let isRightSame = isSameTree(p?.right, q?.right)
        
        return isLeftSame && isRightSame
    }
}

extension TreeNode: Equatable {
    public static func == (lhs: TreeNode, rhs: TreeNode) -> Bool {
        return lhs.val == rhs.val && lhs.left == rhs.left && lhs.right == rhs.right
    }
}

///
/// "maximum depth of binary tree"
///
func maxDepth(_ root: TreeNode?) -> Int {
    guard let root = root else { return 0 }
    
    let leftMaxDepth = maxDepth(root.left)
    let rightMaxDepth = maxDepth(root.right)
    
    return 1 + max(leftMaxDepth, rightMaxDepth)
}

///
/// "binary tree level order traversal"
///
class Solution {
    func levelOrder(_ root: TreeNode?) -> [[Int]] {
        var res = [[Int]]()
        
        var queue = [TreeNode?]()
        queue.append(root)
        
        while !queue.isEmpty {
            var level = [Int]()
            let currentQueueLen = queue.count
            
            for _ in 0..<currentQueueLen {
                if let node = queue.removeFirst() {
                    level.append(node.val)
                    queue.append(node.left)
                    queue.append(node.right)
                }
            }
            
            if !level.isEmpty { res.append(level) }
        }
        
        return res
    }
}

extension TreeNode: Hashable {
    public static func == (lhs: TreeNode, rhs: TreeNode) -> Bool {
        return lhs.val == rhs.val && lhs.left == rhs.left && lhs.right == rhs.right
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(val)
        hasher.combine(left)
        hasher.combine(right)
    }
}

///
/// "clone graph"
///
func cloneGraph(_ node: Node?) -> Node? {
    guard let node = node else { return nil }
    
    var map = [Node: Node]()
    func dfs(_ node: Node) -> Node {
        guard map[node] == nil else { return map[node]! }
        
        let clone = Node(node.val)
        map[node] = clone
        for case let neighbor? in node.neighbors {
            clone.neighbors.append(dfs(neighbor))
        }
        return clone
    }
    return dfs(node)
}

///
/// "binary tree maximum path sum"
///
func maxPathSum(_ root: TreeNode?) -> Int {
    var res = root!.val
    
    func dfs(_ node: TreeNode?) -> Int {
        guard let node = node else { return 0 }
        
        let leftMax = max(dfs(node.left), 0)
        let rightMax = max(dfs(node.right), 0)
        
        let maxWithSplitting = node.val + leftMax + rightMax
        res = max(res, maxWithSplitting)
        
        return node.val + max(leftMax, rightMax)
    }
    dfs(root)
    
    return res
}

///
/// "course schedule"
///
func canFinish(_ numCourses: Int, _ prerequisites: [[Int]]) -> Bool {
    var prereqsMap = [Int: [Int]]()
    
    for i in 0..<numCourses {
        prereqsMap[i] = []
    }
    
    for prereq in prerequisites {
        prereqsMap[prereq[0]]!.append(prereq[1])
    }
    
    var visited = Set<Int>()
    func dfs(_ course: Int) -> Bool {
        guard !visited.contains(course) else { return false }
        guard !prereqsMap[course]!.isEmpty else { return true }
        
        visited.insert(course)
        for prereq in prereqsMap[course]! {
            guard dfs(prereq) != false else { return false }
        }
        visited.remove(course)
        prereqsMap[course] = []
        
        return true
    }
    
    for course in 0..<numCourses {
        guard dfs(course) != false else { return false }
    }
    return true
}

///
/// "serialize and deserialize binary tree"
///
class Codec {
    func serialize(_ root: TreeNode?) -> String {
        var res = [String]()
        
        func preorderTraversal(_ node: TreeNode?) {
            guard let node = node else {
                res.append("nil")
                return
            }
            
            res.append(String(node.val))
            preorderTraversal(node.left)
            preorderTraversal(node.right)
        }
        
        preorderTraversal(root)
        
        return res.joined(separator: ",")
    }
    
    func deserialize(_ data: String) -> TreeNode? {
        var preorder = Array(data.split(separator: ","))
        
        var i = 0
        func preorderTraversal() -> TreeNode? {
            guard preorder[i] != "nil" else {
                i += 1
                return nil
            }
            
            let node = TreeNode(Int(preorder[i])!)
            i += 1
            node.left = preorderTraversal()
            node.right = preorderTraversal()
            return node
        }
        
        return preorderTraversal()
    }
}