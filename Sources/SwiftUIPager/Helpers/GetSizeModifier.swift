//
//  Copyright © 2025 SquareOne. All rights reserved.
//

import SwiftUI

@available(iOS 15.0, *)
struct GetSizeModifier: ViewModifier {
    @Binding var size: CGSize
    
    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { geometry in
                    Color.clear.preference(key: InnerHeightPreferenceKey.self, value: geometry.size)
                }
            }
            .onPreferenceChange(InnerHeightPreferenceKey.self) { newValue in
                if #available(iOS 17, *) {
                    size = newValue
                } else {
                    // not updating in iOS 16, but removes animation
                    DispatchQueue.main.async {
                        size = newValue
                    }
                }
            }
    }
}

@available(iOS 15.0, *)
struct InnerHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

@available(iOS 15.0, *)
extension View {
    func bindingSize(_ size: Binding<CGSize>) -> some View {
        modifier(GetSizeModifier(size: size))
    }
}
