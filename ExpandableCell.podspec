#
# Be sure to run `pod lib lint ExpandableCell.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ExpandableCell'
  s.version          = '1.0.0'
  s.summary          = 'Easiest way to expand and collapse cell for iOS with Swift 3'

  s.description      = <<-DESC
Easiest usage of expandable & collapsible cell for iOS, written in Swift 3. You can customize expandable `UITableViewCell` whatever you like. `YNExpandableCell` is made because `insertRows(at indexPaths, with animation` and `deleteRows(at indexPaths, with animation` is hard to use. You can just inheirt `YNTableViewDelegate` and add one more method `func tableView(_ tableView: YNTableView, expandCellAt indexPath) -> UITableViewCell?` 
                        DESC

  s.homepage         = 'https://github.com/younatics/ExpandableCell'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Seungyoun Yi" => "younatics@gmail.com" }

  s.source           = { :git => 'https://github.com/younatics/ExpandableCell.git', :tag => s.version.to_s }
  s.source_files     = 'ExpandableCell/*.swift'
  s.resources        = "ExpandableCell/*.xcassets"

  s.ios.deployment_target = '8.0'

  s.frameworks = 'UIKit'
  s.requires_arc = true
end
