//
//  Array+RemoveObjects.swift
//  TraitAwareVC-Demo
//
//  Created by Wolfgang Lutz on 18.02.17.
//  Copyright © 2017 Wolfgang Lutz. All rights reserved.
//

import Foundation

// Swift 2 Array Extension
// http://supereasyapps.com/blog/2015/9/22/how-to-remove-an-array-of-objects-from-a-swift-2-array-removeobjectsinarray
extension Array where Element: Equatable {
  mutating func removeObject(object: Element) {
    if let index = self.index(of: object) {
      self.remove(at: index)
    }
  }
  
  mutating func removeObjectsInArray(array: [Element]) {
    for object in array {
      self.removeObject(object: object)
    }
  }
}
