//
//  UIViewController+TraitAwareness.swift
//
//  Created by Wolfgang Lutz on 12.02.17.
//  Copyright © 2017 Wolfgang Lutz. All rights reserved.
//

import UIKit
import ObjectiveC

protocol TraitAwareViewController {
  func insertConstraint(_ constraint: NSLayoutConstraint,
                        vertically   forVerticalSizeClass:   UIUserInterfaceSizeClass,
                        horizontally forHorizontalSizeClass: UIUserInterfaceSizeClass
  )
  
  func insertConstraints(_ constraints: [NSLayoutConstraint],
                        vertically   forVerticalSizeClass:   UIUserInterfaceSizeClass,
                        horizontally forHorizontalSizeClass: UIUserInterfaceSizeClass
  )
  
  func removeConstraint(_ constraint: NSLayoutConstraint,
                        vertically   forVerticalSizeClass:   UIUserInterfaceSizeClass,
                        horizontally forHorizontalSizeClass: UIUserInterfaceSizeClass
  )
  
  func removeConstraints(_ constraints: [NSLayoutConstraint],
                         vertically   forVerticalSizeClass:   UIUserInterfaceSizeClass,
                         horizontally forHorizontalSizeClass: UIUserInterfaceSizeClass
  )
  
  func activateConstraintsBasedOnTraitCollection()
}

extension UIViewController : TraitAwareViewController {
  
  private enum ConstraintOperation {
    case insert
    case remove
  }
  
  private struct AssociatedKey {
    static var constraintsDictionaryKey = "constraintsDictionary"
  }
  
  internal var constraintsDictionary: [ SizeClassPair : [NSLayoutConstraint] ]  {
    get {
      return getAssociatedObject(object: self, associativeKey: &AssociatedKey.constraintsDictionaryKey)
        ?? [ .compactCompactPair : [NSLayoutConstraint](),
             .compactRegularPair : [NSLayoutConstraint](),
             .regularCompactPair : [NSLayoutConstraint](),
             .regularRegularPair : [NSLayoutConstraint]()
            ]
    }
    
    set {
    setAssociatedObject(object: self, value: newValue, associativeKey: &AssociatedKey.constraintsDictionaryKey, policy: objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  
  public func insertConstraint(_ constraint: NSLayoutConstraint,
                               vertically forVerticalSizeClass: UIUserInterfaceSizeClass = .unspecified,
                               horizontally forHorizontalSizeClass: UIUserInterfaceSizeClass = .unspecified) {
    self.runOperation(.insert, with: [constraint], vertically: forVerticalSizeClass, horizontally: forHorizontalSizeClass)
  }
  
  public func insertConstraints(_ constraints: [NSLayoutConstraint],
                         vertically   forVerticalSizeClass:   UIUserInterfaceSizeClass = .unspecified,
                         horizontally forHorizontalSizeClass: UIUserInterfaceSizeClass = .unspecified
    ) {
    self.runOperation(.insert, with: constraints, vertically: forVerticalSizeClass, horizontally: forHorizontalSizeClass)
  }
  
  public func removeConstraint(_ constraint: NSLayoutConstraint,
                        vertically   forVerticalSizeClass:   UIUserInterfaceSizeClass = .unspecified,
                        horizontally forHorizontalSizeClass: UIUserInterfaceSizeClass = .unspecified
    ){
    self.runOperation(.remove, with: [constraint], vertically: forVerticalSizeClass, horizontally: forHorizontalSizeClass)
  }
  
  public func removeConstraints(_ constraints: [NSLayoutConstraint],
                         vertically   forVerticalSizeClass:   UIUserInterfaceSizeClass = .unspecified,
                         horizontally forHorizontalSizeClass: UIUserInterfaceSizeClass = .unspecified
    ){
    self.runOperation(.remove, with: constraints, vertically: forVerticalSizeClass, horizontally: forHorizontalSizeClass)
  }

  private func runOperation(_ operation: ConstraintOperation = .insert,
                      with constraints: [NSLayoutConstraint],
                      vertically   forVerticalSizeClass:   UIUserInterfaceSizeClass = .unspecified,
                      horizontally forHorizontalSizeClass: UIUserInterfaceSizeClass = .unspecified
    ) {
    if forVerticalSizeClass == .unspecified, forHorizontalSizeClass == .unspecified {
      SizeClassPair.allPairs.forEach { pair in
        self.apply(operation: operation, for: constraints, using: pair)
      }
    } else if forVerticalSizeClass == .unspecified, forHorizontalSizeClass == .compact {
      self.insertConstraints(constraints, vertically: .compact, horizontally: .compact)
      self.insertConstraints(constraints, vertically: .regular, horizontally: .compact)
    } else if forVerticalSizeClass == .unspecified, forHorizontalSizeClass == .regular {
      self.insertConstraints(constraints, vertically: .compact, horizontally: .regular)
      self.insertConstraints(constraints, vertically: .regular, horizontally: .regular)
    } else if forVerticalSizeClass == .compact, forHorizontalSizeClass == .unspecified {
      self.insertConstraints(constraints, vertically: .compact, horizontally: .compact)
      self.insertConstraints(constraints, vertically: .compact, horizontally: .regular)
    } else if forVerticalSizeClass == .regular, forHorizontalSizeClass == .unspecified {
      self.insertConstraints(constraints, vertically: .regular, horizontally: .compact)
      self.insertConstraints(constraints, vertically: .regular, horizontally: .regular)
    } else {
      self.apply(operation: operation,
                 for: constraints,
                 using: SizeClassPair.pair(forVertical: forVerticalSizeClass, forHorizontal: forHorizontalSizeClass)
      )
    }
  }
  
  private func apply(operation: ConstraintOperation, for constraints: [NSLayoutConstraint], using pair: SizeClassPair) {
    switch operation {
    case .insert:
      constraintsDictionary[pair]!.append(contentsOf: constraints)
    case .remove:
      constraintsDictionary[pair]!.removeObjectsInArray(array: constraints)
    }
  }
  
  public func activateConstraintsBasedOnTraitCollection() {
    let currentSizeClassPair = SizeClassPair.pair(
                                  forVertical:   self.traitCollection.verticalSizeClass,
                                  forHorizontal: self.traitCollection.horizontalSizeClass
                               )
    SizeClassPair.allPairs.filter { pair -> Bool in
      pair != currentSizeClassPair
    }.forEach { pair in
      NSLayoutConstraint.deactivate(constraintsDictionary[pair]!)
    }
    
    NSLayoutConstraint.activate(constraintsDictionary[currentSizeClassPair]!)
  }
}
