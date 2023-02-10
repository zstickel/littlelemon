//
//  Home.swift
//  littlelemon
//
//  Created by Zane Stickel on 2/5/23.
//

import SwiftUI

struct Home: View {
    let persistence = PersistenceController.shared
    var body: some View {
        TabView{
            Menu()
                .environment(\.managedObjectContext, persistence.container.viewContext)
                .tabItem{
                    Label("Menu", systemImage: "list.dash")
                }
            UserProfile()
                .tabItem{
                    Label("Profile", systemImage: "square.and.pencil")
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
