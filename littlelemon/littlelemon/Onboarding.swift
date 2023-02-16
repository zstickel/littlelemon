//
//  Onboarding.swift
//  littlelemon
//
//  Created by Zane Stickel on 2/5/23.
//

import SwiftUI
import CoreData

let kFirstName = "firstNameKey"
let kLastName = "lastNameKey"
let kEmail = "emailKey"
let kIsLoggedIn = "isLoggedIn"

struct Onboarding: View {
    @State var firstName = ""
    @State var lastName = ""
    @State var email = ""
    @State var isLoggedIn = false
    @State var isDataLoaded = false
    @State var inputError = false
    var body: some View {
        NavigationView{
            VStack(alignment: .leading){
                ZStack{
                    Color(red: 73/255, green: 94/255, blue: 87/255)
                    VStack(alignment: .leading){
                        Text("Little Lemon")
                            .font(.custom("Markazi Text", size:64))
                            .foregroundColor(Color(red: 244/255, green: 206/255, blue: 20/255))
                        Text("Chicago")
                            .font(.custom("Markazi Text", size:40))
                            .foregroundColor(Color.white)
                        Spacer()
                        HStack{
                            Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                                .font(.custom("Karla", size:18))
                                .foregroundColor(Color.white)
                            
                            Image("Hero image")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(15)
                                .frame(width: 160, height: 140)
                            
                        }
                        
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .padding([.leading, .trailing])
                }
                .frame(height: 300)
                NavigationLink(destination: Home(), isActive: $isLoggedIn){
                    EmptyView()
                }
                Group{
                    Text("First name*")
                        .padding(.top)
                    TextField("First Name", text: $firstName)
                        .textFieldStyle(.roundedBorder)
                    Text("Last name*")
                    TextField("Last Name", text: $lastName)
                        .textFieldStyle(.roundedBorder)
                    Text("Email*")
                    TextField("Email", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                }
                .padding([.leading, .trailing])
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
                        inputError = true
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding()
                Spacer()
            }
            .alert("Please ensure all fields are filled out to continue.", isPresented: $inputError) {
                        Button("OK", role: .cancel) { }
                    }
            .onAppear{
                if UserDefaults.standard.bool(forKey: kIsLoggedIn){
                    isLoggedIn = true
                }
            }
            .toolbar{
                ToolbarItemGroup(placement: .principal){
                    
                        Image("Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
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
