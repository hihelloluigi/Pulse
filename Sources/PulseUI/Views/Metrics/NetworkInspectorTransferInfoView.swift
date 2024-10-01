// The MIT License (MIT)
//
// Copyright (c) 2020-2024 Alexander Grebenyuk (github.com/kean).

import SwiftUI
import Pulse

// MARK: - View

package struct NetworkInspectorTransferInfoView: View {
    package let viewModel: NetworkInspectorTransferInfoViewModel

    package var isSentHidden = false
    package var isReceivedHidden = false

    package init(viewModel: NetworkInspectorTransferInfoViewModel, isSentHidden: Bool = false, isReceivedHidden: Bool = false) {
        self.viewModel = viewModel
        self.isSentHidden = isSentHidden
        self.isReceivedHidden = isReceivedHidden
    }

#if os(watchOS)
    package var body: some View {
        HStack(alignment: .center) {
            if !isSentHidden {
                bytesSent
            }
            if !isReceivedHidden {
                bytesReceived
            }
        }
        .frame(maxWidth: .infinity)
    }
#else
    package var body: some View {
        HStack {
            Spacer()
            bytesSent
            Spacer()

            Divider()

            Spacer()
            bytesReceived
            Spacer()
        }
    }
#endif

    private var bytesSent: some View {
        makeView(
            title: "Sent",
            imageName: "arrow.up.circle",
            total: viewModel.totalBytesSent,
            headers: viewModel.headersBytesSent,
            body: viewModel.bodyBytesSent
        )
    }

    private var bytesReceived: some View {
        makeView(
            title: "Received",
            imageName: "arrow.down.circle",
            total: viewModel.totalBytesReceived,
            headers: viewModel.headersBytesReceived,
            body: viewModel.bodyBytesReceived
        )
    }

    private func makeView(title: String, imageName: String, total: String, headers: String, body: String) -> some View {
        VStack {
            HStack(alignment: .center, spacing: spacing) {
                Image(systemName: imageName)
                    .font(.largeTitle)
                VStack(alignment: .leading, spacing: 0) {
                    Text(title)
                    Text(total)
                }
#if os(macOS)
                .font(.title3.weight(.medium))
#else
                .font(.headline)
#endif
            }
            .fixedSize()
            .padding(2)
            HStack(alignment: .center, spacing: 4) {
                VStack(alignment: .trailing) {
                    Text("Headers:")
                        .foregroundColor(.secondary)
                        .font(valueFont)
                    Text("Body:")
                        .foregroundColor(.secondary)
                        .font(valueFont)
                }
                VStack(alignment: .leading) {
                    Text(headers)
                        .font(valueFont)
                    Text(body)
                        .font(valueFont)
                }
            }
            .fixedSize()
        }
    }
}

#if os(macOS)
private let valueFont: Font = .callout
#else
private let valueFont: Font = .footnote
#endif

#if os(tvOS)
private let spacing: CGFloat = 20
#else
private let spacing: CGFloat? = nil
#endif

// MARK: - Preview

#if DEBUG
struct NetworkInspectorTransferInfoView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkInspectorTransferInfoView(viewModel: mockModel)
            .padding()
            .fixedSize()
            .previewLayout(.sizeThatFits)
    }
}

private let mockModel = NetworkInspectorTransferInfoViewModel(
    task: LoggerStore.preview.entity(for: .login)
)

#endif

// MARK: - ViewModel

package struct NetworkInspectorTransferInfoViewModel {
    package let totalBytesSent: String
    package let bodyBytesSent: String
    package let headersBytesSent: String

    package let totalBytesReceived: String
    package let bodyBytesReceived: String
    package let headersBytesReceived: String

    package init(empty: Bool) {
        totalBytesSent = "–"
        bodyBytesSent = "–"
        headersBytesSent = "–"
        totalBytesReceived = "–"
        bodyBytesReceived = "–"
        headersBytesReceived = "–"
    }

    package init(task: LANetworkTaskEntity) {
        self.init(transferSize: task.totalTransferSize)
    }

    package init(transferSize: NetworkLogger.TransferSizeInfo) {
        totalBytesSent = formatBytes(transferSize.totalBytesSent)
        bodyBytesSent = formatBytes(transferSize.requestBodyBytesSent)
        headersBytesSent = formatBytes(transferSize.requestHeaderBytesSent)

        totalBytesReceived = formatBytes(transferSize.totalBytesReceived)
        bodyBytesReceived = formatBytes(transferSize.responseBodyBytesReceived)
        headersBytesReceived = formatBytes(transferSize.responseHeaderBytesReceived)
    }
}

private func formatBytes(_ count: Int64) -> String {
    ByteCountFormatter.string(fromByteCount: max(0, count))
}
