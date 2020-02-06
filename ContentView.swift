//
//  ContentView.swift
//  findMyBuddy
//
//  Created by Dhruv Govani on 28/01/20.
//  Copyright © 2020 Dhruv Govani. All rights reserved.
//

import SwiftUI
import Firebase


struct ContentView: View {
    @State var tag :Int? = nil
    var NetworkObj = NetworkingController()
    
    var locationobj = locationHandler()
    var body: some View {
        LogInView().onAppear {
            let db = Firestore.firestore()
            
            print(self.locationobj.lattitude)
            Timer.scheduledTimer(withTimeInterval: 600, repeats: true) { timer in
               
                let lat = self.locationobj.lattitude
                let long = self.locationobj.longtitude
                
                var email : String = ""
                let user = Auth.auth().currentUser
                if let user = user {
                    
                    email = user.email!
                    db.collection("users").document(email).updateData([
                        
                        "location" : GeoPoint(latitude: lat, longitude: long)
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                }else{
                    print("user is not logged in so we cant post the locations")
                }
            }
        }
        
}
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func hey() {
    print("hey")
}
