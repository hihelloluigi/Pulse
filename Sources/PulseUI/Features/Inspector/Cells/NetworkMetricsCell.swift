// The MIT License (MIT)
//
// Copyright (c) 2020-2024 Alexander Grebenyuk (github.com/kean).

#if !os(watchOS)

import SwiftUI
import Pulse

@available(iOS 16, visionOS 1, macOS 13, *)
struct NetworkMetricsCell: View {
    let task: LANetworkTaskEntity

    var body: some View {
        NavigationLink(destination: destinationMetrics) {
            NetworkMenuCell(
                icon: "clock.fill",
                tintColor: .orange,
                title: "Metrics",
                details: ""
            )
        }.disabled(!task.hasMetrics)
    }

    private var destinationMetrics: some View {
        NetworkInspectorMetricsViewModel(task: task).map {
            NetworkInspectorMetricsView(viewModel: $0)
        }
    }
}

#endif
