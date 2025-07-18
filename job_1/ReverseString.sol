// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ✅反转字符串 (Reverse String)
// 题目描述：反转一个字符串。输入 "abcde"，输出 "edcba"


contract ReverseString{
     
    function reverse(string memory inputStr)public pure  returns (string memory outputStr){
        // 将字符串转换为bytes solidity中的string 类比就是 bytes的包装  
        bytes memory strBytes = bytes(inputStr);

        //生成一个新的bytes数组 用于接受反转后的数据
        bytes memory reversed = new bytes(strBytes.length);


        for (uint i = 0; i < strBytes.length; i++){
            reversed[i] = strBytes[strBytes.length - i -1 ];
        }

        outputStr = string(reversed);
    }

}