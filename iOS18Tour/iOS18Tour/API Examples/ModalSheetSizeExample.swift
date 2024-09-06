//
//  ModalSheetSizeExample.swift
//  iOS18Tour
//
//  Created by Jordan Morgan on 9/5/24.
//

import SwiftUI

struct ModalSheetSizeExample: View {
    @State private var present: Bool = false
    @State private var presentWithout: Bool = false
    @State private var stickyPresent: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                Text("This one is a very small, but _very_ welcome, change. Now, you can specify a size on modal sheets presented on iPad:")
                    .readingTextStyle()
                CodeView(code: """
                .sheet(isPresented: $present) {
                    DemoPresentedView()
                        .presentationSizing(.form)
                }
                """)
                Button("Present") {
                    present.toggle()
                }
                .buttonStyle(.borderedProminent)
                .padding(.vertical)
                Text("In the past, views presented on iPad could be quite large. This gives us (finally!) the `form` size. To see it, try this demo out on iPad. To cleary view the difference, present this one which forgoes using the modifier:")
                    .readingTextStyle()
                Button("Present without Form Sizing") {
                    presentWithout.toggle()
                }
                .buttonStyle(.borderedProminent)
                .padding(.vertical)
                Text("There are other options too, such as `.page` and `.fitted`. Plus, you can even make your own if you adopted the `PresentationSizing` protocol.\n\nFinally, you can make views sized as `.sticky` (i.e. stick to my content) or give them your own `.proposedSize` (i.e. size it this way). Here's an example of view that is a `.page` to start, but keeps growing to hug its content as more images are added:")
                    .readingTextStyle()
                Button("Present Sticky Form") {
                    stickyPresent.toggle()
                }
                .buttonStyle(.borderedProminent)
                .padding(.vertical)
                Group {
                    Text("Here's how we did that:")
                        .readingTextStyle()
                    CodeView(code: """
                    .sheet(isPresented: $stickyPresent) {
                        DemoStickyView()
                            .presentationSizing(.page.sticky())
                    }
                    """)
                }
                DocButtonView(docURL: "https://developer.apple.com/documentation/swiftui/view/presentationsizing(_:)")
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $present) {
            DemoPresentedView()
                .presentationSizing(.form)
        }
        .sheet(isPresented: $presentWithout) {
            DemoPresentedView()
        }
        .sheet(isPresented: $stickyPresent) {
            DemoStickyView()
                .presentationSizing(.page.sticky())
        }
        .frame(maxWidth: 560)
        .navigationTitle("Modal Sheet Size Examples")
    }
}

struct DemoStickyView: View {
    @State private var imageCount = 1
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("Add as many beaches as you wish...")
                .fontDesign(.serif)
                .fontWidth(.expanded)
                .fontWeight(.semibold)
            Button("Add Image") {
                withAnimation(.smooth) {
                    imageCount += 1
                }
            }
            ForEach(1...imageCount, id: \.self) { _ in
                Image(.beachZoom)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
            }
            .transition(.blurReplace)
        }
    }
}

struct DemoPresentedView: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("The Beach")
                .fontDesign(.serif)
                .fontWidth(.expanded)
                .fontWeight(.semibold)
            Image(.beachZoom)
                .scaledToFill()
                .clipShape(.rect(cornerRadius: 16))
        }
    }
}

#Preview {
    ModalSheetSizeExample()
        .environment(CodeFontSize())
}
