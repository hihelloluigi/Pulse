// The MIT License (MIT)
//
// Copyright (c) 2020-2024 Alexander Grebenyuk (github.com/kean).

import Foundation
import SwiftUI
import Pulse

package struct StatusLabelViewModel {
    package let systemImage: String
    package let tint: Color
    package let title: String

    package init(task: LANetworkTaskEntity, store: LoggerStore?) {
        guard let state = task.state(in: store) else {
            self.systemImage = "questionmark.diamond.fill"
            self.tint = .secondary
            self.title = "Unknown"
            return
        }
        switch state {
        case .pending:
            self.systemImage = "clock.fill"
            self.tint = .orange
            self.title = ProgressViewModel.title(for: task)
        case .success:
            self.systemImage = "checkmark.circle.fill"
            self.tint = .green
            self.title = StatusCodeFormatter.string(for: Int(task.statusCode))
        case .failure:
            self.systemImage = "exclamationmark.octagon.fill"
            self.tint = .red
            self.title = ErrorFormatter.shortErrorDescription(for: task)
        }
    }

    package init(transaction: LANetworkTransactionMetricsEntity) {
        if let response = transaction.response {
            if response.isSuccess {
                self.systemImage = "checkmark.circle.fill"
                self.title = StatusCodeFormatter.string(for: Int(response.statusCode))
                self.tint = .green
            } else {
                self.systemImage = "exclamationmark.octagon.fill"
                self.title = StatusCodeFormatter.string(for: Int(response.statusCode))
                self.tint = .red
            }
        } else {
            self.systemImage = "exclamationmark.octagon.fill"
            self.title = "No Response"
            self.tint = .secondary
        }
    }

    package var text: Text {
        (Text(Image(systemName: systemImage)) + Text(" " + title))
            .foregroundColor(tint)
    }
}

private extension LANetworkResponseEntity {
    var isSuccess: Bool {
        (100..<400).contains(statusCode)
    }
}
