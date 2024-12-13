//
//  DRxExtensions.swift
//  DRxTableView
//
//  Created by dzw on 2024/12/13.
//  Copyright © 2024 dzw. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - UITableView + Rx
public extension Reactive where Base: UITableView {
    
    /// 绑定数据源
    /// - Parameter sections: 数据源序列
    /// - Returns: Disposable
    func items(sections: Observable<[SectionModel]>) -> Disposable {
        return items(sections: sections, animation: .none)
    }
    
    /// 监听滚动到底部事件
    var reachedBottom: Observable<Void> {
        return contentOffset
            .map { [weak base] offset in
                guard let base = base else { return false }
                let height = base.frame.height
                let contentHeight = base.contentSize.height
                let threshold = DRxConstants.Performance.preloadThreshold
                return offset.y + height + threshold >= contentHeight
            }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in () }
    }
    
    /// 使用动画绑定数据源
    /// - Parameters:
    ///   - sections: 数据源序列
    ///   - animation: 动画配置
    /// - Returns: Disposable
    func items(sections: Observable<[SectionModel]>, animation: DRxAnimationConfig) -> Disposable {
        guard let tableView = base as? DRxTableView else {
            return Disposables.create()
        }
        
        return sections
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { sections in
                tableView.updateData(sections, animation: animation)
            })
    }
}

// MARK: - UITableViewCell + Reuse
public extension UITableViewCell {
    /// 默认重用标识符
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

// MARK: - UITableViewHeaderFooterView + Reuse
public extension UITableViewHeaderFooterView {
    /// 默认重用标识符
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

// MARK: - Array + SectionModel
public extension Array where Element == SectionModel {
    /// 获取指定位置的模型
    func model(at indexPath: IndexPath) -> DRxModelProtocol? {
        guard indexPath.section < count,
              indexPath.row < self[indexPath.section].cells.count else {
            return nil
        }
        return self[indexPath.section].cells[indexPath.row]
    }
    
    /// 获取指定位置的Section
    func section(at index: Int) -> SectionModel? {
        guard index < count else { return nil }
        return self[index]
    }
}

// MARK: - BehaviorRelay + Convenience
public extension BehaviorRelay where Element == [SectionModel] {
    /// 添加Section
    func appendSection(_ section: SectionModel) {
        accept(value + [section])
    }
    
    /// 添加Cell到指定Section
    func appendCell(_ cell: DRxModelProtocol, to sectionIndex: Int) {
        var sections = value
        guard sectionIndex < sections.count else { return }
        sections[sectionIndex].cells.append(cell)
        accept(sections)
    }
    
    /// 更新指定位置的Cell
    func updateCell(_ cell: DRxModelProtocol, at indexPath: IndexPath) {
        var sections = value
        guard indexPath.section < sections.count,
              indexPath.row < sections[indexPath.section].cells.count else {
            return
        }
        sections[indexPath.section].cells[indexPath.row] = cell
        accept(sections)
    }
    
    /// 删除指定位置的Cell
    func removeCell(at indexPath: IndexPath) {
        var sections = value
        guard indexPath.section < sections.count,
              indexPath.row < sections[indexPath.section].cells.count else {
            return
        }
        sections[indexPath.section].cells.remove(at: indexPath.row)
        accept(sections)
    }
}