//
//  CalloutView.swift
//  iOS18Tour
//
//  Created by Jordan Morgan on 9/5/24.
//

import SwiftUI

struct CalloutView: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "lightbulb.circle.fill")
                .symbolRenderingMode(.hierarchical)
            Text(text)
        }
        .font(.callout.weight(.medium))
        .foregroundStyle(Color.green)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.green.opacity(0.1))
        }
        .padding(.vertical, 16)
    }
}

#Preview {
    CalloutView(text: "Even though we're using `.init(x:, y:)` in our examples, you can also use inline Array syntax like this: `[0, 1]`.")
}
