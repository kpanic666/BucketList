//
//  MapUIView.swift
//  BucketList
//
//  Created by Andrei Korikov on 17.09.2021.
//

import SwiftUI
import MapKit

struct MapUIView: View {
  @State private var centerCoordinate = CLLocationCoordinate2D()
  @State private var selectedPlace: MKPointAnnotation?
  @State private var locations = [CodableMKPointAnnotation]()
  @State private var showingEditScreen = false
  @State private var showingPlaceDetails = false
  
  var body: some View {
    ZStack {
      MapView(centerCoordinate: $centerCoordinate, selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails, annotations: locations)
        .edgesIgnoringSafeArea(.all)
      
      Circle()
        .fill(Color.blue)
        .opacity(0.3)
        .frame(width: 32, height: 32)
      
      VStack {
        Spacer()
        HStack {
          Spacer()
          Button(action: {
            let newLocation = CodableMKPointAnnotation()
            newLocation.coordinate = centerCoordinate
            locations.append(newLocation)
            
            selectedPlace = newLocation
            showingEditScreen = true
          }) {
            Image(systemName: "plus")
              .padding()
              .background(Color.black.opacity(0.75))
              .foregroundColor(.white)
              .font(.title)
              .clipShape(Circle())
              .padding(.trailing)
          }
        }
      }
    }
    .onAppear(perform: loadData)
    .sheet(isPresented: $showingEditScreen, onDismiss: saveData) {
      if selectedPlace != nil {
        EditView(placemark: selectedPlace!)
      }
    }
    .alert(isPresented: $showingPlaceDetails) {
      Alert(title: Text(selectedPlace?.title ?? "Unknown"), message: Text(selectedPlace?.subtitle ?? "Missing place information"),
            primaryButton: .default(Text("OK")),
            secondaryButton: .default(Text("Edit")) {
              showingEditScreen = true
            })
    }
  }
  
  func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
  
  func loadData() {
    let filename = getDocumentsDirectory().appendingPathComponent("SavedPlaces")
    
    do {
      let data = try Data(contentsOf: filename)
      locations = try JSONDecoder().decode([CodableMKPointAnnotation].self, from: data)
    } catch {
      print("Unable to load saved data.")
    }
  }
  
  func saveData() {
    do {
      let filename = getDocumentsDirectory().appendingPathComponent("SavedPlaces")
      let data = try JSONEncoder().encode(locations)
      try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
    } catch {
      print("Unable to save data.")
    }
  }
}

struct MapUIView_Previews: PreviewProvider {
  static var previews: some View {
    MapUIView()
  }
}
