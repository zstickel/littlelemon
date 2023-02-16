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
        NavigationView{
          
                VStack{
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
                            Spacer()
                            HStack{
                                Text(Image(systemName: "magnifyingglass"))
                                TextField("Search", text: $searchText)
                                
                            }
                            .background(.white.opacity(0.2))
                            .foregroundColor(.white)
                            .padding()
                            
                            
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .padding([.leading, .trailing])
                        
                    }
                    VStack{
                        Text("ORDER FOR DELIVERY!")
                            .font(.custom("Karla", size:20))
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                        HStack{
                            Button{
                                
                            } label:{
                                Text("Starters")
                                    .foregroundColor(Color(red: 73/255, green: 94/255, blue: 87/255))
                            }
                            .buttonStyle(.bordered)
                            Button{
                                
                            } label:{
                                Text("Mains")
                                    .foregroundColor(Color(red: 73/255, green: 94/255, blue: 87/255))
                            }
                            .buttonStyle(.bordered)
                            Button{
                                
                            } label:{
                                Text("Desserts")
                                    .foregroundColor(Color(red: 73/255, green: 94/255, blue: 87/255))
                            }
                            .buttonStyle(.bordered)
                            Button{
                                
                            } label:{
                                Text("Drinks")
                                    .foregroundColor(Color(red: 73/255, green: 94/255, blue: 87/255))
                            }
                            .buttonStyle(.bordered)
                        }
                        
                    }
                    FetchedObjects(predicate: buildPredicate(), sortDescriptors: buildSortDescriptors()) {(dishes: [Dish]) in
                        List{
                            ForEach(dishes, id:\.self.title){ dish in
                                Text(dish.title!)
                                    .bold()
                                HStack{
                                    VStack{
                                        let price = "$\(dish.price!)"
                                        Text(dish.about!)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text("")
                                        Text(price)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    
                                    let url = URL(string: dish.image!)
                                    AsyncImage(url: url,  transaction: Transaction(animation: .easeIn(duration: 0.5))){  phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        case .failure:
                                            switch dish.title{
                                            case "Greek Salad":
                                                Image("greekSalad")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                
                                            case "Lemon Desert":
                                                Image("lemmonDessert")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                
                                            case "Bruschetta":
                                                Image("bruschetta")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                
                                            case "Pasta":
                                                Image("pasta")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                
                                            case "Grilled Fish":
                                                Image("grilledFish")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                
                                            default:
                                                HStack{
                                                    Text("Unknown Error")
                                                    Image(systemName: "xmark.octagon")
                                                }.foregroundColor(.red)
                                            }
                                        default:
                                            ZStack{
                                                
                                                Color.gray
                                                Text("Loading...")
                                                    .foregroundColor(.blue)
                                            }
                                        }
                                        
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
                .padding(.top)
                .toolbar{
                    ToolbarItemGroup(placement: .navigation){
                        
                        HStack{
                            Image("")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            Spacer()
                            Image("Logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            
                            Spacer()
                            Image("Profile")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                        }
                    }
                }
            }
          //  .navigationBarTitleDisplayMode(.large)
        
    }
    func getMenuData(){
        let urlString = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        let url = URL(string: urlString)!
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest){data, response, error in
            if let data {
               
                let fullMenu = try? JSONDecoder().decode(MenuList.self, from: data)
                if let fullMenu {
                    for item in fullMenu.menu {
                        if !isAlreadyInDatabase(title: item.title, context: viewContext){
                            print("Adding dish not already there")
                            var dish = Dish(context: viewContext)
                            dish.about = item.description
                            dish.title = item.title
                            dish.image = item.image
                            dish.price = item.price
                        }
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
    func isAlreadyInDatabase(title: String, context: NSManagedObjectContext)->Bool {
        let request: NSFetchRequest<Dish> = Dish.fetchRequest()
        print(title)
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", title)
        do{
            let numberOfRecords = try context.count(for: request)
            print("Number of records in database: \(numberOfRecords)")
            if numberOfRecords == 0 {
                return false
            }else{
                return true
            }
        }catch{
            return true
        }
    }
    func getImageAlternative(urlString: String) async-> UIImage {
        let url = URL(string: urlString)
        do {
            let (data, _) = try await URLSession.shared.data(from: url!)
            let image = UIImage(data: data)!
            return image
        }catch{
            return UIImage(systemName: "xmark.octagon")!
        }
       
    }
 
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}
