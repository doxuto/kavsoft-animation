//
//  ContentView.swift
//  ImageRenderer-PDF
//
//  Created by Balaji on 25/06/22.
//

import SwiftUI

struct ContentView: View {
    // MARK: Image/PDF Properties
    @State var generatedImage: Image?
    @State var generatedPDFURL: URL?
    @State var showShareLink: Bool = false
    var body: some View {
        GeometryReader{proxy in
            let size = proxy.size
            ZStack(alignment: .top) {
                // MARK: For Smaller Devices
                ViewThatFits {
                    ReceiptView()
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        ReceiptView()
                    }
                }
                
                // MARK: Actions
                HStack(spacing: 20){
                    Button {
                        
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3)
                    }

                    Spacer()
                    
                    // MARK: Share Link
                    if let generatedImage{
                        ShareLink(item: generatedImage, preview: SharePreview("Payment Recepit")) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.title3)
                        }
                    }
                    
                    // MARK: SwiftUI ShareLink Bug
                    // May be Cleared In Future
                    // Now For Demo Using UIKit ShareSheet
//                    if let generatedPDFURL{
//                        ShareLink(item: generatedPDFURL, preview: SharePreview("Payment Recepit")) {
//                            Image(systemName: "arrow.up.doc")
//                                .font(.title3)
//                        }
//                    }
                    
                    if let _ = generatedPDFURL{
                        Button {
                            showShareLink.toggle()
                        } label: {
                            Image(systemName: "arrow.up.doc")
                                .font(.title3)
                        }
                    }
                }
                .foregroundColor(.gray)
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .onAppear {
                // Render After the View is Loaded Properly
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    renderView(viewSize: size)
                }
            }
        }
        .sheet(isPresented: $showShareLink) {
            if let generatedPDFURL{
                ShareSheet(items: [generatedPDFURL])
            }
        }
    }
    
    // MARK: Generating Image Once
    // Since It's a Static Receipt View
    // Update Image/PDF URL Dynamically If You Have Updates on View
    @MainActor
    func renderView(viewSize: CGSize){
        // MARK: It's Not Fitting Properly
        // TIP: Pass View Width Here
        // Height Isn't Required Since It may be Scrollable
        let renderer = ImageRenderer(content: ReceiptView().frame(width: viewSize.width, alignment: .center))
        if let image = renderer.uiImage{
            generatedImage = Image(uiImage: image)
        }
        
        // MARK: Generating PDF
        let tempURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let renderURL = tempURL.appending(path: "\(UUID().uuidString).pdf")
        
        if let consumer = CGDataConsumer(url: renderURL as CFURL),let context = CGContext(consumer: consumer, mediaBox: nil, nil){
            renderer.render { size, renderer in
                var mediaBox = CGRect(origin: .zero, size: size)
                // MARK: Drawing PDF
                context.beginPage(mediaBox: &mediaBox)
                renderer(context)
                context.endPDFPage()
                context.closePDF()
                // MARK: Updating PDF URL
                generatedPDFURL = renderURL
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
