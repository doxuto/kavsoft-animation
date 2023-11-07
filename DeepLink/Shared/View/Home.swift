//
//  Home.swift
//  DeepLink (iOS)
//
//  Created by Balaji on 14/12/21.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var appData: AppDataModel
    var body: some View {
        
        TabView(selection: $appData.currentTab) {
            
            Text("Home")
                .tag(Tab.home)
                .tabItem {
                    Image(systemName: "house.fill")
                }
            
            SearchView()
                .environmentObject(appData)
                .tag(Tab.search)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
            
            Text("Settings")
                .tag(Tab.settings)
                .tabItem {
                    Image(systemName: "gearshape.fill")
                }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

// Search View...
struct SearchView: View{
    @EnvironmentObject var appData: AppDataModel
    
    var body: some View{
        
        NavigationView{
            
            List{
                
                // List of available coffees...
                ForEach(coffees){coffee in
                    
                    // Setting tag and selection so that when ever we update selection
                    // that navigation link will be called....
                    NavigationLink(tag: coffee.id,selection: $appData.currentDetailPage){
                        DetailView(coffee: coffee)
                    } label: {
                     
                        HStack(spacing: 15){
                            
                            Image(coffee.productImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .cornerRadius(15)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                
                                Text(coffee.title)
                                    .font(.body.bold())
                                    .foregroundColor(.primary)
                                
                                Text(coffee.productPrice)
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Search")
        }
    }
    
    // Detail View...
    @ViewBuilder
    func DetailView(coffee: Coffee)->some View{
        
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack{
                
                Image(coffee.productImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: 280)
                    .cornerRadius(1)
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text(coffee.title)
                        .font(.title.bold())
                        .foregroundColor(.primary)
                    
                    Text(coffee.productPrice)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                    
                    Text(coffee.description)
                        .multilineTextAlignment(.leading)
                }
                .padding()
            }
        }
        .navigationTitle(coffee.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
