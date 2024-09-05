//
//  ScrollViewExample.swift
//  iOS18Tour
//
//  Created by Jordan Morgan on 9/5/24.
//

import SwiftUI

struct ScrollViewExample: View {
    @State private var showGoToTopButton: Bool = false
    @State private var scrollViewPosition: ScrollPosition = .init(idType: Int.self)
    @State private var atTheBottom: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                Text("The trusty `ScrollView` has many great additions in iOS 18. Here are the standouts:\n\n1. You can detect changes in scrolling, sort of like how `contentOffset`, the contents size and more worked in UIKit and `UIScrollView`.\n\n2. You can be notified when a view became visible due to scrolling (or when it loses visibility).\n\n3. More programmatic control over scrolling, like scrolling to certain points or even edges.\n\nLet's take a look at scrolling to positions first. If you use a `Hashable` identifier, you could easily scroll to items in a list. Or, if you just want \"standard\" scrolling points, like the top or bottom — you can just pass in an `Int` type:")
                    .readingTextStyle()
                CodeView(code: """
                @State private var position: ScrollPosition = .init(idType: Int.self)
                """)
                Text("Now, we could make a button to scroll right to the very bottom of this scroll view:")
                    .readingTextStyle()
                Button("Scroll to Bottom") {
                    withAnimation {
                        scrollViewPosition.scrollTo(edge: .bottom)
                    }
                }
                .buttonStyle(.bordered)
                .padding(.vertical)
                Text("The `ScrollPosition` type is flexible. You can give it a `CGPoint` to go to, in addition to an `id` as we mentioned earlier (perfect for items in a list), or an `Edge` as we've done here. All you have to do is attach it to a `ScrollView`, and call `myPosition.scrollTo(edge/point/id/x/y)`:")
                    .readingTextStyle()
                CodeView(code: """
                ScrollView {
                    MyAwesomeView()
                }
                .scrollPosition($scrollViewPosition)
                """)
                Text("Thats how the button above works:")
                    .readingTextStyle()
                CodeView(code: """
                Button("Scroll to Bottom") {
                    withAnimation {
                        scrollViewPosition.scrollTo(edge: .bottom)
                    }
                }
                .buttonStyle(.bordered)
                """)
                Text("Cool! So what about that button that's hiding and showing at the top? Well, that uses another awesome `ScrollView` feature - `onScrollGeometryChange`. This lets you pass in a condition, return its type in a closure and then act on it. It sounds a little confusing, but is most cases you can just use a plain old `Bool`.\n\nThe code below is what triggers hiding and showing the \"Back to Tp[\" button:")
                    .readingTextStyle()
                CodeView(code: """
                .onScrollGeometryChange(for: Bool.self) { geo in
                    let topPadding: CGFloat = 134
                    return abs(geo.contentOffset.y) >= (geo.contentInsets.top + topPadding)
                } action: { isAtThreshold, isbeyondThreshold in
                    withAnimation {
                        showGoToTopButton = isbeyondThreshold
                    }
                }
                """)
                Text("All that code does is detect how far down we've scrolled with some padding added. And, if we past that point - we set the flag to show the button, which is a simple `.overlay` on this `ScrollView`.")
                    .readingTextStyle()
                Group {
                    CodeView(code: """
                    .overlay(alignment: .top) {
                        if showGoToTopButton {
                            Button("Back to Top") {
                                withAnimation {
                                    scrollViewPosition.scrollTo(edge: .top)
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .transition(.asymmetric(insertion: .move(edge: .top),
                                                    removal: .opacity))
                        }
                    }
                    """)
                    Text("Finally, it's good that we can see when a view goes in our out of the visible bounds of a `ScrollView`. This means we could stop expensive work, or a .gif that's playing, maybe even a video!\n\nSee that label below that says \"Still more to read...\"? That's controlled by another `View` at the bottom, when we hit the end its visibility changes and we get notified using this modifier:")
                        .readingTextStyle()
                    CodeView(code: """
                    .onScrollVisibilityChange(threshold: 0.2) { bottomedOut in
                        withAnimation{ atTheBottom = bottomedOut }
                    }
                    """)
                    Text("You can even change its `threshold` parameter to control how far off or how much closer the visibility is calculated. Think of it like a tolerance in terms of the size of the `View` using the modifier. So, if you used 0.5, you're saying the flag should change when the view is halfway visible. The smaller the number, the less of the view has to be visible, and vice-versa.")
                        .readingTextStyle()
                    Text("All done! This view looks for when it comes into view from the `ScrollView`, and when it does - it sets a flag to change the text below. Scroll back up, and you'll see it change. again")
                        .monospaced()
                        .foregroundStyle(.secondary)
                        .fontWeight(.medium)
                        .padding()
                        .background(Color(uiColor: .tertiarySystemFill))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.vertical)
                        .onScrollVisibilityChange(threshold: 0.2) { bottomedOut in
                            withAnimation{ atTheBottom = bottomedOut }
                        }
                    DocButtonView(docURL: "https://developer.apple.com/documentation/swiftui/scrollview")
                }
            }
            .padding(.horizontal)
        }
        .scrollPosition($scrollViewPosition)
        .onScrollGeometryChange(for: Bool.self) { geo in
            let topPadding: CGFloat = 134
            return abs(geo.contentOffset.y) >= (geo.contentInsets.top + topPadding)
        } action: { isAtThreshold, isbeyondThreshold in
            withAnimation {
                showGoToTopButton = isbeyondThreshold
            }
        }
        .overlay(alignment: .top) {
            if showGoToTopButton {
                Button("Back to Top") {
                    withAnimation {
                        scrollViewPosition.scrollTo(edge: .top)
                    }
                }
                .buttonStyle(.borderedProminent)
                .transition(.asymmetric(insertion: .move(edge: .top),
                                        removal: .opacity))
            }
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Spacer()
                Text(atTheBottom ? "We are at the bottom!" : "Still more to read...")
                    .contentTransition(.interpolate)
                    .offset(y: 8)
                Spacer()
            }
            .padding(.vertical)
            .background(.ultraThinMaterial)
        }
        .frame(maxWidth: 560)
        .navigationTitle("Scrollview Examples")
    }
}

#Preview {
    ScrollViewExample()
        .environment(CodeFontSize())
}
