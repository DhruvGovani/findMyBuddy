//
//  forgotPassword.swift
//  findMyBuddy
//
//  Created by Dhruv Govani on 05/02/20.
//  Copyright © 2020 Dhruv Govani. All rights reserved.
//

import SwiftUI
import Firebase

struct forgotPassword: View {
    @State var mail : String = ""
    @State var showMessage : Int? = nil
    var body: some View {
        VStack{
            Text("Forgot Password").font(.title)
            TextField("Email", text: $mail).textFieldStyle(RoundedBorderTextFieldStyle()).frame(width: 300, height: 10).padding()

            Button("Forgot Password", action: {
                
                Auth.auth().sendPasswordReset(withEmail: self.mail) { error in
                    
                    if error != nil {
                        self.showMessage = 0
                    }else{
                        self.showMessage = 1
                    }
                  
                }
            }).frame(minWidth: 0, maxWidth: .infinity, minHeight:50)
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(70).padding()
            
            if showMessage == 1{
                Text("Email Reset Link has been sent").foregroundColor(.red).font(.caption)
            }
            if showMessage == 0{
                Text("Enter Valid Email").foregroundColor(.red).font(.caption)
            }
            
            
        }
    }
}

struct forgotPassword_Previews: PreviewProvider {
    static var previews: some View {
        forgotPassword()
    }
}
