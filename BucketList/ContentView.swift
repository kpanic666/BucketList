//
//  ContentView.swift
//  BucketList
//
//  Created by Andrei Korikov on 14.09.2021.
//

import SwiftUI
import LocalAuthentication
import MapKit

struct ContentView: View {
  @State private var isUnlocked = false
  @State private var errorShow = false
  @State private var errorText = ""
  
  var body: some View {
    if isUnlocked {
      MapUIView()
    } else {
      Button("Unlock Places") {
        authenticate()
      }
      .padding()
      .background(Color.blue)
      .foregroundColor(.white)
      .clipShape(Capsule())
      .alert(isPresented: $errorShow) {
        Alert(title: Text("Error"), message: Text(errorText), dismissButton: .default(Text("OK")))
      }
    }
  }
  
  func authenticate() {
    let context = LAContext()
    var error: NSError?
    
    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
      let reason = "Please authenticate yourself to unlock your places."
      
      context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
        DispatchQueue.main.async {
          if success {
            isUnlocked = true
          } else {
            errorShow = true
            errorText = authenticationError?.localizedDescription ?? "Access failed."
          }
        }
      }
    } else {
      errorShow = true
      errorText = error?.localizedDescription ?? "Your device doesn't support biometrical ID."
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
