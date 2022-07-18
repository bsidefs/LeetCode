///
/// Week 3: Non-linear Data Structures
/// (i.e., trees, graphs, and heaps...)

///
/// "validate binary search tree"
///
use std::rc::Rc;
use std::cell::RefCell;

impl Solution {
    pub fn is_valid_bst(root: Option<Rc<RefCell<TreeNode>>>) -> bool {
        Self::is_valid(root, i64::MIN, i64::MAX)
    }
    
    pub fn is_valid(node: Option<Rc<RefCell<TreeNode>>>, min: i64, max: i64) -> bool {
        if let Some(node) = node {
            let val = node.borrow().val as i64;
            
            if val <= min || val >= max {
                return false;
            }
            
            let is_left_valid = Self::is_valid(node.borrow().left.clone(), min, val);
            let is_right_valid = Self::is_valid(node.borrow().right.clone(), val, max);
            
            return is_left_valid && is_right_valid;
        }
        
        true
    }
}

///
/// "invert/flip a binary tree"
///
use std::rc::Rc;
use std::cell::RefCell;

impl Solution {
    pub fn invert_tree(root: Option<Rc<RefCell<TreeNode>>>) -> Option<Rc<RefCell<TreeNode>>> {
        if let Some(node) = root {
            let left = node.borrow().left.clone();
            let right = node.borrow().right.clone();
            
            node.borrow_mut().left = Self::invert_tree(right);
            node.borrow_mut().right = Self::invert_tree(left);
            
            return Some(node);
        }
        
        None
    }
}

///
/// "construct binary tree from preorder and inorder traversal"
///
use std::rc::Rc;
use std::cell::RefCell;

impl Solution {
    pub fn build_tree(preorder: Vec<i32>, inorder: Vec<i32>) -> Option<Rc<RefCell<TreeNode>>> {
        if preorder.is_empty() || inorder.is_empty() {
            return None;
        }
        
        let mut root = TreeNode::new(preorder[0]);
        let mid = inorder.iter().position(|&x| x == root.val).unwrap();
        
        let left_sub_tree = inorder[..mid].to_vec();
        let right_sub_tree = inorder[mid + 1..].to_vec();
        
        root.left = Self::build_tree(preorder[1..mid + 1].to_vec(), left_sub_tree);
        root.right = Self::build_tree(preorder[mid + 1..].to_vec(), right_sub_tree);
        
        Some(Rc::new(RefCell::new(root)))
    }
}

///
/// "top k frequent elements"
///
use std::collections::HashMap;

impl Solution {
    pub fn top_k_frequent(nums: Vec<i32>, k: i32) -> Vec<i32> {
        let mut counts: HashMap<i32, i32> = HashMap::new();
        for num in &nums {
            let count = counts.entry(*num).or_insert(0);
            *count += 1;
        }
        
        let mut buckets = vec![vec![]; nums.len() + 1];
        for (k, v) in &counts {
            buckets[*v as usize].push(*k);
        }
        
        let mut res = vec![];
        
        'outer: for i in (0..=buckets.len() - 1).rev() {
            for num in &buckets[i] {
                res.push(*num);
                
                if res.len() == k as usize {
                    break 'outer;
                }
            }
        }
        
        res
    }
}

///
/// "non-overlapping intervals" 
///
use std::cmp;

impl Solution {
    pub fn erase_overlap_intervals(intervals: Vec<Vec<i32>>) -> i32 {
        let mut res = 0;
        
        let mut intervals = intervals;
        intervals.sort_unstable_by(|a, b| a[0].cmp(&b[0]));
        
        let mut end_comparator = intervals[0][1];
        for i in 1..intervals.len() {
            if intervals[i][0] >= end_comparator {
                end_comparator = intervals[i][1];
            } else {
                res += 1;
                end_comparator = cmp::min(end_comparator, intervals[i][1]);
            }
        }   
        
        res
    }
}

///
/// "same tree" 
///
use std::rc::Rc;
use std::cell::RefCell;

impl Solution {
    pub fn is_same_tree(p: Option<Rc<RefCell<TreeNode>>>, q: Option<Rc<RefCell<TreeNode>>>) -> bool {
        match (p, q) {
            (Some(p), Some(q)) => {
                let p = p.borrow();
                let q = q.borrow();
                
                p.val == q.val && 
                    Self::is_same_tree(p.left.clone(), q.left.clone()) && 
                        Self::is_same_tree(p.right.clone(), q.right.clone())
            },
            (None, None) => true,
            _ => false,
        }
    }
}

///
/// "maximum depth of binary tree"
///
use std::rc::Rc;
use std::cell::RefCell;
use std::cmp;

impl Solution {
    pub fn max_depth(root: Option<Rc<RefCell<TreeNode>>>) -> i32 {
        if let Some(node) = root {
            let left_max_depth = Self::max_depth(node.borrow().left.clone());
            let right_max_depth = Self::max_depth(node.borrow().right.clone());
            
            return 1 + cmp::max(left_max_depth, right_max_depth);
        }
        
        0
    }
}

