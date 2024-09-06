//
//  ContentView.swift
//  iOS18Tour
//
//  Created by Jordan Morgan on 9/5/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.horizontalSizeClass) private var hClass
    @Environment(\.verticalSizeClass) private var vClass
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea()
                Form {
                    Section {
                        headerView
                    }
                    Section("New APIs") {
                        NavigationLink("Scrollview Additions") {
                            ScrollViewExample()
                        }
                        NavigationLink("Zoom Transitions") {
                            ZoomExample()
                        }
                        NavigationLink("SF Symbol Updates") {
                            SFSymbolExample()
                        }
                        NavigationLink("Geometry Changes") {
                            GeoChangeExample()
                        }
                        NavigationLink("Color Blending") {
                            ColorBlendExample()
                        }
                        NavigationLink("Text Effects") {
                            TextEffectExample()
                        }
                        NavigationLink("Mesh Gradients") {
                            MeshGradientExample()
                        }
                        NavigationLink("Modal Sheet Sizing") {
                            ModalSheetSizeExample()
                        }
                    }
                    Section("More") {
                        Button {
                            UIApplication.shared.open(.init(string: "https://github.com/superwall/iOS18-SwiftUI-Tour")!)
                        } label: {
                            HStack {
                                Image(systemName: "globe")
                                Text("View on Github")
                                Spacer()
                            }
                        }
                        Button {
                            UIApplication.shared.open(.init(string: "https://superwall.com/blog/getting-started-with-superwall-in-your-indie-ios-app")!)
                        } label: {
                            HStack {
                                Image(systemName: "lightbulb")
                                Text("How to use Superwall on iOS")
                                Spacer()
                            }
                        }
                        Button {
                            UIApplication.shared.open(.init(string: "https://x.com/superwall")!)
                        } label: {
                            HStack {
                                Image(systemName: "x.circle")
                                Text("Find us on X")
                                Spacer()
                            }
                        }
                    }
                }
                .containerRelativeFrame([.horizontal]) { length, axis in
                    guard hClass == .regular && vClass == .regular else {
                        return length
                    }
                    
                    return length * 0.64
                }
            }
        }
    }
    
    // MARK: Subviews
    
    private var headerView: some View {
        VStack(alignment: .center) {
            Text("SwiftUI iOS 18 Tour")
                .font(.title.weight(.bold))
                .frame(minWidth: 0, maxWidth: .infinity)
            Text("Brought to you by Superwall")
                .font(.title3.weight(.medium))
                .foregroundStyle(.secondary)
                .frame(minWidth: 0, maxWidth: .infinity)
        }
    }
}

#Preview {
    ContentView()
        .environment(CodeFontSize())
}
