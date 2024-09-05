//
//  MeshGradientExample.swift
//  iOS18Tour
//
//  Created by Jordan Morgan on 9/5/24.
//

import SwiftUI

struct MeshGradientExample: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("If you like making the pretty gradient type of backgrounds that Apple is known for, then look no further than `MeshGradient`. The `MeshGradient` isn't a `View`, but rather a `ShapeStyle`. That means it's ideal to use for a fill, especially in a `Shape`.\n\nTake this simple `Rectangle`, for example:")
                    .readingTextStyle()
                Rectangle()
                    .fill(Color.secondary)
                    .clipShape(.rect(cornerRadius: 16))
                    .frame(width: 300, height: 300)
                Text("Currently, it uses a simple `Color` to fill it:")
                    .readingTextStyle()
                CodeView(code: """
                Rectangle()
                    .fill(Color.secondary)
                    .clipShape(.rect(cornerRadius: 16))
                    .frame(width: 300, height: 300)
                """)
                Text("Instead, let's change it over to a `MeshGradient` and see how it looks:")
                    .readingTextStyle()
                meshRectangle
                Text("That's a lot more fun!\n\nMaking a mesh gradient can seem daunting at first, but it's fairly simple in practice. Like the WWDC sesion mentions, you're essentially displaying (or, as we'll see, animating) over a grid of colors. That's it!")
                    .readingTextStyle()
                Group {
                    CodeView(code: """
                    MeshGradient(width: 3, height: 3, points: [
                        .init(0, 0), .init(0.5, 0), .init(1, 0),
                        .init(0, 0.5), .init(0.5, 0.5), .init(1, 0.5),
                        .init(0, 1), .init(0.5, 1), .init(1, 1)
                    ], colors: [
                        .cyan, .cyan, .brown,
                        .gray, .pink, .blue,
                        .teal, .black, .orange
                    ])
                    """)
                    Text("Now, things start to make more sense. Since we specified a `width` and `height` of 3, I've found it helps to do some simple math. 3 times 3 is nine, so here I'd use nine total points on a 3x3 grid:")
                        .readingTextStyle()
                    CodeView(code: """
                    // In the initializer for `points`...
                    .init(0, 0), .init(0.5, 0), .init(1, 0),
                    .init(0, 0.5), .init(0.5, 0.5), .init(1, 0.5),
                    .init(0, 1), .init(0.5, 1), .init(1, 1)
                    """)
                    CalloutView(text: "Even though we're using `.init(x:, y:)` in our examples, you can also use inline Array syntax like this: `[0, 1]`.")
                    Text("Then, I follow the same setup for `colors`:")
                        .readingTextStyle()
                    CodeView(code: """
                    // In the initializer for `points`...
                    .cyan, .cyan, .brown,
                    .gray, .pink, .blue,
                    .teal, .black, .orange
                    """)
                    Text("And that's how we arrived at the `MeshGradient` above. Here's the full code for the `Rectangle`:")
                        .readingTextStyle()
                    CodeView(code: """
                    Rectangle()
                       .fill(
                           MeshGradient(width: 3, height: 3, points: [
                               .init(0, 0), .init(0.5, 0), .init(1, 0),
                               .init(0, 0.5), .init(0.5, 0.5), .init(1, 0.5),
                               .init(0, 1), .init(0.5, 1), .init(1, 1)
                           ], colors: [
                               .cyan, .cyan, .brown,
                               .gray, .pink, .blue,
                               .teal, .black, .orange
                           ])
                       )
                       .frame(width: 300, height: 300)
                    """)
                    Text("So TL;DR: `MeshGradient` is a way to create smooth, organic gradients that blend colors together using points. You might've used a linear or radial gradient in design apps like Sketch or Figma, and they tend to have more predictable directions and shapes.\n\nBut, with a mesh gradient, you define the colors at different positions and then blend them in a more fluid way across the entire surface.")
                        .readingTextStyle()
                    Text("What's even more fun is animating them! Stick one inside a `TimelineView` and you can make a Lava-lamp style animation — just be sure to animate it from the middle point so that it looks like a blob slowly moving around. Here's an example:")
                        .readingTextStyle()
                    TimelineView(.animation) { timeline in
                        let time = timeline.date.timeIntervalSince1970
                        let x = (sin(time) * cos(time) + 1) / 2
                        let y = (tan(time / 2) + sin(time) + 1) / 2
                        
                        Circle()
                            .fill(
                                MeshGradient(width: 3, height: 3, points: [
                                    .init(0, 0), .init(0.5, 0), .init(1, 0),
                                    .init(0, 0.5), .init(Float(x), Float(y)), .init(1, 0.5),
                                    .init(0, 1), .init(0.5, 1), .init(1, 1)
                                ], colors: [
                                    .cyan, .teal, .brown,
                                    .gray, .pink, .blue,
                                    .teal, .black, .orange
                                ])
                            )
                        .frame(width: 300, height: 100)
                        .padding(.bottom, 16)
                        CodeView(code: """
                        TimelineView(.animation) { timeline in
                            let time = timeline.date.timeIntervalSince1970
                            let x = (sin(time) * cos(time) + 1) / 2
                            let y = (tan(time / 2) + sin(time) + 1) / 2

                        Circle()
                            .fill(
                            MeshGradient(width: 3, height: 3, points: [
                                .init(0, 0), .init(0.5, 0), .init(1, 0),
                                .init(0, 0.5), .init(Float(x), Float(y)), .init(1, 0.5),
                                .init(0, 1), .init(0.5, 1), .init(1, 1)
                            ], colors: [
                                .cyan, .teal, .brown,
                                .gray, .pink, .blue,
                                .teal, .black, .orange
                            ])
                        )
                        .frame(width: 300, height: 100)
                        """)
                        DocButtonView(docURL: "https://developer.apple.com/documentation/SwiftUI/MeshGradient")
                    }
                }
                
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: 560)
        .navigationTitle("Mesh Gradients")
    }
    
    // MARK: Examples
    
    @State private var shiftPosition = false
    
    private var meshRectangle: some View {
        Rectangle()
            .fill(
                MeshGradient(width: 3, height: 3, points: [
                    .init(0, 0), .init(0.5, 0), .init(1, 0),
                    .init(0, 0.5), .init(0.5, 0.5), .init(1, 0.5),
                    .init(0, 1), .init(0.5, 1), .init(1, 1)
                ], colors: [
                    .cyan, .cyan, .brown,
                    .gray, .pink, .blue,
                    .teal, .black, .orange
                ])
            )
            .frame(width: 300, height: 300)
    }
    
}

#Preview {
    MeshGradientExample()
        .environment(CodeFontSize())
}
