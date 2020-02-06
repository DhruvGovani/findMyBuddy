//
//  MapView.swift
//  findMyBuddy
//
//  Created by Dhruv Govani on 01/02/20.
//  Copyright © 2020 Dhruv Govani. All rights reserved.
//


import SwiftUI
import MapKit
import Firebase

struct MapView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
        
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        
        var friendMailData : String = ""
        let db = Firestore.firestore()
        var lat: Double = 34.011286
        var long: Double = -116.166868
        let networkObj = NetworkingController()
        
        let ownRef = db.collection("users").document(networkObj.getProfile())
        
        ownRef.getDocument { (document, error) in
            
            if let document = document, document.exists{
                let friendMail = document.get("friend")
                friendMailData = friendMail as! String
                //print(friendMailData)
                
                let friendRef = db.collection("users").document(friendMailData)
                
                friendRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        if let coords = document.get("location"){
                        let point = coords as! GeoPoint
                            let latData = point.latitude
                            let longData = point.longitude
                            lat = latData
                            long = longData
                            
                            view.mapType = MKMapType.standard
                            let mylocation = CLLocationCoordinate2D(latitude: lat,longitude: long)
                            
                            let coordinate = CLLocationCoordinate2D(
                                latitude: lat, longitude: long)
                            let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
                            let region = MKCoordinateRegion(center: coordinate, span: span)
                            view.setRegion(region, animated: true)
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = mylocation

                            annotation.title = friendMailData
                            annotation.subtitle = "i am Here Buddy"
                            view.addAnnotation(annotation)
                        }
                    } else {
                        print("Please Enter Valid Friend mail!")
                        
                    }
                }
            }else{
                print("friend not found")
            }
            
        }
        
        
        
    }
}

struct MapView_Preview: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
