//
//  DocButtonView.swift
//  iOS18Tour
//
//  Created by Jordan Morgan on 9/5/24.
//

import SwiftUI

struct DocButtonView: View {
    let docURL: String
    
    var body: some View {
        Button {
            UIApplication.shared.open(.init(string: docURL)!)
        } label: {
            HStack {
                Text("Documentation")
                    .fontWeight(.medium)
                Spacer()
                Image(systemName: "arrow.up.right.circle.fill")
                    .symbolRenderingMode(.hierarchical)
            }
            .padding(12)
            .background(Color(uiColor: .systemGroupedBackground))
            .clipShape(.rect(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    DocButtonView(docURL: "https://developer.apple.com/documentation/swiftui/view/matchedtransitionsource(id:in:configuration:)")
}
