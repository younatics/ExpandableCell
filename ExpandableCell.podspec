#
# Be sure to run `pod lib lint ExpandableCell.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ExpandableCell'
  s.version          = '2.0.0'
  s.summary          = 'Easiest way to expand and collapse cell for iOS with Swift 6'

  s.description      = <<-DESC
Easiest usage of expandable & collapsible cell for iOS, written in Swift 6. You can customize expandable `UITableViewCell` whatever you like. `ExpandableCell` is made because `insertRows(at:with:)` and `deleteRows(at:with:)` are hard to use. You can just inherit `ExpandableDelegate` and add one more method `func expandableTableView(_:expandedCellsForRowAt:) -> [UITableViewCell]?`.
                        DESC

  s.homepage         = 'https://github.com/younatics/ExpandableCell'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Seungyoun Yi" => "younatics@gmail.com" }

  s.source           = { :git => 'https://github.com/younatics/ExpandableCell.git', :tag => s.version.to_s }
  s.source_files     = 'ExpandableCell/*.swift'
  s.resource_bundles        = { 'ExpandableCell' => [ 'ExpandableCell/*.xcassets' ] }

  s.swift_version = '6.0'
  s.ios.deployment_target = '13.0'

  s.frameworks = 'UIKit'
  s.requires_arc = true
end
