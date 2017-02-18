//
//  TraitAwareUIViewController.swift
//
//  Created by Wolfgang Lutz on 12.02.17.
//  Copyright © 2017 Wolfgang Lutz. All rights reserved.
//

import UIKit
import ObjectiveC

// Stored Properties in Extensions as in http://stackoverflow.com/questions/25426780/how-to-have-stored-properties-in-swift-the-same-way-i-had-on-objective-c

final class Lifted<T> {
  let value: T
  init(_ x: T) {
    value = x
  }
}

private func lift<T>(x: T) -> Lifted<T>  {
  return Lifted(x)
}

func setAssociatedObject<T>(object: AnyObject, value: T, associativeKey: UnsafeRawPointer, policy: objc_AssociationPolicy) {
    objc_setAssociatedObject(object, associativeKey, value,  policy)
}

func getAssociatedObject<T>(object: AnyObject, associativeKey: UnsafeRawPointer) -> T? {
  if let v = objc_getAssociatedObject(object, associativeKey) as? T {
    return v
  }
  else if let v = objc_getAssociatedObject(object, associativeKey) as? Lifted<T> {
    return v.value
  }
  else {
    return nil
  }
}

class SizeClassPair: NSObject {
  let verticalSizeClass: UIUserInterfaceSizeClass
  let horizontalSizeClass: UIUserInterfaceSizeClass
  
  init(verticalSizeClass: UIUserInterfaceSizeClass, horizontalSizeClass: UIUserInterfaceSizeClass) {
    self.verticalSizeClass = verticalSizeClass
    self.horizontalSizeClass = horizontalSizeClass
  }
  
  static let compactCompactPair = SizeClassPair(verticalSizeClass: .compact, horizontalSizeClass: .compact)
  static let compactRegularPair = SizeClassPair(verticalSizeClass: .compact, horizontalSizeClass: .regular)
  static let regularCompactPair = SizeClassPair(verticalSizeClass: .regular, horizontalSizeClass: .compact)
  static let regularRegularPair = SizeClassPair(verticalSizeClass: .regular, horizontalSizeClass: .regular)
  
  static func pair(forVertical verticalSizeClass: UIUserInterfaceSizeClass, forHorizontal horizontalSizeClass: UIUserInterfaceSizeClass) -> SizeClassPair {
    if verticalSizeClass == .compact, horizontalSizeClass == .compact {
      return compactCompactPair
    } else if verticalSizeClass == .compact, horizontalSizeClass == .regular {
      return compactRegularPair
    } else if verticalSizeClass == .regular, horizontalSizeClass == .compact {
      return regularCompactPair
    } else {
      return regularRegularPair
    }
  }
  
  static let allPairs = [SizeClassPair.compactCompactPair, SizeClassPair.compactRegularPair, SizeClassPair.regularCompactPair, SizeClassPair.regularRegularPair]

  override public var hashValue: Int {
    return "\(verticalSizeClass)\(horizontalSizeClass)".hashValue
  }

  override public var hash: Int {
    return hashValue
  }

  public static func ==(lhs: SizeClassPair, rhs: SizeClassPair) -> Bool {
    return lhs.horizontalSizeClass == rhs.horizontalSizeClass && lhs.verticalSizeClass == rhs.verticalSizeClass
  }

}

protocol TraitAwareViewController {
  var constraintsDictionary: [ SizeClassPair : [NSLayoutConstraint] ] { get }
  
  func insertConstraint(_ constraint: NSLayoutConstraint,
                        vertically   forVerticalSizeClass:   UIUserInterfaceSizeClass,
                        horizontally forHorizontalSizeClass: UIUserInterfaceSizeClass
  )
  
  func insertConstraints(_ constraints: [NSLayoutConstraint],
                        vertically   forVerticalSizeClass:   UIUserInterfaceSizeClass,
                        horizontally forHorizontalSizeClass: UIUserInterfaceSizeClass
  )
  
  func activateConstraintsBasedOnTraitCollection()
  
}

extension UIViewController : TraitAwareViewController {
  
  private struct AssociatedKey {
    static var constraintsDictionaryKey = "constraintsDictionary"
  }
  
  var constraintsDictionary: [ SizeClassPair : [NSLayoutConstraint] ]  {
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
    self.insertConstraints([constraint], vertically: forVerticalSizeClass, horizontally: forHorizontalSizeClass)
  }

  
  public func insertConstraints(_ constraints: [NSLayoutConstraint],
                               vertically   forVerticalSizeClass:   UIUserInterfaceSizeClass = .unspecified,
                               horizontally forHorizontalSizeClass: UIUserInterfaceSizeClass = .unspecified
    ) {
    if forVerticalSizeClass == .unspecified, forHorizontalSizeClass == .unspecified {
      SizeClassPair.allPairs.forEach({ pair in
        constraintsDictionary[pair]!.append(contentsOf: constraints)
      })
      // Use recursion to avoid strange bug, where constraints were not deactivated
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
       constraintsDictionary[SizeClassPair.pair(forVertical: forVerticalSizeClass,
                                                forHorizontal: forHorizontalSizeClass
                            )]!.append(contentsOf: constraints)
      
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