///
/// "binary tree level order traversal"
///
use std::rc::Rc;
use std::cell::RefCell;
use std::collections::VecDeque;

impl Solution {
    pub fn level_order(root: Option<Rc<RefCell<TreeNode>>>) -> Vec<Vec<i32>> {
        let mut res = Vec::<Vec<i32>>::new();
        
        let mut queue = VecDeque::<Option<Rc<RefCell<TreeNode>>>>::new();
        queue.push_back(root);
        
        while !queue.is_empty() {
            let mut level = Vec::<i32>::new();
            let current_queue_len = queue.len();
            
            for _ in 0..current_queue_len {
                if let Some(element) = queue.pop_front() {
                    if let Some(node) = element {
                        level.push(node.borrow().val);
                        queue.push_back(node.borrow().left.clone());
                        queue.push_back(node.borrow().right.clone());
                    }
                }
            }
            
            if !level.is_empty() {
                res.push(level);
            }
        }
        
        res
    }
}

///
/// "binary tree maximum path sum"
///
use std::rc::Rc;
use std::cell::RefCell;
use std::cmp;

impl Solution {
    pub fn max_path_sum(root: Option<Rc<RefCell<TreeNode>>>) -> i32 {
        if let Some(node) = root {
            let mut res = node.borrow().val;
            Self::dfs(Some(node.clone()), &mut res);
            
            return res;
        }
        
        0
    }
    
    pub fn dfs(node: Option<Rc<RefCell<TreeNode>>>, res: &mut i32) -> i32 {
        if let Some(node) = node {
            let left_max = cmp::max(Self::dfs(node.borrow().left.clone(), res), 0);
            let right_max = cmp::max(Self::dfs(node.borrow().right.clone(), res), 0);
            
            let max_with_splitting = node.borrow().val + left_max + right_max;
            *res = cmp::max(*res, max_with_splitting);
            
            return node.borrow().val + cmp::max(left_max, right_max);
        }
        
        0
    }
}

///
/// "course schedule"
///
use std::collections::HashMap;
use std::collections::HashSet;

impl Solution {
    pub fn can_finish(num_courses: i32, prerequisites: Vec<Vec<i32>>) -> bool {
        let mut prereqs = HashMap::<i32, Vec<i32>>::new();
        for i in 0..num_courses {
            prereqs.insert(i, vec![]);
        }
        
        for prereq in &prerequisites {
            let courses = prereqs.get_mut(&prereq[0]).unwrap();
            courses.push(prereq[1]);
        }
        
        let mut visited = HashSet::<i32>::new();
        for course in 0..num_courses {
            if Self::dfs(course, &mut prereqs, &mut visited) == false {
                return false;
            }
        }
        
        true
    }
    
    fn dfs(course: i32, prereqs: &mut HashMap<i32, Vec<i32>>, visited: &mut HashSet<i32>) -> bool {
        if visited.contains(&course) {
            return false;
        }
        
        if prereqs[&course].is_empty() {
            return true;
        }
        
        visited.insert(course);
        for course in &prereqs[&course].clone() {
            if Self::dfs(*course, prereqs, visited) == false {
                return false;
            }
        }
        visited.remove(&course);
        
        let courses = prereqs.get_mut(&course);
        courses.unwrap().clear();
        
        true
    }
}

///
/// "serialize and deserialize binary tree"
///
use std::rc::Rc;
use std::cell::RefCell;

struct Codec {
	
}

impl Codec {
    fn new() -> Self {
        Codec {
            
        }
    }

    fn serialize(&self, root: Option<Rc<RefCell<TreeNode>>>) -> String {
        let mut res = Vec::<String>::new();
        Self::preorder_traversal_ser(root, &mut res);
        
        res.join(",")
    }
    
    fn preorder_traversal_ser(node: Option<Rc<RefCell<TreeNode>>>, res: &mut Vec<String>) {
        if let Some(node) = node {
            res.push(node.borrow().val.to_string());
            Self::preorder_traversal_ser(node.borrow().left.clone(), res);
            Self::preorder_traversal_ser(node.borrow().right.clone(), res);
        } else {
            res.push("None".to_owned());
        }
    }
    
    // ----------------
	
    fn deserialize(&self, data: String) -> Option<Rc<RefCell<TreeNode>>> {
        let mut preorder: Vec<&str> = data.split(",").collect();
        let mut i = 0;
        Self::preorder_traversal_des(&mut preorder, &mut i)
    }
    
    fn preorder_traversal_des(preorder: &mut Vec<&str>, i: &mut i32) -> Option<Rc<RefCell<TreeNode>>> {
        let index = *i as usize;
        
        if preorder[index] == "None" {
            *i += 1;
            return None;
        }
        
        let node = Rc::new(RefCell::new(TreeNode::new(preorder[index].parse().unwrap())));
        *i += 1;
        node.borrow_mut().left = Self::preorder_traversal_des(preorder, i);
        node.borrow_mut().right = Self::preorder_traversal_des(preorder, i);
        
        Some(node)
    }
}