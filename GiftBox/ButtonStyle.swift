//
//  ButtonStyle.swift
//  GiftBox
//
//  Created by Lisa on 13.10.2022.
//

import Foundation
import SwiftUI

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Color("darkGray"))
            .fontWeight(.bold)
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .background(Color.white).opacity(0.8)
            .clipShape(Capsule())
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
