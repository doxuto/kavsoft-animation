//
//  Message.swift
//  CustomTransitions
//
//  Created by Balaji on 09/07/22.
//

import SwiftUI

// MARK: Message Model
struct Message: Identifiable{
    var id: String = UUID().uuidString
    var message: String
    var isReply: Bool = false
    var emojiValue: String = ""
    var isEmojiAdded: Bool = false
}
