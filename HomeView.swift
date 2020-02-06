//
//  HomeView.swift
//  findMyBuddy
//
//  Created by Dhruv Govani on 28/01/20.
//  Copyright © 2020 Dhruv Govani. All rights reserved.
//

import SwiftUI
import Firebase



struct HomeView: View {
    
    @State var TrackMail: String = ""
    var networkObj = NetworkingController()
    @State var emailData: String = NetworkingController().getProfile()
    @State var openMap : Int? = nil
    var body: some View {
        NavigationView{
            VStack{
                Text("Welcome \(emailData),")
                TextField("Email",text: $TrackMail).textFieldStyle(RoundedBorderTextFieldStyle()).frame(width: 300, height: 10).padding()
                
                Button("Add Friend", action: {
                    self.networkObj.addFriend(Femail: self.TrackMail)
                    }).frame(minWidth: 0, maxWidth: .infinity, minHeight:50)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(70).padding()
                    
                
                Button("Track Friend", action: {
                    print("Track Tapped")
                    self.openMap = 1
                }).frame(minWidth: 0, maxWidth: .infinity, minHeight:50)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(70).padding()
                
                NavigationLink(destination: MapView().edgesIgnoringSafeArea(.all), tag: 1, selection: $openMap){
                    EmptyView()
                }
                
                
            Spacer()
                if openMap == 2{
                    Text("You are logged out of FindMyBuddy Please Close and Reopen App to procced").padding().foregroundColor(.red).font(.caption)
                }
                    Button("Log out", action: {
                        let firebaseAuth = Auth.auth()
                        do {
                            self.openMap = 2
                          try firebaseAuth.signOut()
                        } catch let signOutError as NSError {
                          print ("Error signing out: %@", signOutError)
                        }
                        
                    })
                
                
            } }.navigationBarBackButtonHidden(true).navigationBarHidden(true).navigationBarTitle("Home")
            }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


