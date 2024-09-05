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
                        toggleText(larger: true)
                    }
                    Button("", systemImage: "minus.circle.fill") {
                        toggleText(larger: false)
                    }
                }
                .symbolRenderingMode(.hierarchical)
                .sensoryFeedback(.selection, trigger: fontSize.preferredSize)
                .offset(y: scaledOffset)
            }
            .padding(.bottom, scaledOffset)
    }
    
    private func toggleText(larger: Bool) {
        let ceiling: CGFloat = 30
        let floor: CGFloat = 14
        var newSize = fontSize.preferredSize
        
        if larger {
            if newSize >= ceiling {
                newSize = floor
            } else {
                newSize += 2
            }
        } else {
            if newSize <= floor {
                newSize = ceiling
            } else {
                newSize -= 2
            }
        }
        
        withAnimation(.smooth) {
            fontSize.preferredSize = newSize
        }
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
