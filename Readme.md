# TraitAwareUIViewController

This UIViewController subclass has the ability, to set constraints based on the TraitCollection:

```
    // For Horizontally Regular, GreenView is in lower-leading corner
    self.insertConstraint(self.greenView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor), horizontally: .regular)
    self.insertConstraint(self.greenView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor), horizontally: .regular)

    // For Horizontally Compact, GreenView is in upper-trailing corner
    self.insertConstraint(self.greenView.topAnchor.constraint(equalTo: self.view.topAnchor), horizontally: .compact)
    self.insertConstraint(self.greenView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor), horizontally: .compact)
```

To automatically update the constraints when the traitCollection changes, just call
`self.activateConstraintsBasedOnTraitCollection()` in `traitCollectionDidChange`:

```
  override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    updateLabel()
    self.activateConstraintsBasedOnTraitCollection()
  }
```
