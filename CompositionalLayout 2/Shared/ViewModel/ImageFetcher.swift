//
//  ImageFetcher.swift
//  CompositionalLayout (iOS)
//
//  Created by Balaji on 23/04/22.
//

import SwiftUI

class ImageFetcher: ObservableObject {
    @Published var fetchedImages: [ImageModel]?
    
    // MARK: Pagination Properties
    @Published var currentPage: Int = 0
    @Published var startPagination: Bool = false
    @Published var endPagination: Bool = false
    
    init(){updateImages()}
    
    func updateImages(){
        currentPage += 1
        Task{
            do{
                try await fetchImages()
            }catch{
                // HANDLE ERROR
            }
        }
    }
    
    // MARK: Image JSON Fetching
    func fetchImages()async throws{
        guard let url = URL(string: "https://picsum.photos/v2/list?page=\(currentPage)&limit=30") else{return}
        let response = try await URLSession.shared.data(from: url)
        // MARK: Reducing Image Size
        // API Call Supports Image Sizing
        let images = try JSONDecoder().decode([ImageModel].self, from: response.0).compactMap({ item -> ImageModel? in
            let imageID = item.id
            let SizedURL = "https://picsum.photos/id/\(imageID)/500/500"
            return .init(id: imageID, download_url: SizedURL)
        })
        await MainActor.run(body: {
            if fetchedImages == nil{fetchedImages = []}
            fetchedImages?.append(contentsOf: images)
            // MARK: Limiting to 100 Images
            endPagination = (fetchedImages?.count ?? 0) > 100
            startPagination = false
        })
    }
}
