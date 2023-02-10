//
//  Onboarding.swift
//  littlelemon
//
//  Created by Zane Stickel on 2/5/23.
//

import SwiftUI

let kFirstName = "firstNameKey"
let kLastName = "lastNameKey"
let kEmail = "emailKey"
let kIsLoggedIn = "isLoggedIn"

struct Onboarding: View {
    @State var firstName = ""
    @State var lastName = ""
    @State var email = ""
    @State var isLoggedIn = false
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(destination: Home(), isActive: $isLoggedIn){
                    EmptyView()
                }
                TextField("First Name", text: $firstName)
                TextField("Last Name", text: $lastName)
                TextField("Email", text: $email)
                Button("Register"){
                    if !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && isEmailValid(emailString: email) {
                        print("All good entries")
                        UserDefaults.standard.set(firstName, forKey: kFirstName)
                        UserDefaults.standard.set(lastName, forKey: kLastName)
                        UserDefaults.standard.set(email, forKey: kEmail)
                        
                        UserDefaults.standard.set(true, forKey: kIsLoggedIn)
                        isLoggedIn = true
                        
                    }else{
                        print("Incomplete or bad form")
                    }
                }
            }
            .onAppear{
                if UserDefaults.standard.bool(forKey: kIsLoggedIn){
                    isLoggedIn = true
                }
            }
        }
    }
    func isEmailValid(emailString: String)-> Bool {
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        let regex = try? NSRegularExpression(pattern: emailRegEx)
        if let regex {
            let nsString = emailString as NSString
            let results = regex.matches(in: emailString, range: NSRange(location: 0 , length: nsString.length))
            if results.count == 0 {
                print("Bad email")
                return false
            }else{
                print("Good email")
                return true
            }
        }
        print("Bad regex")
        return false
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}
