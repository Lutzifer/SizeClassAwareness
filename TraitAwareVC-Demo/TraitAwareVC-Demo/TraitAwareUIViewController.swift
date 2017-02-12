//
//  TraitAwareUIViewController.swift
//
//  Created by Wolfgang Lutz on 12.02.17.
//  Copyright © 2017 Wolfgang Lutz. All rights reserved.
//

import UIKit

protocol TraitAwareViewController {
  var verticalCompactHorizontalRegularConstraints: [NSLayoutConstraint] { get }
  var verticalCompactHorizontalCompactConstraints: [NSLayoutConstraint] { get }
  var verticalRegularHorizontalCompactConstraints: [NSLayoutConstraint] { get }
  var verticalRegularHorizontalRegularConstraints: [NSLayoutConstraint] { get }
  
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

class TraitAwareUIViewController: UIViewController {
  lazy var verticalCompactHorizontalRegularConstraints = [NSLayoutConstraint]()
  lazy var verticalCompactHorizontalCompactConstraints = [NSLayoutConstraint]()
  lazy var verticalRegularHorizontalCompactConstraints = [NSLayoutConstraint]()
  lazy var verticalRegularHorizontalRegularConstraints = [NSLayoutConstraint]()
}

extension TraitAwareUIViewController: TraitAwareViewController {
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
      verticalCompactHorizontalRegularConstraints.append(contentsOf: constraints)
      verticalCompactHorizontalCompactConstraints.append(contentsOf: constraints)
      verticalRegularHorizontalCompactConstraints.append(contentsOf: constraints)
      verticalRegularHorizontalRegularConstraints.append(contentsOf: constraints)
      
      // Use recursion to avoid strange bug, where constraints where not deactivated
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
    } else if forVerticalSizeClass == .compact, forHorizontalSizeClass == .regular {
      verticalCompactHorizontalRegularConstraints.append(contentsOf: constraints)
    } else if forVerticalSizeClass == .compact, forHorizontalSizeClass == .compact {
      verticalCompactHorizontalCompactConstraints.append(contentsOf: constraints)
    } else if forVerticalSizeClass == .regular, forHorizontalSizeClass == .compact {
      verticalRegularHorizontalCompactConstraints.append(contentsOf: constraints)
    } else if forVerticalSizeClass == .regular, forHorizontalSizeClass == .regular {
      verticalRegularHorizontalRegularConstraints.append(contentsOf: constraints)
    }
  }
  
  public func activateConstraintsBasedOnTraitCollection() {
    if self.traitCollection.verticalSizeClass == .compact, self.traitCollection.horizontalSizeClass == .regular {
      NSLayoutConstraint.deactivate(verticalCompactHorizontalCompactConstraints)
      NSLayoutConstraint.deactivate(verticalRegularHorizontalCompactConstraints)
      NSLayoutConstraint.deactivate(verticalRegularHorizontalRegularConstraints)
      
      NSLayoutConstraint.activate(verticalCompactHorizontalRegularConstraints)
    } else if self.traitCollection.verticalSizeClass == .compact, self.traitCollection.horizontalSizeClass == .compact {
      NSLayoutConstraint.deactivate(verticalCompactHorizontalRegularConstraints)
      NSLayoutConstraint.deactivate(verticalRegularHorizontalCompactConstraints)
      NSLayoutConstraint.deactivate(verticalRegularHorizontalRegularConstraints)
      
      NSLayoutConstraint.activate(verticalCompactHorizontalCompactConstraints)
    } else if self.traitCollection.verticalSizeClass == .regular, self.traitCollection.horizontalSizeClass == .compact {
      NSLayoutConstraint.deactivate(verticalCompactHorizontalRegularConstraints)
      NSLayoutConstraint.deactivate(verticalCompactHorizontalCompactConstraints)
      NSLayoutConstraint.deactivate(verticalRegularHorizontalRegularConstraints)
      
      NSLayoutConstraint.activate(verticalRegularHorizontalCompactConstraints)
    } else if self.traitCollection.verticalSizeClass == .regular, self.traitCollection.horizontalSizeClass == .regular {
      NSLayoutConstraint.deactivate(verticalCompactHorizontalRegularConstraints)
      NSLayoutConstraint.deactivate(verticalCompactHorizontalCompactConstraints)
      NSLayoutConstraint.deactivate(verticalRegularHorizontalCompactConstraints)
      
      NSLayoutConstraint.activate(verticalRegularHorizontalRegularConstraints)
    }
    
  }
  
  fileprivate func constraintArray(vertical verticalSizeClass: UIUserInterfaceSizeClass, horizontal horizontalSizeClass: UIUserInterfaceSizeClass) -> [NSLayoutConstraint] {
    switch verticalSizeClass {
    case .compact:
      switch horizontalSizeClass {
      case .compact:
        return verticalCompactHorizontalCompactConstraints
      default:
        return verticalCompactHorizontalRegularConstraints
      }
    default:
      switch verticalSizeClass {
      case .compact:
        return verticalRegularHorizontalCompactConstraints
      default:
        return verticalRegularHorizontalRegularConstraints
      }
    }
    
  }
}

