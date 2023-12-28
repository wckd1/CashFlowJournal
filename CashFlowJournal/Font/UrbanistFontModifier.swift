//
//  UrbanistFontModifier.swift
//  ConversAI
//
//  Created by Murat ÖZTÜRK on 3.06.2023.
//

import SwiftUI

enum UrbanistFontType: String {
    case black = "urbanis-black"
    case bold = "urbanist-bold"
    case extra_bold = "UrbanistExtraBold"
    case extra_light = "urbanist-extra-light"
    case italic = "urbanist-italic"
    case light = "urbanist-light"
    case medium = "urbanist-medium"
    case regular = "urbanist-regular"
    case semi_bold = "Urbanist-SemiBold"
    case thin = "urbanist-thin"
}

struct UrbanistFont: ViewModifier {
    
    var type: UrbanistFontType
    var size: CGFloat
    
    init(_ type: UrbanistFontType = .regular, size: CGFloat = 16) {
        self.type = type
        self.size = size
    }
    
    func body(content: Content) -> some View {
        content.font(Font.custom(type.rawValue, size: size))
    }
}


