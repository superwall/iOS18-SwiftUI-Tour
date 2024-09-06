//
//  TextEffectExample.swift
//  iOS18Tour
//
//  Created by Jordan Morgan on 9/5/24.
//

import SwiftUI

struct TextEffectExample: View {
    @State var bobbleText: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Now, you can have fine-grained control over how `Text` will eventually render its `String`. It runs through `TextRenderer`, and its a protocol that lets you hook into how the text is drawn.\n\nThis is neat because it allows for a bunch of amazing animations. Try this one out:")
                    .readingTextStyle()
                GroupBox {
                    Toggle("Show Neato Text", isOn: $bobbleText.animation())
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(uiColor: .tertiarySystemGroupedBackground))
                        .frame(height: 140)
                    WobbleText(showText: $bobbleText, text: "This is so cool!", duration: 1.75)
                        .font(.system(size: 42, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.blue.gradient)
                }
                .padding(.vertical)
                CalloutView(text: "I adapted most of this `TextRenderer` implementation from the awesome WWDC session \"Create Custom Visual Effects with SwiftUI\". For more on this, that is required viewing!")
                Text("I'm going to be honest - there is _a lot_ going on here. But the idea is that, using the aforementioned protocol, you animate the individual text glyphs. Then, you animate the view in itself. Here's how that text above was implemented:")
                    .readingTextStyle()
                CodeView(code: """
                struct WobbleText: View {
                    @Binding var showText: Bool
                    let text: String
                    let duration: Double
                    
                    var body: some View {
                        VStack {
                            if showText {
                                Text(text)
                                    .customAttribute(EmphasisAttribute())
                                    .transition(TextTransition(duration: duration))
                            }
                        }
                    }
                }
                """)
                Text("At its core, you implement a `draw` function:")
                    .readingTextStyle()
                CodeView(code: """
                struct AppearanceEffectRenderer: TextRenderer {
                    func draw(layout: Text.Layout, in context: inout GraphicsContext) {
                        for line in layout {
                            context.draw(line)
                        }
                    }
                }
                """)
                Text("The example above really shows off some of the fun stuff you can do here. Again, this one was a bit over my head when I sat down to learn it, but there are some really great resources you can try out. First, the WWDC session:")
                    .readingTextStyle()
                Button("Creating Custom Text Effects") {
                    UIApplication.shared.open(.init(string: "https://developer.apple.com/wwdc24/10151?time=769")!)
                }
                .buttonStyle(.bordered)
                .padding(.vertical)
                Text("And, Paul Hudson has a wonderul example, with easier-to-follow examples:")
                    .readingTextStyle()
                Button("Hacking with Swift Example") {
                    UIApplication.shared.open(.init(string: "https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-custom-text-effects-and-animations")!)
                }
                .buttonStyle(.bordered)
                .padding(.vertical)
                DocButtonView(docURL: "https://developer.apple.com/documentation/swiftui/view/textrenderer(_:)")
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: 560)
        .navigationTitle("Text Effect Examples")
    }
}

struct WobbleText: View {
    @Binding var showText: Bool
    let text: String
    let duration: Double
    
    var body: some View {
        VStack {
            if showText {
                Text(text)
                    .customAttribute(EmphasisAttribute())
                    .transition(TextTransition(duration: duration))
            }
        }
    }
}

struct EmphasisAttribute: TextAttribute {}

/// A text renderer that animates its content.
struct AppearanceEffectRenderer: TextRenderer, Animatable {
    /// The amount of time that passes from the start of the animation.
    /// Animatable.
    var elapsedTime: TimeInterval
    
    /// The amount of time the app spends animating an individual element.
    var elementDuration: TimeInterval
    
    /// The amount of time the entire animation takes.
    var totalDuration: TimeInterval
    
    var spring: Spring {
        .snappy(duration: elementDuration - 0.05, extraBounce: 0.2)
    }
    
    var animatableData: Double {
        get { elapsedTime }
        set { elapsedTime = newValue }
    }
    
