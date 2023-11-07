//
//  Message.swift
//  LinkPreviewSwiftUI (iOS)
//
//  Created by Balaji on 05/12/21.
//

import SwiftUI
import LinkPresentation

// Message Model...
struct Message: Identifiable {
    var id = UUID().uuidString
    // Message...
    var messageString: String
    var date: Date = Date()
    // Link Preview Data...
    // Preview Loading...
    var previewLoading: Bool = false
    // Meta Data...
    var linkMetaData: LPLinkMetadata?
    // URL...
    var linkURL: URL?
}
