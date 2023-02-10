//
//  Menu.swift
//  littlelemon
//
//  Created by Zane Stickel on 2/5/23.
//

import SwiftUI
import CoreData

struct Menu: View {
    @Environment(\.managedObjectContext)private var viewContext
    @State var searchText = ""
    var body: some View {
        VStack{
            Text("Little Lemon")
            Text("Chicago")
            Text("Little Lemon Restaurant Reservation and Orders Application")
            TextField("Search menu", text: $searchText)
            FetchedObjects(predicate: buildPredicate(), sortDescriptors: buildSortDescriptors()) {(dishes: [Dish]) in
                List{
                    ForEach(dishes){ dish in
                        HStack{
                            var displayString = dish.title! + " " + dish.price!
                            Text(displayString)
                            let url = URL(string: dish.image!)
                            AsyncImage(url: url){ image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                            }placeholder:{
                                Color.gray
                            }
                            .frame(width: 100, height: 100)
                        }
                    }
                }
                
            }
                
        }
        .onAppear{
       
            getMenuData()
        }
    }
    func getMenuData(){
        PersistenceController.shared.clear()
        let urlString = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        let url = URL(string: urlString)!
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest){data, response, error in
            if let data {
               
                let fullMenu = try? JSONDecoder().decode(MenuList.self, from: data)
                if let fullMenu {
                    for item in fullMenu.menu {
                        var dish = Dish(context: viewContext)
                        dish.title = item.title
                        dish.image = item.image
                        dish.price = item.price
                    }
                    try? viewContext.save()
                }
            }
        }
        task.resume()
    }
    func buildSortDescriptors()-> [NSSortDescriptor] {
        
        return [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))]
    }
    func buildPredicate() -> NSPredicate {
        if searchText.isEmpty {
            return NSPredicate(value: true)
        }else{
            return NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        }
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}
