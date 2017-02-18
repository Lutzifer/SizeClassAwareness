//
//  Lifting.swift
//  TraitAwareVC-Demo
//
//  Created by Wolfgang Lutz on 18.02.17.
//  Copyright © 2017 Wolfgang Lutz. All rights reserved.
//

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

