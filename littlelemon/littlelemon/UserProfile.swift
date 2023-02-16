//
//  UserProfile.swift
//  littlelemon
//
//  Created by Zane Stickel on 2/6/23.
//

import SwiftUI

struct UserProfile: View {
    let firstName = UserDefaults.standard.string(forKey: kFirstName)
    let lastName = UserDefaults.standard.string(forKey: kLastName)
    let email = UserDefaults.standard.string(forKey: kEmail)
    @Environment(\.presentationMode) var presentation
    @State var orderStatuses = false
    @State var passwordChanges = false
    @State var specialOffers = false
    @State var newsletter = false
    var body: some View {
        VStack(alignment: .leading){
            Text("Personal information")
                .font(.title3)
                .padding(.leading)
            Text("Avatar")
                .padding(.leading)
            HStack{
                Image("Profile")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                Button("Change"){
                    
                }
                .buttonStyle(.borderedProminent)
                Button("Remove"){
                    
                }
                .buttonStyle(.borderedProminent)
            }
            List{
                Section(header: Text("First name")){
                    Text(firstName ?? "")
                }
                Section(header: Text("Last name")){
                    Text(lastName ?? "")
                }
                Section(header: Text("Email")){
                    Text(email ?? "")
                }
            }
            Group{
                Text("Email notifications")
                    .font(.title3)
                Toggle("Order statuses", isOn: $orderStatuses)
                    .toggleStyle(.switch)
                    .frame(width: 220)
                Toggle("Password changes", isOn: $passwordChanges)
                    .toggleStyle(.switch)
                    .frame(width: 220)
                Toggle("Special Offers", isOn: $specialOffers)
                    .toggleStyle(.switch)
                    .frame(width: 220)
                Toggle("Newsletter", isOn: $newsletter)
                    .toggleStyle(.switch)
                    .frame(width: 220)
            }
            .padding(.leading)
           
            Spacer()
        
            Button("Logout"){
                UserDefaults.standard.set(false, forKey: kIsLoggedIn)
                self.presentation.wrappedValue.dismiss()
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Color(red: 244/255, green: 206/255, blue: 20/255))
            .padding([.leading,.trailing], 5)
            .foregroundColor(.black)
            .cornerRadius(20)
            
            Spacer()
        }
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile()
    }
}
