//
//  EditView.swift
//  BucketList
//
//  Created by Andrei Korikov on 15.09.2021.
//

import SwiftUI
import MapKit

struct EditView: View {
  @Environment(\.presentationMode) var presentationMode
  @ObservedObject var placemark: MKPointAnnotation
  
  var body: some View {
    NavigationView {
      Form {
        Section {
          TextField("Place name", text: $placemark.wrappedTitle)
          TextField("Description", text: $placemark.wrappedSubtitle)
        }
      }
      .navigationBarTitle("Edit place")
      .navigationBarItems(trailing: Button("Done") {
        presentationMode.wrappedValue.dismiss()
      })
    }
  }
}

struct EditView_Previews: PreviewProvider {
  static let testAnnotation = MKPointAnnotation()
  
  static var previews: some View {
    testAnnotation.title = "Test title"
    testAnnotation.subtitle = "Test subtitle"
    
    return EditView(placemark: testAnnotation)
  }
}
