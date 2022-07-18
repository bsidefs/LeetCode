///
/// Week 1: Sequences
///

///
/// "two sum"
///
use std::collections::HashMap;

impl Solution {
    pub fn two_sum(nums: Vec<i32>, target: i32) -> Vec<i32> {
        let mut map = HashMap::<i32, i32>::new();
        
        for i in 0..nums.len() {
            if let Some(&complement) = map.get(&(target - nums[i] as i32)) {
                return vec![i as i32, complement];
            }
            
            map.insert(nums[i], i as i32);
        }
        
        vec![]
    }
}

///
/// "contains duplicate"
///
use std::collections::HashSet;

impl Solution {
    pub fn contains_duplicate(nums: Vec<i32>) -> bool {
        let mut set = HashSet::<i32>::new();
        
        for num in &nums {
            if !set.insert(*num) {
                return true;
            }
        }
        
        false
    }
}

///
/// "best time to buy and sell stock"
///
use std::cmp;

impl Solution {
    pub fn max_profit(prices: Vec<i32>) -> i32 {
        let mut max_profit = 0;
        let mut min_price = i32::MAX;
        
        for i in 0..prices.len() {
            if prices[i] < min_price {
                min_price = prices[i];
            }
            
            max_profit = cmp::max(max_profit, prices[i] - min_price);
        }
        
        max_profit
    }
}

///
/// "valid anagram"
///
use std::collections::HashMap;

impl Solution {
    pub fn is_anagram(s: String, t: String) -> bool {
        let mut sMap = HashMap::<char, i32>::new();
        for char in s.chars() {
            if let Some(&count) = sMap.get(&char) {
                sMap.insert(char, count + 1);
            } else {
                sMap.insert(char, 1);
            }
        }
        
        let mut tMap = HashMap::<char, i32>::new();
        for char in t.chars() {
            if let Some(&count) = tMap.get(&char) {
                tMap.insert(char, count + 1);
            } else {
                tMap.insert(char, 1);
            }
        }
        
        sMap == tMap
    }
}

///
/// "valid parentheses"
///
use std::collections::hash_set::HashSet;
use std::collections::HashMap;

impl Solution {
    pub fn is_valid(s: String) -> bool {
        let mut stack: Vec<char> = vec![];
        
        let open_parentheses = HashSet::from([
            '(', 
            '[',
            '{'
        ]);
        
        let pairs = HashMap::from([
            ('(', ')'), 
            ('[', ']'), 
            ('{', '}')
        ]);
        
        for ch in s.chars() {
            match stack.last() {
                Some(open_paren) => {
                    if ch == pairs[open_paren] {
                        stack.pop();
                    } else if open_parentheses.contains(&ch) {
                        stack.push(ch);
                    } else {
                        return false;
                    }
                }
                None => {
                    if open_parentheses.contains(&ch) {
                        stack.push(ch);
                    } else {
                        return false;
                    }
                }
            }
        }
        
        stack.is_empty()
    }
}

///
/// "product of array except self"
///
impl Solution {
    pub fn product_except_self(nums: Vec<i32>) -> Vec<i32> {
        let mut res = Vec::<i32>::new();
        let nums_len: usize = nums.len();
        
        let mut left_products = vec![1; nums_len];
        let mut right_products = vec![1; nums_len];
        
        let mut current_left_product = 1;
        for i in 0..nums_len {
            if i == 0 {
                continue;
            }
            
            current_left_product *= nums[i - 1];
            left_products[i] = current_left_product;
        }
        
        let mut current_right_product = 1;
        for i in (0..nums_len).rev() {
            if i == nums_len - 1 {
                continue;
            }
            
            current_right_product *= nums[i + 1];
            right_products[i] = current_right_product;
        }
        
        for i in 0..nums_len {
            res.push(left_products[i] * right_products[i]);
        }
        
        res
    }
}


///
/// "maximum subarray"
///
use std::cmp;

impl Solution {
    pub fn max_sub_array(nums: Vec<i32>) -> i32 {
        let mut max_sum = i32::MIN;
        let mut current_sum = 0;
        
        for num in &nums {
            current_sum += *num;
            
            if current_sum < *num {
                current_sum = *num;
            }
            
            max_sum = cmp::max(max_sum, current_sum);
        }
        
        max_sum
    }
}

///
/// "3sum"
///
use std::cmp;

impl Solution {
    pub fn three_sum(nums: Vec<i32>) -> Vec<Vec<i32>> {
        if nums.is_empty() {
            return vec![]
        }
        
        let mut res = vec![];
        let mut nums = nums;
        nums.sort_unstable();
        
        let nums_len = nums.len();
        for i in 0..cmp::max(0, nums_len as isize - 2) {
            let i = i as usize;
            if i == 0 || i > 0 && nums[i] != nums[i - 1] {
                let mut low = i + 1;
                let mut high = nums_len - 1;
                let sum = 0 - nums[i];
                
                while low < high {
                    if nums[low] + nums[high] == sum {
                        res.push(vec![nums[i], nums[low], nums[high]]);
                        
                        while low < high && nums[low] == nums[low + 1] {
                            low += 1;
                        }
                    
                        while low < high && nums[high] == nums[high - 1] {
                            high -= 1;
                        }
                    
                        low += 1;
                        high -= 1;
                    } else if nums[low] + nums[high] > sum {
                        high -= 1;
                    } else {
                        low += 1;
                    }
                }
            }
        }
        
        res
    }
}

///
/// "merge intervals"
///
use std::cmp;

impl Solution {
    pub fn merge(intervals: Vec<Vec<i32>>) -> Vec<Vec<i32>> {
        if intervals.len() <= 1 {
            return intervals;
        }
        
        let mut intervals = intervals;
        intervals.sort_unstable_by(|a, b| {
            a.first().cmp(&b.first())
        });
            
        
        let mut res: Vec<Vec<i32>> = vec![];
        
        let mut current_interval = intervals[0].clone();
        res.push(current_interval);
        
        let mut i = 0;
        for interval in &intervals {
            let current_start = res[i][0];
            let current_end = res[i][1];
            
            let next_start = *(interval.first().unwrap());
            let next_end = *(interval.last().unwrap());
            
            if current_end >= next_start {
                res[i][1] = cmp::max(current_end, next_end);
            } else {
                current_interval = interval.clone();
                res.push(current_interval);
                i += 1;
            }
        }
        
        res
    }
}

///
/// "group anagrams"
///
use std::collections::HashMap;

impl Solution {
    pub fn group_anagrams(strs: Vec<String>) -> Vec<Vec<String>> {
        let mut map: HashMap<Vec<i32>, Vec<String>> = HashMap::new();
        
        for s in strs {
            let mut counts = vec![0; 26];
            
            let char_a = 'a';
            for c in s.chars() {
                if c.is_ascii() {
                    let ith_index = (c as u32 - char_a as u32) as usize;
                    let current_count = counts[ith_index];
                    
                    counts[ith_index] += 1;
                }
            }
            
            match map.get_mut(&counts) {
                Some(anagrams) => {
                    anagrams.push(s);
                }
                None => {
                    map.insert(counts, vec![s]);
                }
            }
        }
        
        map.values().cloned().collect::<Vec<Vec<String>>>()
    }
}