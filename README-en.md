# RACTableView

[中文](https://github.com/Dtheme/RACTableView/blob/main/README.md) | [English](https://github.com/Dtheme/RACTableView/blob/main/README-en.md)

---

`RACTableView` is a demo project providing a solution for encapsulating generic table views in iOS applications. This solution reduces redundancy, enhances code maintainability, and improves flexibility in event handling within table views. Currently, CocoaPods is not supported.

## Why RACTableView

1. **Reducing Redundant Code**: For simple lists, `RACTableView` eliminates the need to repeatedly implement the `tableView` delegate and data source methods, saving time and reducing redundant code.
2. **Preventing View Controller Bloat**: In complex lists, the MVC architecture can lead to bloated controllers. By adopting the MVVM structure, we separate business logic into the view model, using ReactiveCocoa (RAC) for data binding. This approach centralizes logic and prevents structural confusion.
3. **Cell Height Calculation and Auto Layout**:
    - Custom height calculations with caching for performance.
    - Support for system-provided `UITableViewAutomaticDimension` (not recommended for complex layouts).
    - Integration with [UITableView-FDTemplateLayoutCell](https://github.com/forkingdog/UITableView-FDTemplateLayoutCell) for auto-sizing cells with Auto Layout, with **Masonry** as a layout dependency.

## Installation

You can install `RACTableView` in two ways:

1. **Manual Installation**: Copy the files in the `RACTableView` folder directly into your project.
2. **Using CocoaPods** (when supported): Add the following line to your `Podfile`:
   ```ruby
   pod 'RACTableView', '~> 1.0.0'
   ```

The documentation is brief; refer to comments in the `.h` files for more details.