    init(elapsedTime: TimeInterval, elementDuration: Double = 0.4, totalDuration: TimeInterval) {
        self.elapsedTime = min(elapsedTime, totalDuration)
        self.elementDuration = min(elementDuration, totalDuration)
        self.totalDuration = totalDuration
    }
    
    func draw(layout: Text.Layout, in context: inout GraphicsContext) {
        for run in layout.flattenedRuns {
            if run[EmphasisAttribute.self] != nil {
                let delay = elementDelay(count: run.count)
                
                for (index, slice) in run.enumerated() {
                    // The time that the current element starts animating,
                    // relative to the start of the animation.
                    let timeOffset = TimeInterval(index) * delay
                    
                    // The amount of time that passes for the current element.
                    let elementTime = max(0, min(elapsedTime - timeOffset, elementDuration))
                    
                    // Make a copy of the context so that individual slices
                    // don't affect each other.
                    var copy = context
                    draw(slice, at: elementTime, in: &copy)
                }
            } else {
                // Make a copy of the context so that individual slices
                // don't affect each other.
                var copy = context
                // Runs that don't have a tag of `EmphasisAttribute` quickly
                // fade in.
                copy.opacity = UnitCurve.easeIn.value(at: elapsedTime / 0.2)
                copy.draw(run)
            }
        }
    }
    
    func draw(_ slice: Text.Layout.RunSlice, at time: TimeInterval, in context: inout GraphicsContext) {
        // Calculate a progress value in unit space for blur and
        // opacity, which derive from `UnitCurve`.
        let progress = time / elementDuration
        
        let opacity = UnitCurve.easeIn.value(at: 1.4 * progress)
        
        let invert =
        slice.typographicBounds.rect.height / 16 *
        UnitCurve.easeIn.value(at: 1 - progress)
        
        // The y-translation derives from a spring, which requires a
        // time in seconds.
        let translationY = spring.value(
            fromValue: -slice.typographicBounds.descent,
            toValue: 0,
            initialVelocity: 0,
            time: time)
        
        context.addFilter(.colorInvert(invert))
        context.opacity = opacity
        context.translateBy(x: 0, y: translationY)
        context.draw(slice, options: .disablesSubpixelQuantization)
    }
    
    /// Calculates how much time passes between the start of two consecutive
    /// element animations.
    ///
    /// For example, if there's a total duration of 1 s and an element
    /// duration of 0.5 s, the delay for two elements is 0.5 s.
    /// The first element starts at 0 s, and the second element starts at 0.5 s
    /// and finishes at 1 s.
    ///
    /// However, to animate three elements in the same duration,
    /// the delay is 0.25 s, with the elements starting at 0.0 s, 0.25 s,
    /// and 0.5 s, respectively.
    func elementDelay(count: Int) -> TimeInterval {
        let count = TimeInterval(count)
        let remainingTime = totalDuration - count * elementDuration
        
        return max(remainingTime / (count + 1), (totalDuration - elementDuration) / count)
    }
}

extension Text.Layout {
    /// A helper function for easier access to all runs in a layout.
    var flattenedRuns: some RandomAccessCollection<Text.Layout.Run> {
        self.flatMap { line in
            line
        }
    }
    
    /// A helper function for easier access to all run slices in a layout.
    var flattenedRunSlices: some RandomAccessCollection<Text.Layout.RunSlice> {
        flattenedRuns.flatMap(\.self)
    }
}

struct TextTransition: Transition {
    let duration: Double
    
    static var properties: TransitionProperties {
        TransitionProperties(hasMotion: true)
    }
    
    func body(content: Content, phase: TransitionPhase) -> some View {
        let duration = self.duration
        let elapsedTime = phase.isIdentity ? duration : 0
        let renderer = AppearanceEffectRenderer(
            elapsedTime: elapsedTime,
            totalDuration: duration
        )
        
        content.transaction { transaction in
            // Force the animation of `elapsedTime` to pace linearly and
            // drive per-glyph springs based on its value.
            if !transaction.disablesAnimations {
                transaction.animation = .linear(duration: duration)
            }
        } body: { view in
            view.textRenderer(renderer)
        }
    }
}


#Preview {
    TextEffectExample()
        .environment(CodeFontSize())
}
