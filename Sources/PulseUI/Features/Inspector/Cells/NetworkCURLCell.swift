// The MIT License (MIT)
//
// Copyright (c) 2020-2024 Alexander Grebenyuk (github.com/kean).

#if os(iOS) || os(tvOS) || os(visionOS)

import SwiftUI
import Pulse

struct NetworkCURLCell: View {
    let task: LANetworkTaskEntity

    var body: some View {
        NavigationLink(destination: destination) {
            NetworkMenuCell(
                icon: "terminal.fill",
                tintColor: .secondary,
                title: "cURL Representation",
                details: ""
            )
        }
    }

    private var destination: some View {
        let curl = task.cURLDescription()
        let string = TextRenderer().render(curl, role: .body2, style: .monospaced)
        let viewModel = RichTextViewModel(string: string)
        viewModel.isLinkDetectionEnabled = false
        return RichTextView(viewModel: viewModel)
            .navigationTitle("cURL Representation")
    }
}

#endif
