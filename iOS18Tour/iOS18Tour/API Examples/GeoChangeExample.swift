//
//  GeoChangeExample.swift
//  iOS18Tour
//
//  Created by Jordan Morgan on 9/5/24.
//

import SwiftUI

struct GeoChangeExample: View {
    @State private var topCircleHeight = 30.0
    @State private var bottomCircleHeight = 15.0
    
    var body: some View {
        ScrollView {
            VStack {
                Text("The new `onGeometryChange` modifier can usually eliminate the need to wrap entire views inside of a `GeomtryReader`. Here's what the API looks like, and it's _very_ similar if you've read the `ScrollView` section already:")
                    .readingTextStyle()
                CodeView(code: """
                GifBannerView()
                    .onGeometryChange(for: Bool.self) { proxy in
                        // Calculate a Bool type to return...
                    } action: { didChangeSize in
                        // Do some action based on the Bool
                    }
                """)
                Text("Like the `ScrollView` API, this takes a type you're after (`CGRect`, `Bool`, `Double`, or anything else you need), then using the proxy you transform it to the type you specified. Finally, you take action on it.")
                    .readingTextStyle()
                CalloutView(text: "Even better, this has been backported to iOS 16!")
                Text("With that in mind, play with the controls below to see it in action. The bottom blue `Circle()` will always be half the size of the top red one, accomplished by using the `onGeomtryChange` modifier:")
                    .readingTextStyle()
                GroupBox {
                    HStack {
                        Text("Circle Size:")
                        Text(topCircleHeight, format: .number)
                            .contentTransition(.numericText(value: topCircleHeight))
                            .animation(.smooth, value: topCircleHeight)
                        Spacer()
                    }
                    Slider(value: $topCircleHeight, in: 30...200) {
                        EmptyView()
                    } minimumValueLabel: {
                        Text("30")
                    } maximumValueLabel: {
                        Text("200")
                    }
                    Circle()
                        .fill(Color.red)
                        .frame(height: topCircleHeight)
                        .onGeometryChange(for: Double.self) { proxy in
                            return proxy.size.height
                        } action: { newValue in
                            bottomCircleHeight = (newValue/2).rounded()
                        }
                    Circle()
                        .fill(Color.blue)
                        .frame(height: topCircleHeight)
                        .onGeometryChange(for: Double.self) { proxy in
                            return proxy.size.height
                        } action: { newValue in
                            bottomCircleHeight = (newValue/2).rounded()
                        }
                    
                }
                Text("Here's how it works:")
                    .readingTextStyle()
                CodeView(code: """
                @State private var topCircleHeight = 30.0
                @State private var bottomCircleHeight = 15.0
                
                Circle()
                    .fill(Color.red)
                    .frame(height: topCircleHeight)
                    .onGeometryChange(for: Double.self) { proxy in
                        return proxy.size.height
                    } action: { newValue in
                        bottomCircleHeight = (newValue/2).rounded()
                    }
                Circle()
                    .fill(Color.blue)
                    .frame(height: topCircleHeight)
                    .onGeometryChange(for: Double.self) { proxy in
                        return proxy.size.height
                    } action: { newValue in
                        bottomCircleHeight = (newValue/2).rounded()
                    }
                """)
                DocButtonView(docURL: "https://developer.apple.com/documentation/swiftui/view/ongeometrychange(for:of:action:)-6tl7p")
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: 560)
        .navigationTitle("Geometry Change Examples")
    }
}

#Preview {
    GeoChangeExample()
        .environment(CodeFontSize())
}
