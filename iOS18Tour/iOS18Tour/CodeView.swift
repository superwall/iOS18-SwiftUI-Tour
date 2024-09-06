//
//  CodeView.swift
//  iOS18Tour
//
//  Created by Jordan Morgan on 9/5/24.
//

import SwiftUI
import HighlightSwift

@Observable
class CodeFontSize {
    var preferredSize: CGFloat = 14
}

struct CodeView: View {
    let code: String
    private let ceiling: CGFloat = 32
    private let floor: CGFloat = 8
    @Environment(CodeFontSize.self) private var fontSize
    @ScaledMetric(wrappedValue: 32, relativeTo: .body) private var scaledOffset: Double
    
    var body: some View {
        CodeText(code)
            .highlightLanguage(.swift)
            .codeTextColors(.theme(.xcode))
            .codeTextStyle(.card)
            .font(.system(size: fontSize.preferredSize))
            .frame(minWidth: 0, maxWidth: .infinity)
            .overlay(alignment: .bottom) {
                HStack {
                    Spacer()
                    Button("", systemImage: "plus.app.fill") {
                        adjustTextSize(increase: true)
                    }
                    .disabled(fontSize.preferredSize == ceiling)
                    Button("", systemImage: "minus.circle.fill") {
                        adjustTextSize(increase: false)
                    }
                    .disabled(fontSize.preferredSize == floor)
                }
                .symbolRenderingMode(.hierarchical)
                .sensoryFeedback(.selection, trigger: fontSize.preferredSize)
                .offset(y: scaledOffset)
            }
            .padding(.bottom, scaledOffset)
    }
    
    private func adjustTextSize(increase: Bool) {
        let sizeChange: CGFloat = 2
        let newSize = fontSize.preferredSize + (increase ? sizeChange : -sizeChange)
        
        guard isNewSizeWithinBounds(newSize) else { return }
        
        withAnimation(.smooth) {
            fontSize.preferredSize = newSize
        }
    }

    private func isNewSizeWithinBounds(_ size: CGFloat) -> Bool {
        return size >= floor && size <= ceiling
    }
}

#Preview {
    CodeView(code: """
    Image(.beachZoom)
        .resizable()
        .clipShape(.rect(cornerRadius: 8))
        .matchedTransitionSource(id: transitionID, in: imageNamespace)
        .onTapGesture {
            showImage.toggle()
        }
    """)
    .environment(CodeFontSize())
}
