//
//  CustomModifiers.swift
//  iOS18Tour
//
//  Created by Jordan Morgan on 9/5/24.
//

import SwiftUI

struct ReadingTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(.title3, design: .default, weight: .regular))
            .foregroundStyle(Color(uiColor: .secondaryLabel))
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .padding(.vertical)
    }
}

extension View {
    func readingTextStyle() -> some View {
        modifier(ReadingTextStyle())
    }
}

