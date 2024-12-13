//
//  DRxAnimationConfig.swift
//  DRxTableView
//
//  Created by dzw on 2024/12/13.
//  Copyright © 2024 dzw. All rights reserved.
//

import UIKit

/// TableView 动画配置
public struct DRxAnimationConfig {
    /// 动画类型
    public let animation: UITableView.RowAnimation
    /// 动画时长
    public let duration: TimeInterval
    /// 动画延迟
    public let delay: TimeInterval
    /// 动画选项
    public let options: UIView.AnimationOptions
    
    public init(
        animation: UITableView.RowAnimation = .automatic,
        duration: TimeInterval = DRxConstants.Animation.defaultDuration,
        delay: TimeInterval = 0,
        options: UIView.AnimationOptions = .curveEaseInOut
    ) {
        self.animation = animation
        self.duration = duration
        self.delay = delay
        self.options = options
    }
}

/// 默认动画配置
public extension DRxAnimationConfig {
    static let `default` = DRxAnimationConfig()
    
    static let fade = DRxAnimationConfig(animation: .fade)
    static let right = DRxAnimationConfig(animation: .right)
    static let left = DRxAnimationConfig(animation: .left)
    static let top = DRxAnimationConfig(animation: .top)
    static let bottom = DRxAnimationConfig(animation: .bottom)
    static let none = DRxAnimationConfig(animation: .none)
} 