//
//  RuisiUtil.swift
//  Ruisi
//
//  Created by yang on 2017/11/28.
//  Copyright © 2017年 yang. All rights reserved.
//

import Foundation

class RuisiUtil {
    static func getLevel(point:Int) -> String {
        if point >= 0 && point < 100 {
            return "西电托儿所"
        } else if point < 200 {
            return " 西电幼儿园"
        } else if point < 500 {
            return " 西电附小"
        } else if point < 1000 {
            return " 西电附中"
        } else if point < 2000 {
            return " 西电大一"
        } else if point < 2500 {
            return " 西电大二"
        } else if point < 3000 {
            return " 西电大三"
        } else if point < 3500 {
            return " 西电大四"
        } else if point < 6000 {
            return " 西电研一"
        } else if point < 10000 {
            return " 西电研二"
        } else if point < 14000 {
            return " 西电研三"
        } else if point < 20000{
            return " 西电博一"
        } else if point < 25000{
            return " 西电博二"
        } else if point < 30000 {
            return " 西电博三"
        } else if point < 35000 {
            return " 西电博四"
        } else if point < 40000 {
            return " 西电博五"
        } else if (point >= 40000 && point < 100000) {
            return " 西电博士后"
        } else {
            return "新手上路"
        }
    }
    
    //获得到下一等级的积分
    static func getNextLevel(point: Int) -> Int {
        if point >= 0 && point < 100 {
            return 100
        } else if point < 200 {
            return 200
        } else if point < 500 {
            return 500
        } else if point < 1000 {
            return 1000
        } else if point < 2000 {
            return 2000
        } else if point < 2500 {
            return 2500
        } else if point < 3000 {
            return 3000
        } else if point < 3500 {
            return 3500
        } else if point < 6000 {
            return 6000
        } else if point < 10000 {
            return 10000
        } else if point < 14000 {
            return 14000
        } else if point < 20000 {
            return 20000
        } else if point < 25000 {
            return 25000
        } else if point < 30000 {
            return 30000
        } else if point < 35000 {
            return 35000
        } else if point < 40000 {
            return 40000
        } else if point >= 40000 {
            return 60000
        } else {
            return 100
        }
    }
    
    // 获得等级进度
    static func getLevelProgress(_ point1: Int) -> Float {
        let point = Float(point1)
        if point >= 0 && point < 100 {
            return point / 100
        } else if point < 200 {
            return (point - 100) / 100.0
        } else if point < 500 {
            return (point - 200) / 300.0
        } else if point < 1000 {
            return (point - 500) / 500.0
        } else if point < 2000 {
            return (point - 1000) / 1000.0
        } else if point < 2500 {
            return (point - 2000) / 500.0
        } else if point < 3000 {
            return (point - 2500) / 500.0
        } else if point < 3500 {
            return (point - 3000) / 500.0
        } else if point < 6000 {
            return (point - 3500) / 2500.0
        } else if point < 10000 {
            return (point - 6000) / 4000.0
        } else if point < 14000 {
            return (point - 10000) / 4000.0
        } else if point < 20000 {
            return (point - 14000) / 6000.0
        } else if point < 25000 {
            return (point - 20000) / 15000.0
        } else if point < 30000 {
            return (point - 25000) / 5000.0
        } else if point < 35000 {
            return (point - 30000) / 5000.0
        } else if point < 40000 {
            return (point - 35000) / 5000.0
        } else if point >= 40000 {
            var b = (point - 40000) / 60000.0
            if b > 1{ b = 1}
            return b
        } else {
            return 0
        }
    }
}
