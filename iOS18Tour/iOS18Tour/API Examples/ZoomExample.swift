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
    
    @Namespace var zoomExampleNamespace
    @State private var showImage: Bool = false
    @State private var transitionID: String = "Beach"
    private let columns = Array(repeating: GridItem(.flexible()),
                                       count: 2)
    var body: some View {
        ScrollView {
            VStack {
                Text("Zoom transitions allow you to use the classic \"zoom\" style transition that Photos has used for years. Here, we push a framework selection onto the navigation stack. Tap on a grid item below to see an example:")
                    .readingTextStyle()
                ScrollView(.horizontal) {
                    HStack(spacing: 10.0) {
                        ForEach(Frameworks.allCases) { f in
                            NavigationLink {
                                VStack {
                                    Text("You picked \(f.description). Now, you can either tap the back button, or swipe down to go back and trigger the interactive zoom dismiss transition. Here's how this source view is marked:")
                                        .readingTextStyle()
                                    CodeView(code: """
                                    VStack {
                                        // content
                                    }
                                    .navigationTransition(.zoom(sourceID: f.id, in: zoomExampleNamespace))
                                    """)
                                    CalloutView(text: "You can also disable the interactive dismissal gesture: `.interactiveDismissDisabled()`")
                                }
                                .padding(.horizontal)
                                .navigationTransition(.zoom(sourceID: f.id, in: zoomExampleNamespace))
                            } label: {
                                Text(f.description)
                                    .foregroundStyle(Color(uiColor: .label).gradient)
                                    .font(.title.weight(.semibold).width(.expanded))
                                    .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                                    .background(f.color.gradient)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .matchedTransitionSource(id: f.id,
                                                     in: zoomExampleNamespace)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .padding(.vertical, 32)
                Text("Of course, you don't _have_ to use `NavigationStack`, even though the API may read like that. You can use them for modal presentations, too. Tapping on the image below will kick off a full screen presentation:")
                    .readingTextStyle()
                Image(.beach)
                    .resizable()
                    .clipShape(.rect(cornerRadius: 8))
                    .onTapGesture {
                        showImage.toggle()
                    }
                    .matchedTransitionSource(id: transitionID,
                                             in: zoomExampleNamespace)
                Text("Setting one up is easy. You create a `@Namespace`, mark the view which is the source of the transition and finally designate a destination view.\n\nFor the grid example, the `NavigationLink` was marked as the source, and the presented view was marked as the destination:")
                    .readingTextStyle()
                CodeView(code: """
                NavigationLink {
                    VStack {
                        // The grid display cod
                    }
                    .padding(.horizontal)
                    .navigationTransition(.zoom(sourceID: f.id, in: zoomExampleNamespace))
                } label: {
                    // The label
                }
                .matchedTransitionSource(id: f.id,
                                         in: zoomExampleNamespace)
                """)
                Text("Same thing in the `ImageGallery`, we marked it as the destination:")
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
                Text("The `NameSpace` and `id` must be stable, and the identifier `Hashable`. More commonly, you will use this technique in a list of your own app's models. Each model would use its own identifier for the transition.\n\nSo remember, all you need is a `@Namespace`, and identifier and then to mark the source and destination view. That's it! If you need to customize the zoom presentation, be sure to use the `configuration` parameter to style the view:")
                    .readingTextStyle()
                CodeView(code: """
                PresentingView()
                    .matchedTransitionSource(id: 0, in: zoomExampleNamespace) { source in
                        source
                            .clipShape(.rect(cornerRadius: 10))
                    }
                """)
                DocButtonView(docURL: "https://developer.apple.com/documentation/swiftui/view/matchedtransitionsource(id:in:configuration:)")
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: 560)
        .navigationTitle("Zoom Transitions")
        .fullScreenCover(isPresented: $showImage) {
            ImageGallery(imageName: "Beach",
                         namespace: zoomExampleNamespace)
        }
    }
}

enum Frameworks: Int, Identifiable, CustomStringConvertible, CaseIterable {
    case swiftUI, uiKit, accelerate, uniformTypeIdentifiers, foundation, photos
    var id: Self { self }
    var description: String {
        switch self {
        case .swiftUI:
            "SwiftUI"
        case .uiKit:
            "UIKit"
        case .accelerate:
            "Accelerate"
        case .uniformTypeIdentifiers:
            "UniformTypeIdentifiers"
        case .foundation:
            "Foundation"
        case .photos:
            "Photos"
        }
    }
    var color: Color {
        switch self {
        case .swiftUI:
                .blue
        case .uiKit:
                .pink
        case .accelerate:
                .purple
        case .uniformTypeIdentifiers:
                .green
        case .foundation:
                .indigo
        case .photos:
                .orange
        }
    }
}

struct ImageGallery: View {
    let imageName: String
    let namespace: Namespace.ID
    
    var body: some View {
        Image(.beach)
            .navigationTransition(.zoom(sourceID: imageName, in: namespace))
    }
}

#Preview {
    NavigationStack {
        ZoomExample()
    }
}
