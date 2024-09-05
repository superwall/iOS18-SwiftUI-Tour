//
//  ColorBlendExample.swift
//  iOS18Tour
//
//  Created by Jordan Morgan on 9/5/24.
//

import SwiftUI

struct ColorBlendExample: View {
    @State private var colorOne: Color = .blue
    @State private var colorTwo: Color = .purple
    @State private var rhs: Double = 0.5
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Now, you can easily mix two `Color` types in SwiftUI.")
                    .readingTextStyle()
                GroupBox {
                    Text("Mixing \(accessibilityName: colorOne) with \(accessibilityName: colorTwo) by \(rhs)")
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    Color(colorOne.mix(with: colorTwo, by: rhs))
                        .frame(height: 16)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .padding(.bottom, 32)
                    Slider(value: $rhs, in: 0...1)
                }
                CalloutView(text: "By the way, we're showing those color names using a new accessibility API in iOS 18. Interpolate `accessibilityName: aColor` inside a `String` and it will give you a nice, human readable name for the color.")
                Text("As you can see, moving the slider to the left mixes the color closer to the first color. Going right? It brings it closer to the latter color. And, the slider value sets a fraction value controlling how much the resulting color is blended by. Here's what it looks like to make that rectangle above:")
                    .readingTextStyle()
                CodeView(code: """
                Color(colorOne.mix(with: colorTwo, by: rhs))
                    .frame(height: 16)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .padding(.bottom, 32)
                """)
                Text("This one is super easy to use! Just call `.mix(with:, by:)` (and optionally a color space too) to mix the caller with another `Color`. There's not much more to say about this one, happy mixing! And, as usual, they really fun in a `TimelineView` or any other animation:")
                    .readingTextStyle()
                TimelineView(.animation) { timeline in
                    let time = timeline.date.timeIntervalSince1970
                    let mix = (sin(time) + 1) / 2
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(colorOne.mix(with: colorTwo, by: mix))
                        .frame(width: 300, height: 300)
                }
                .padding(.bottom, 32)
                Group {
                    Text("If you're curious, here's how we made that:")
                        .readingTextStyle()
                    CodeView(code: """
                    TimelineView(.animation) { timeline in
                        let time = timeline.date.timeIntervalSince1970
                        let mix = (sin(time) + 1) / 2
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(colorOne.mix(with: colorTwo, by: mix))
                            .frame(width: 300, height: 300)
                    }
                    """)
                }
                DocButtonView(docURL: "https://developer.apple.com/documentation/SwiftUI/Color/mix(with:by:in:)")
            }
            .padding(.horizontal)
        }
        .navigationTitle("Color Blend Examples")
        .frame(maxWidth: 560)
    }
}

#Preview {
    ColorBlendExample()
}
