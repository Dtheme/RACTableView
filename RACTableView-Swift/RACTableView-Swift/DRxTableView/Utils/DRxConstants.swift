//
//  DRxConstants.swift
//  DRxTableView
//
//  Created by dzw on 2024/12/18.
//  Copyright © 2024 dzw. All rights reserved.
//

import UIKit

/// DRxTableView 框架常量定义
public enum DRxConstants {
    /// 高度相关常量
    public enum Height {
        /// 默认cell高度
        public static let defaultCell: CGFloat = 44.0
        /// 默认header高度
        public static let defaultHeader: CGFloat = 40.0
        /// 默认footer高度
        public static let defaultFooter: CGFloat = 40.0
        /// 自动计算高度
        public static let automatic: CGFloat = UITableView.automaticDimension
    }
    
    /// 动画相关常量
    public enum Animation {
        /// 默认动画时长
        public static let defaultDuration: TimeInterval = 0.25
    }
    
    /// 复用标识符相关常量
    public enum ReuseIdentifier {
        /// 默认cell复用标识符
        public static let defaultCell = "DRxDefaultCell"
        /// 默认header复用标识符
        public static let defaultHeader = "DRxDefaultHeader"
        /// 默认footer复用标识符
        public static let defaultFooter = "DRxDefaultFooter"
    }
    
    /// 性能相关常量
    public enum Performance {
        /// 预加载阈值（距离底部多少时触发预加载）
        public static let preloadThreshold: CGFloat = 100.0
        /// 高度缓存容量
        public static let heightCacheCapacity = 100
    }
}
