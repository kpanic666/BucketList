//
//  MapView.swift
//  BucketList
//
//  Created by Andrei Korikov on 14.09.2021.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
  @Binding var centerCoordinate: CLLocationCoordinate2D
  @Binding var selectedPlace: MKPointAnnotation?
  @Binding var showingPlaceDetails: Bool
  
  var annotations: [MKPointAnnotation]
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  func makeUIView(context: Context) -> MKMapView {
    let mapView = MKMapView()
    mapView.delegate = context.coordinator
    return mapView
  }
  
  func updateUIView(_ uiView: MKMapView, context: Context) {
    if annotations.count != uiView.annotations.count {
      uiView.removeAnnotations(uiView.annotations)
      uiView.addAnnotations(annotations)
    }
  }
  
  typealias UIViewType = MKMapView
  
  class Coordinator: NSObject, MKMapViewDelegate {
    let parent: MapView
    
    init(_ parent: MapView) {
      self.parent = parent
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
      parent.centerCoordinate = mapView.centerCoordinate
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      // This is our unique identifier for view reuse
      let identifier = "Placemark"
      
      // Attempt to find a cell we can reuse
      var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
      
      if annotationView == nil {
        // we didn't find one; make a new one
        annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        
        // allow this to show pop up information
        annotationView?.canShowCallout = true
        
        // attach an information button to the view
        annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
      } else {
        // we have a view to reuse, so give it the new annotation
        annotationView?.annotation = annotation
      }
      
      return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
      guard let placemark = view.annotation as? MKPointAnnotation else {
        return
      }
      
      parent.selectedPlace = placemark
      parent.showingPlaceDetails = true
    }
  }
}
