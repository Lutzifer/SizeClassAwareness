//
//  SizeClassPair.swift
//  TraitAwareVC-Demo
//
//  Created by Wolfgang Lutz on 18.02.17.
//  Copyright © 2017 Wolfgang Lutz. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC

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
