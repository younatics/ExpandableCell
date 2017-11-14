# ExpandableCell
[![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/sindresorhus/awesome)
[![Version](https://img.shields.io/cocoapods/v/ExpandableCell.svg?style=flat)](http://cocoapods.org/pods/ExpandableCell)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/younatics/YNExpandableCell/blob/master/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/YNExpandableCell.svg?style=flat)](http://cocoapods.org/pods/ExpandableCell)
[![Swift 4.0](https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
![iOS 8.0+](https://img.shields.io/badge/iOS-8.0%2B-blue.svg)

#### Find someone who want to make this project better than before :) Currently, I don't have enough time to resolve issues :(

## Intoduction
Fully refactored [YNExapnadableCell](https://github.com/younatics/YNExpandableCell) with more concise, bug free. Easiest usage of expandable & collapsible cell for iOS, written in Swift 3. You can customize expandable `UITableViewCell` whatever you like. `ExpandableCell` is made because `insertRows` and `deleteRows` is hard to use. Just inheirt `ExpandableDelegate`

![demo](Images/ExpandableCell.gif)

## Usage
### Basic
```swift
import ExpandableCell
```

Make `ExpandableTableView` in Storyboard or in code
```swift
@IBOutlet var tableView: ExpandableTableView!
```

Inherit `ExpandableDelegate`
```swift
class ViewController: UIViewController, ExpandableDelegate 
```

Set delegate
```swift
tableView.expandableDelegate = self
```

Set required `ExpandableDelegate` method.
#### Key two methods
| Required ExpandableDelegate | Explanation |
| --------------------------- | ----------- |
| `func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]?` | Key method to get expandable cells |
| `func expandableTableView(_ expandableTableView: ExpandableTableView, heightsForExpandedRowAt indexPath: IndexPath) -> [CGFloat]?` | Key method to get expandable cells's height |

| Required UITableViewDelegate, UITableViewDataSource | Explanation |
| --------------------------------------------------- | ----------- |
| `func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell` | - |
| `func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int` | - |
| `func expandableTableView(_ expandableTableView: ExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat` | - |

### Advanced
#### ExpandableTableView property
| Property | Type | Explanation |
| -------- | ---- | ----------- |
| `animation` | `UITableViewRowAnimation` | Animation when open and close | 

#### ExpandableTableView methods
| Method | Explanation |
| ------ | ----------- |
| `openAll` | Open all that you set in `func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]?` |
| `closeAll` | Close all that you set in `func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]?` |
| `reloadData` | TableView reload data. Expanded cells will be work also |
| `open(at indexPath: IndexPath)` | Open specific indexPath |

#### Optional delegates
| Optional ExpandableDelegate | Explanation |
| --------------------------- | ----------- |
| `func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectExpandedRowAt indexPath: IndexPath)` | Get indexpath in expanded row |
| `func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCell: UITableViewCell, didSelectExpandedRowAt indexPath: IndexPath)` | Get expandedCell and indexPath |


| Optional UITableViewDelegate, UITableViewDataSource | Explanation |
| --------------------------------------------------- | ----------- |
| `func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectRowAt indexPath: IndexPath)` | - | 
| `func expandableTableView(_ expandableTableView: ExpandableTableView, titleForHeaderInSection section: Int) -> String?` | - |
| `func expandableTableView(_ expandableTableView: ExpandableTableView, heightForHeaderInSection section: Int) -> CGFloat` | - |
| `func expandableTableView(_ expandableTableView: ExpandableTableView, viewForHeaderInSection section: Int) -> UIView?` | - |
| `func numberOfSections(in expandableTableView: ExpandableTableView) -> Int` | - |
| `func expandableTableView(_ expandableTableView: ExpandableTableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)` | - |
| `func expandableTableView(_ expandableTableView: ExpandableTableView, willDisplayHeaderView view: UIView, forSection section: Int)` | - |
| `func expandableTableView(_ expandableTableView: ExpandableTableView, willDisplayFooterView view: UIView, forSection section: Int)` | - |

#### For arrow effect
Inherit `ExpandableCell` when you need arrow effect or change arrow image
```swift
open class ExpandableCell: UITableViewCell {
    open var arrowImageView: UIImageView!
}
```

Set tableview insert animation
```Swift
tableView.animation = .automatic
```

Make protocols in `ExpandableDelegate` if you need or make pull request to me :)

#### ExpandableCell methods

| ExpandableCell methods | Explanation |
| --------------------------- | ----------- |
| `isExpanded()` | Check if cell is expanded or not |

## Requirements
`ExpandableCell` written in Swift 3. Compatible with iOS 8.0+

## Installation

### Cocoapods

ExpandableCell is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ExpandableCell'
```
### Carthage
```
github "younatics/ExpandableCell"
```

## References
#### Please tell me or make pull request if you use this library in your application :) 

## Author
[younatics](https://twitter.com/younatics)
<a href="http://twitter.com/younatics" target="_blank"><img alt="Twitter" src="https://img.shields.io/twitter/follow/younatics.svg?style=social&label=Follow"></a>

## License
ExpandableCell is available under the MIT license. See the LICENSE file for more info.
