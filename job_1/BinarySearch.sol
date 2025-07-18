// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

// ✅  二分查找 (Binary Search)
// 题目描述：在一个有序数组中查找目标值

contract BinarySearch{

    function arrSearch(uint[] memory arr, uint target) public pure returns (uint){
        // 数组最小索引值
        uint left = 0;
        // 数组最大索引值
        uint right = arr.length - 1;
        
        while (left <= right) {
            uint mid = left+(right - left) / 2;
            // 若查找数值比中间值小，则以整个查找范围的前半部分作为新的查找范围
            if (target < arr[mid]) {
                right = mid - 1;
                // 若查找数值比中间值大，则以整个查找范围的后半部分作为新的查找范围
            } else if (target > arr[mid]) {
                left = mid + 1;
                // 若查找数据与中间元素值正好相等，则放回中间元素值的索引
            } else {
                return mid;
            }
        }

        // 找不到返回下标为0
        return 0;

    }


}