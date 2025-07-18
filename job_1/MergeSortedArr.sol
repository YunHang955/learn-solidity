// SPDX-License-Identifier: MIT
pragma solidity ^0.8;


// ✅  合并两个有序数组 (Merge Sorted Array)
// 题目描述：将两个有序数组合并为一个有序数组

contract MergeSortedArr{
    

    function merge(uint256[] memory a, uint256[] memory b) public pure returns (uint256[] memory ) {
        uint256[] memory merged = new uint256[](a.length + b.length);
        uint256 i = 0; // a数组的索引
        uint256 j = 0; // b数组的索引
        uint256 k = 0; // merged数组的索引
        // a: 1 , 3 , 4
        // b: 2 , 5 , 6
        // 比较两个数组的元素并按顺序合并
        while (i < a.length && j < b.length) {
            if (a[i] < b[j]) {
                merged[k] = a[i];
                i++;
            } else {
                merged[k] = b[j];
                j++;
            }
            k++;
        }

        // 将a剩余的元素添加到merged
        while (i < a.length) {
            merged[k] = a[i];
            i++;
            k++;
        }
        
        // 将b剩余的元素添加到merged
        while (j < b.length) {
            merged[k] = b[j];
            j++;
            k++;
        }
        

        return merged;

    
    }

     

  
}