//
//  SFSymbolExample.swift
//  iOS18Tour
//
//  Created by Jordan Morgan on 9/5/24.
//

import SwiftUI

struct SFSymbolExample: View {
    @State private var showSmartReplace: Bool = false
    @State private var wiggle = false
    @State private var rotate = false
    @State private var breathe = false
    
    var body: some View {
        ScrollView {
            VStack {
                Text("The ever growing powers of SF Symbols continues with iOS 18! First up, there is a new \"Magic Replace\" that occurs in a symbol. Basically, this lets you transition more smoothly between variants of a symbol.\n\nFor example, here we have a pencil, and then a slashed version. Notice how it smoothly animates the slash in and out instead of simply replacing the whole symbol:")
                    .readingTextStyle()
                GroupBox {
                    Toggle("Toggle", isOn: $showSmartReplace.animation())
                    Text("With magic replace:")
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    Image(systemName: showSmartReplace ? "pencil.slash" : "pencil")
                        .contentTransition(.symbolEffect)
                        .font(.largeTitle)
                        .padding(.vertical, 16)
                    Text("Without magic replace:")
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    Image(systemName: showSmartReplace ? "pencil.slash" : "pencil")
                        .font(.largeTitle)
                        .padding(.vertical, 16)
                }
                Text("Notice how the top version has the slash animate in, while the bottom one simply fades in and out. This is achieved without any extra work on our end, as long as we use a `.contentTransition(.symbolEffect):")
                    .readingTextStyle()
                CodeView(code: """
                Image(systemName: showSmartReplace ? "pencil.slash" : "pencil")
                    .contentTransition(.symbolEffect)
                """)
                Text("Next, we've got new animations! There's wiggle, rotate and breathe! All of these work the the same way:")
                    .readingTextStyle()
                CodeView(code: """
                Image(systemName: "rays")
                    .symbolEffect([the effect], value: theFlag)
                """)
                Group {
                    Text("There are some slight differences, like being able to pass in configurations or options - but for the most part, they work like this. Let's check out the new animations.\n\nFirst, wiggle:")
                        .readingTextStyle()
                    GroupBox {
                        Toggle("Wiggle", isOn: $wiggle)
                        Image(systemName: "key.2.on.ring.fill")
                            .symbolEffect(.wiggle, value: wiggle)
                            .font(.largeTitle)
                            .padding(.vertical, 16)
                    }
                    Text("All of these support chaining options off of them, too. So, you could wiggle in different directions:")
                        .readingTextStyle()
                    GroupBox {
                        Toggle("Wiggle", isOn: $wiggle)
                        HStack {
                            Image(systemName: "key.2.on.ring.fill")
                                .symbolEffect(.wiggle.up, value: wiggle)
                                .font(.largeTitle)
                                .padding(.vertical, 16)
                            Image(systemName: "key.2.on.ring.fill")
                                .symbolEffect(.wiggle.byLayer, value: wiggle)
                                .font(.largeTitle)
                                .padding(.vertical, 16)
                            Image(systemName: "key.2.on.ring.fill")
                                .symbolEffect(.wiggle.backward, value: wiggle)
                                .font(.largeTitle)
                                .padding(.vertical, 16)
                        }
                    }
                    .padding(.bottom, 16)
                    CodeView(code: """
                    // You can use up, down, backwards, etc...
                    .symbolEffect(.wiggle.byLayer, value: wiggle)
                    """)
                    Text("Next, there's rotate:")
                        .readingTextStyle()
                    GroupBox {
                        Toggle("Rotate", isOn: $rotate)
                        Image(systemName: "steeringwheel.and.hands")
                            .symbolEffect(.rotate, value: rotate)
                            .font(.largeTitle)
                            .padding(.vertical, 16)
                    }
                    Group {
                        Text("And finally, my favorite breathe:")
                            .readingTextStyle()
                        GroupBox {
                            Toggle("Breathe", isOn: $breathe)
                            Image(systemName: "lungs.fill")
                                .foregroundStyle(Color.pink)
                                .symbolEffect(.breathe, options: .repeat(.continuous), value: breathe)
                                .font(.largeTitle)
                                .padding(.vertical, 16)
                        }
                        Text("We keep that one going by using a continuous repeat:")
                            .readingTextStyle()
                        CodeView(code: """
                        Image(systemName: "lungs.fill")
                            .foregroundStyle(Color.pink)
                            .symbolEffect(.breathe, options: .repeat(.continuous), value: breathe)
                        """)
                    }
                }
                DocButtonView(docURL: "https://developer.apple.com/sf-symbols/")
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: 560)
        .navigationTitle("SF Symbol Examples")
    }
}

#Preview {
    SFSymbolExample()
        .environment(CodeFontSize())
}
