# RACTableView

[中文](https://github.com/Dtheme/RACTableView/blob/main/README.md) | [English](https://github.com/Dtheme/RACTableView/blob/main/README-en.md)

---

`RACTableView` 是一个演示项目，提供了一种在 iOS 应用中封装通用 TableView 的解决方案。该方案可以减少冗余代码，提升代码的可维护性，同时提高 TableView 中事件处理的灵活性。

## 为什么要使用 RACTableView？

1. **减少冗余代码**：对于简单列表，`RACTableView` 消除了重复实现 `tableView` 代理和数据源方法的需求，节省时间并减少冗余代码。
2. **防止控制器臃肿**：在复杂的列表场景下，MVC 架构容易导致控制器过于臃肿。通过采用 MVVM 架构，我们将业务逻辑分离到 ViewModel 中，并使用 ReactiveCocoa（RAC）进行数据绑定。这种方式使逻辑集中，避免结构混乱。
3. **单元格高度计算与 Auto Layout**：
   - 支持自定义高度计算，具有缓存机制以提高性能。
   - 支持系统提供的 `UITableViewAutomaticDimension`（不推荐用于复杂布局）。
   - 集成 [UITableView-FDTemplateLayoutCell](https://github.com/forkingdog/UITableView-FDTemplateLayoutCell) 实现 Auto Layout 自动高度，布局依赖 **Masonry**。

## 安装

你可以通过以下两种方式安装 `RACTableView`：

1. **手动安装**：将 `RACTableView` 文件夹中的文件拷贝到你的项目中。
2. **使用 CocoaPods**（待支持时）：在 `Podfile` 中添加以下代码：
   ```ruby
   pod 'RACTableView', '~> 1.0.0'
   ```
 

**文档比较简单，详细使用请参考头文件的注释。**



add:
增加了swift版本：[DRxTableView](https://github.com/Dtheme/RACTableView/tree/main/RACTableView-Swift)
swift版本使用，请参考[DRxTableView](https://github.com/Dtheme/RACTableView/tree/main/RACTableView-Swift)
swift版本并非对oc版本的简单翻译，而是重新设计，使用方式和oc版本有较大差异，高度结合swift语言特性以及rxswift
