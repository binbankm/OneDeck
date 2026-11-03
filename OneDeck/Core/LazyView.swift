//
//  LazyView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Defers destination view instantiation until user navigation occurs.
//

import SwiftUI

public struct LazyView<Content: View>: View {
    private let build: () -> Content

    public init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }

    public var body: Content {
        build()
    }
}
