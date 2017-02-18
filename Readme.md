# SizeClassAwareness

This UIViewController extension adds the ability to set constraints based on the TraitCollection:


![Demo Gif of rotating View](https://github.com/Lutzifer/TraitAwareUIViewController/raw/dev/Demo.gif)

## Installation

SizeClassAwareness is available through [Carthage](https://github.com/Carthage/Carthage) or [CocoaPods](https://cocoapods.org).

### Carthage

To install SizeClassAwareness with Carthage, add the following line to your `Cartfile`.

#### Swift 3.0.x

```
github "Lutzifer/SizeClassAwareness"
```

Then run `carthage update --no-use-binaries` command or just `carthage update`. For details of the installation and usage of Carthage, visit [its project page](https://github.com/Carthage/Carthage).


### CocoaPods

To install SizeClassAwareness with CocoaPods, add the following lines to your `Podfile`.

#### Swift 3.0.x

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

pod 'SizeClassAwareness'

```

Then run `pod install` command. For details of the installation and usage of CocoaPods, visit [its official website](https://cocoapods.org).

# Example

```swift
// For Horizontally Regular, GreenView is in lower-leading corner
let leadingConstraint = self.greenView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
let bottomConstraint = self.greenView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)

self.insertConstraint(leading, horizontally: .regular)
self.insertConstraint(bottomConstraint, horizontally: .regular)

// For Horizontally Compact, GreenView is in upper-trailing corner
let topConstraint = self.greenView.topAnchor.constraint(equalTo: self.view.topAnchor)
let trailingConstraint = self.greenView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)

self.insertConstraint(topConstraint, horizontally: .compact)
self.insertConstraint(trailingConstraint, horizontally: .compact)
```

To automatically update the constraints when the traitCollection changes, just call
`self.activateConstraintsBasedOnTraitCollection()` in `traitCollectionDidChange`:

```swift
  override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    self.activateConstraintsBasedOnTraitCollection()
  }
```
