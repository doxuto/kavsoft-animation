//
//  Home.swift
//  Tagging (iOS)
//
//  Created by Balaji on 07/10/21.
//

import SwiftUI

struct Home: View {
    
    @State var text: String = ""
    
    // Tags..
    @State var tags: [Tag] = []
    @State var showAlert: Bool = false
    
    var body: some View {
        
        VStack{
            
            Text("Filter \nMenus")
                .font(.system(size: 38, weight: .bold))
                .foregroundColor(Color("Tag"))
                .frame(maxWidth: .infinity,alignment: .leading)
            
            // Custom Tag View...
            TagView(maxLimit: 150, tags: $tags,fontSize: 16)
            // Default Height...
                .frame(height: 280)
                .padding(.top,20)
            
            // TextField...
            TextField("apple", text: $text)
                .font(.title3)
                .padding(.vertical,10)
                .padding(.horizontal)
                .background(
                
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color("Tag").opacity(0.2),lineWidth: 1)
                )
            // Setting only Textfield as Dark..
                .environment(\.colorScheme, .dark)
                .padding(.vertical,18)
            
            // Add Button..
            Button {
                
                // Use same Font size and limit here used in TagView....
                addTag(tags: tags, text: text, fontSize: 16, maxLimit: 150) { alert, tag in
                    
                    if alert{
                        // Showing alert...
                        showAlert.toggle()
                    }
                    else{
                        // adding Tag...
                        tags.append(tag)
                        text = ""
                    }
                }
                
            } label: {
                Text("Add Tag")
                    .fontWeight(.semibold)
                    .foregroundColor(Color("BG"))
                    .padding(.vertical,12)
                    .padding(.horizontal,45)
                    .background(Color("Tag"))
                    .cornerRadius(10)
            }
            // Disabling Button...
            .disabled(text == "")
            .opacity(text == "" ? 0.6 : 1)

        }
        .padding(15)
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)
        .background(
        
            Color("BG")
                .ignoresSafeArea()
        )
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text("Tag Limit Exceeded  try to delete some tags !!!"), dismissButton: .destructive(Text("Ok")))
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
