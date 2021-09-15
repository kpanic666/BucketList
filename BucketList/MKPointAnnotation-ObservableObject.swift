//
//  MKPointAnnotation-ObservableObject.swift
//  BucketList
//
//  Created by Andrei Korikov on 15.09.2021.
//

import MapKit

extension MKPointAnnotation: ObservableObject {
  public var wrappedTitle: String {
    get {
      self.title ?? "Unknown value"
    }
    
    set {
      title = newValue
    }
  }
  
  public var wrappedSubtitle: String {
    get {
      self.subtitle ?? "Unknown value"
    }
    
    set {
      subtitle = newValue
    }
  }
}
