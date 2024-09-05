//
//  ZoomExample.swift
//  iOS18Tour
//
//  Created by Jordan Morgan on 9/5/24.
//

import SwiftUI
import HighlightSwift

struct ZoomExample: View {
    private let codeSampleOne: String = """
    print(\"Hello World\")
    """
    
    @Namespace var imageNamespace
    @State private var showImage: Bool = false
    @State private var transitionID: String = "Beach"
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Zoom transitions allow you to use the classic \"zoom\" style transition that Photos has used for years. Tap on the image below to see an example:")
                    .readingTextStyle()
                NavigationLink {
                    ImageGallery(imageName: "Beach",
                                 namespace: imageNamespace)
                } label: {
                    Image(.beachZoom)
                        .resizable()
                        .clipShape(.rect(cornerRadius: 8))
                }
                .matchedTransitionSource(id: transitionID,
                                         in: imageNamespace)
                Text("Setting one up is easy. You create a `@Namespace`, signal which view is the source of the transition and finally mark a destination view.\n\nHere, the `NavigationLink` is marked as the source:")
                    .readingTextStyle()
                CodeView(code: """
                NavigationLink {
                    ImageGallery(imageName: "Beach",
                                 namespace: imageNamespace)
                } label: {
                    Image(.beachZoom)
                        .resizable()
                        .clipShape(.rect(cornerRadius: 8))
                }
                // Transition source here
                .matchedTransitionSource(id: transitionID,
                                         in: imageNamespace)
                """)
                Text("Then, in the `ImageGallery`, we mark it as the destination:")
                    .readingTextStyle()
                CodeView(code: """
                struct ImageGallery: View {
                    let imageName: String
                    let namespace: Namespace.ID
                    
                    var body: some View {
                        Image(.beachZoom)
                            .navigationTransition(.zoom(sourceID: imageName, in: namespace))
                    }
                }
                """)
                Text("The `NameSpace` and `id` must be stable, and the identifier `Hashable`. More commonly, you will use this technique in a list of your own app's models. Each model would use its own identifier for the transition\n\nThis same technique that we've used here also works outside of `NavigationStack` - you can use it for `.fullScreenCover` as well.")
                    .readingTextStyle()
                DocButtonView(docURL: "https://developer.apple.com/documentation/swiftui/view/matchedtransitionsource(id:in:configuration:)")
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: 560)
        .navigationTitle("Zoom Transitions")
    }
}

struct ImageGallery: View {
    let imageName: String
    let namespace: Namespace.ID
    
    var body: some View {
        Image(.beachZoom)
            .navigationTransition(.zoom(sourceID: imageName, in: namespace))
    }
}

#Preview {
    NavigationStack {
        ZoomExample()
    }
}
