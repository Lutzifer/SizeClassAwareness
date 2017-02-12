# TraitAwareUIViewController

This UIViewController subclass has the ability, to set constraints based on the TraitCollection:

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
