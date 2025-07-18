// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

// 罗马数字包含以下七种字符: I， V， X， L，C，D 和 M。

// 字符          数值
// I             1
// V             5
// X             10
// L             50
// C             100
// D             500
// M             1000
// 例如， 罗马数字 2 写做 II ，即为两个并列的 1 。12 写做 XII ，即为 X + II 。 27 写做  XXVII, 即为 XX + V + II 。

// 通常情况下，罗马数字中小的数字在大的数字的右边。但也存在特例，例如 4 不写做 IIII，而是 IV。数字 1 在数字 5 的左边，所表示的数等于大数 5 减小数 1 得到的数值 4 。
// 同样地，数字 9 表示为 IX。这个特殊的规则只适用于以下六种情况：

// I 可以放在 V (5) 和 X (10) 的左边，来表示 4 和 9。
// X 可以放在 L (50) 和 C (100) 的左边，来表示 40 和 90。 
// C 可以放在 D (500) 和 M (1000) 的左边，来表示 400 和 900。
// 给定一个整数，将其转换成罗马数字。

contract IntToRoman {

    struct NumRoman{
        uint value;
        string roman;
    }

    NumRoman[] public numRomans;


    constructor(){
       // 初始化罗马数字符号表（按从大到小顺序）
        numRomans.push(NumRoman(1000, "M"));
        numRomans.push(NumRoman(900, "CM"));
        numRomans.push(NumRoman(500, "D"));
        numRomans.push(NumRoman(400, "CD"));
        numRomans.push(NumRoman(100, "C"));
        numRomans.push(NumRoman(90, "XC"));
        numRomans.push(NumRoman(50, "L"));
        numRomans.push(NumRoman(40, "XL"));
        numRomans.push(NumRoman(10, "X"));
        numRomans.push(NumRoman(9, "IX"));
        numRomans.push(NumRoman(5, "V"));
        numRomans.push(NumRoman(4, "IV"));
        numRomans.push(NumRoman(1, "I"));
    }


    // 将整数转成罗马数字
    function toRoman(uint num) public view returns (string memory result) {
        string memory result = "";
        for (uint i = 0; i < numRomans.length; i++) {
            while (num >= numRomans[i].value) {
                result = string.concat(result, numRomans[i].roman);
                num -= numRomans[i].value;
            }
            
        }
        return result;

    }

}