//
//  LogInView.swift
//  findMyBuddy
//
//  Created by Dhruv Govani on 28/01/20.
//  Copyright © 2020 Dhruv Govani. All rights reserved.
//

import SwiftUI
import Firebase
import CoreLocation
import MapKit


struct LogInView: View {
    @State var tag : Int? = nil
    @State var hideEmptyView = false
    @State private var email = ""
    @State private var password = ""
    @State private var showErrorAlert = false
    @State var errorData : String = ""
    @State var blankFieldError : String = "All fields are required ! "
    @State var isFieldsBlank : Int? = nil
    @State var resetPassword = false
    var NetworkObject = NetworkingController()

    var body: some View {
        NavigationView{
            
            Form{
                TextField("Email", text: $email)
                SecureField("Password", text: $password)
                Button("Log In", action: {
                    
                    if self.email == "" || self.password == ""{
                        self.isFieldsBlank = 1
                    }
                    
                    Auth.auth().signIn(withEmail: self.email, password: self.password, completion: { (user, error) in
                        if error == nil {
                            self.tag = 1
                            print("success")
                        }else{
                            if self.isFieldsBlank == 1{
                            self.errorData = "All Fields Are required " + error!.localizedDescription
                            self.showErrorAlert = true
                                self.isFieldsBlank = 0
                            }else{
                                self.errorData = error!.localizedDescription
                                self.showErrorAlert = true
                            }
                        }
                    })
                    }
                ).frame(minWidth: 0, maxWidth: .infinity, minHeight:50)
                        .foregroundColor(.white)
                        .background(Color.blue)
                    .cornerRadius(70)
               
                
                Button("Signup", action: {
                    
                    
                    
                    if self.email == "" || self.password == ""{
                        self.isFieldsBlank = 1
                    }
                    
                    Auth.auth().createUser(withEmail: self.email, password: self.password) { authResult, error in
                    if error == nil{
                        print("No error")
                        let latData : Double = (locationHandler().locationManager.location?.coordinate.latitude)!
                        let longData : Double = (locationHandler().locationManager.location?.coordinate.longitude)!
                        
                        print("latdata = \(latData) long = \(longData)")
                        self.NetworkObject.addData(email: self.email.lowercased(), lat: latData, long: longData)
                        
                        self.tag = 1
                    }else{
                        if self.isFieldsBlank == 1{
                        self.errorData = "All Fields Are required " + error!.localizedDescription
                        self.showErrorAlert = true
                            self.isFieldsBlank = 0
                        }else{
                            self.errorData = error!.localizedDescription
                            self.showErrorAlert = true
                        }
                    }
                    }
                    
                }).frame(minWidth: 0, maxWidth: .infinity, minHeight:50)
                    .foregroundColor(.white)
                    .background(Color.blue)
                .cornerRadius(70)
                
                Button("Forgot Password?", action: {
                    self.resetPassword.toggle()
                               }).padding(.leading, 208.0).foregroundColor(.red)
                
                NavigationLink(destination: HomeView(), tag: 1, selection: $tag) {
                    blankView().padding(.leading, 99.0)
                }.disabled(true).alert(isPresented: $showErrorAlert) {
                Alert(title: Text("Error"), message: Text(" \(errorData)"), dismissButton: .destructive(Text("Got it!")))
            }
                }
        }.sheet(isPresented: $resetPassword) {
            forgotPassword()
            
        }
            .onAppear(perform: {
            let user = Auth.auth().currentUser
            if let user = user {

              let mail = user.email
                print(mail! + " is logged in")
                self.tag = 1
                
            }else{
                self.tag = 0
            }
      }
        )
        
    }
}


struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}

class locationHandler: NSObject ,CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var logViewObj = LogInView()
    var lattitude : Double = 0
    var longtitude : Double = 0
    
    override init() {
        
        super.init()
        
        
        print("location handler initiated!")
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        guard let locationValue : CLLocationCoordinate2D = manager.location?.coordinate else{
            return
        }
        //print("\(locationValue.latitude) and \(locationValue.longitude)")
        
        lattitude = locationValue.latitude
        longtitude = locationValue.longitude
        
        //print("this is from global var \(lattitude) and \(lattitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did location updates is called but failed getting location \(error)")
    }
    
    
    
    
    
}

