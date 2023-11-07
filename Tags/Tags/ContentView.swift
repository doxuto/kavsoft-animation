//
//  ContentView.swift
//  Tags
//
//  Created by Balaji on 08/06/22.
//

import SwiftUI

struct ContentView: View {
    @State var tags: [Tag] = rawTags.compactMap { tag -> Tag? in
        return .init(name: tag)
    }
    // MARK: Segment Value
    @State var alignmentValue: Int = 1
    // MARK: Text Value
    @State var text: String = ""
    var body: some View {
        NavigationStack{
            VStack{
                Picker("", selection: $alignmentValue) {
                    Text("Leading")
                        .tag(0)
                    Text("Center")
                        .tag(1)
                    Text("Trailing")
                        .tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.bottom,20)
                TagView(alignment: alignmentValue == 0 ? .leading : alignmentValue == 1 ? .center : .trailing, spacing: 10){
                    ForEach($tags) { $tag in
                        // MARK: New Toggle API
                        Toggle(tag.name, isOn: $tag.isSelected)
                            .toggleStyle(.button)
                            .buttonStyle(.bordered)
                            .tint(tag.isSelected ? .red : .gray)
                    }
                }
                .animation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6), value: alignmentValue)
                
                HStack{
                    // MARK: New API
                    // Multi Line TextField
                    TextField("Tag", text: $text,axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                    // Line Limit
                    // If It Exceeds Then It will Enable ScrollView
                        .lineLimit(1...5)
                    
                    Button("Add"){
                        withAnimation(.spring()){
                            tags.append(Tag(name: text))
                            text = ""
                        }
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.roundedRectangle(radius: 4))
                    .tint(.red)
                    .disabled(text == "")
                }
            }
            .padding(15)
            .navigationTitle(Text("Layout"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: Building Custom Layout With The New Layout API
struct TagView: Layout{
    var alignment: Alignment = .center
    var spacing: CGFloat = 10
    // New Xcode Will Type All Init By Default
    // Simply Type init
    init(alignment: Alignment, spacing: CGFloat) {
        self.alignment = alignment
        self.spacing = spacing
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        // Returning Default Proposal Size
        return .init(width: proposal.width ?? 0, height: proposal.height ?? 0)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        // MARK: Placing View
        // I'm Going to Build it in Two Ways
        // One is Simple Without Customisation
        // Another One With Customisation
        
        // Note Use Origin
        // Since Origin Will Start From Applied Padding From Parent View
        var origin = bounds.origin
        let maxWidth = bounds.width
        
        // MARK: Type 2
        var row: ([LayoutSubviews.Element],Double) = ([],0.0)
        var rows: [([LayoutSubviews.Element],Double)] = []
        
        for view in subviews{
            let viewSize = view.sizeThatFits(proposal)
            if (origin.x + viewSize.width + spacing) > maxWidth{
                // This Will Give How Much Space Remaining In a Row
                row.1 = (bounds.maxX - origin.x + bounds.minX + spacing)
                rows.append(row)
                row.0.removeAll()
                // Resetting Horizontal Axis
                origin.x = bounds.origin.x
                // Next View
                row.0.append(view)
                origin.x += (viewSize.width + spacing)
            }else{
                row.0.append(view)
                origin.x += (viewSize.width + spacing)
            }
        }
        
        // MARK: Exhaust Ones
        if !row.0.isEmpty{
            row.1 = (bounds.maxX - origin.x + bounds.minX + spacing)
            rows.append(row)
        }
        
        // MARK: Resetting Origin
        origin = bounds.origin
        
        for row in rows {
            // Resetting X Origin For New Row
            origin.x = (alignment == .leading ? bounds.minX : (alignment == .trailing ? row.1 : row.1 / 2))
            for view in row.0{
                let viewSize = view.sizeThatFits(proposal)
                view.place(at: origin, proposal: proposal)
                origin.x += (viewSize.width + spacing)
            }
            // Max Height In the Row
            let maxHeight = row.0.compactMap { view -> CGFloat? in
                return view.sizeThatFits(proposal).height
            }.max() ?? 0
            // Updating Vertical Origin
            origin.y += (maxHeight + spacing)
        }
        
        // MARK: Type 1
//        subviews.forEach { view in
//            let viewSize = view.sizeThatFits(proposal)
//            // Checking If View is Going Over MaxWidth
//            if (origin.x + viewSize.width + spacing) > maxWidth{
//                // Updating Origin For Next Element In Vertical Order
//                origin.y += (viewSize.height + spacing)
//                // Resetting Horizontal Axis
//                origin.x = bounds.origin.x
//                // Next View
//                view.place(at: origin, proposal: proposal)
//                // Updating Origin For Next View Placement
//                // Adding Spacing
//                origin.x += (viewSize.width + spacing)
//            }else{
//                view.place(at: origin, proposal: proposal)
//                // Updating Origin For Next View Placement
//                // Adding Spacing
//                origin.x += (viewSize.width + spacing)
//            }
//        }
    }
}

// MARK: String Tags
var rawTags: [String] = [
    "SwiftUI","Xcode","Apple","WWDC 22","iOS 16","iPadOS 16","macOS 13","watchOS 9","Xcode 14","API's"
]

// MARK: Tag Model
struct Tag: Identifiable{
    var id = UUID().uuidString
    var name: String
    var isSelected: Bool = false
}
