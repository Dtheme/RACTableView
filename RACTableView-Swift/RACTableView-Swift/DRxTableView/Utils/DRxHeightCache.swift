//
//  DRxHeightCache.swift
//  DRxTableView
//
//  Created by dzw on 2024/12/13.
//  Copyright © 2024 dzw. All rights reserved.
//

import UIKit

/// Cell高度缓存管理器
public final class DRxHeightCache {
    
    // MARK: - Properties
    
    /// 缓存容量
    private let capacity: Int
    
    /// 高度缓存字典
    private var cache: [String: CGFloat] = [:]
    
    /// 缓存访问顺序队列
    private var accessQueue: [String] = []
    
    // MARK: - Initialization
    
    public init(capacity: Int = DRxConstants.Performance.heightCacheCapacity) {
        self.capacity = capacity
    }
    
    // MARK: - Public Methods
    
    /// 获取缓存的高度
    /// - Parameter key: 缓存键
    /// - Returns: 缓存的高度，如果不存在返回nil
    public func height(for key: String) -> CGFloat? {
        guard let height = cache[key] else { return nil }
        updateAccessOrder(for: key)
        return height
    }
    
    /// 设置高度缓存
    /// - Parameters:
    ///   - height: 高度值
    ///   - key: 缓存键
    public func setHeight(_ height: CGFloat, for key: String) {
        if cache.count >= capacity && cache[key] == nil {
            removeOldestCache()
        }
        cache[key] = height
        updateAccessOrder(for: key)
    }
    
    /// 移除指定键的缓存
    /// - Parameter key: 缓存键
    public func removeHeight(for key: String) {
        cache.removeValue(forKey: key)
        accessQueue.removeAll { $0 == key }
    }
    
    /// 清空所有缓存
    public func clearCache() {
        cache.removeAll()
        accessQueue.removeAll()
    }
    
    // MARK: - Private Methods
    
    /// 更新访问顺序
    private func updateAccessOrder(for key: String) {
        accessQueue.removeAll { $0 == key }
        accessQueue.append(key)
    }
    
    /// 移除最旧的缓存
    private func removeOldestCache() {
        guard let oldestKey = accessQueue.first else { return }
        cache.removeValue(forKey: oldestKey)
        accessQueue.removeFirst()
    }
}

// MARK: - 缓存键生成
extension DRxHeightCache {
    /// 生成缓存键
    /// - Parameters:
    ///   - identifier: 模型标识符
    ///   - width: 宽度
    /// - Returns: 缓存键
    public static func cacheKey(identifier: String, width: CGFloat) -> String {
        return "\(identifier)_\(width)"
    }
} 