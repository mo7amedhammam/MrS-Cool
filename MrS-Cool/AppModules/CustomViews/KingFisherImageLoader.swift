//
//  KingFisherImageLoader.swift
//  MrS-Cool
//
//  Created by wecancity on 03/03/2024.
//

import Kingfisher
import SwiftUI

struct KFImageLoader: View {
    let url: URL?
    let placeholder: Image
    
    init(url: URL?, placeholder: Image = Image(systemName: "photo")) {
        self.url = url
        self.placeholder = placeholder
    }
    
    var body: some View {
        KFImage(url)
            .placeholder {
                placeholder
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(8)
        
        
        
//        AsyncDownSamplingImage(
//                                 url: url,
//                                 downsampleSize: .height(
//                                     Util.VStack.bufferedImageHeight
//                                 )
//                             ) { image in
//                                 image
//                                     .resizable()
//                                     .aspectRatio(contentMode: .fit)
//                                     .scaledToFit() // Ensure image fits the frame size
//                                     .cornerRadius(8)
//
//                             } onFail: { error in
//                                 Image("2")
//                                     .resizable()
//                                     .aspectRatio(contentMode: .fit)
//                                     .scaledToFit() // Ensure image fits the frame size
//                             }
        
        
    }
}



// --------


//-----
#if os(iOS)
import UIKit
typealias ImageType = UIImage
#elseif os(macOS)
import AppKit
typealias ImageType = NSImage
#endif

import SwiftUI

extension Image {
    init(imageType: ImageType) {
        #if os(iOS)
        self = Image(uiImage: imageType)
        #elseif os(macOS)
        self = Image(nsImage: imageType)
        #endif
    }
}

//
//  IncrementalImage.swift
//
//
//  Created by Fumiya Tanaka on 2024/08/03.
//

import Foundation
import SwiftUI

/// `IncrementalImage` is a SwiftUI view that asynchronously fetches and displays an image from a given URL incrementally.
///
/// This view is particularly useful for displaying large images that need to be loaded in chunks to avoid blocking the main thread.
///
/// - Parameters:
///   - url: A binding to the URL from which the image will be fetched. This URL can be changed dynamically.
///   - bufferSize: The size of the buffer in bytes used for incremental loading. The default value is 1KB.
///
/// The view displays a `EmptyView` while the image is being fetched. Once the image is fully loaded, it is displayed using an `Image` view.
///
/// Example usage:
/// ```
/// @State private var imageURL: URL? = URL(string: "https://via.placeholder.com/1000")
///
/// var body: some View {
///     IncrementalImage(url: $imageURL)
/// }
/// ```
public struct IncrementalImage: View {

    /// resource URL where you would like to fetch an image.
    ///
    /// Example:  https://via.placeholder.com/1000
    @Binding public var url: URL?

    /// unit byte size to perform incremental image
    ///
    /// example: `1 * 1024 ... 1KB`
    public let bufferSize: Int

    public let animation: Animation?

    @MainActor @State private var image: CGImage?

    @State private var lastUpdateTime: Date = Date()
    @State private var pendingUpdate: CGImage?
    @State private var isUpdating: Bool = false

    // 20ms
    let timing = 0.02

    public var body: some View {
        Group {
            if let image {
                Image(
                    image,
                    scale: 1,
                    label: Text(
                        String(describing: self)
                    )
                )
                .resizable()
                .aspectRatio(contentMode: .fit)
            } else {
                VStack {}
            }
        }
        .task {
            try! await Incremental.perform(
                at: url,
                bufferSize: bufferSize,
                onUpdate: { newImage in
                    throttledUpdate(newImage)
                }
            )
        }
    }

    @MainActor private func throttledUpdate(_ newImage: CGImage) {
        let currentTime = Date()
        if currentTime.timeIntervalSince(lastUpdateTime) >= timing {
            performUpdate(newImage)
            lastUpdateTime = currentTime
        } else {
            pendingUpdate = newImage
            if !isUpdating {
                isUpdating = true
                DispatchQueue.main.asyncAfter(deadline: .now() + timing) {
                    if let pendingImage = self.pendingUpdate {
                        self.performUpdate(pendingImage)
                    }
                    self.isUpdating = false
                    self.pendingUpdate = nil
                }
            }
        }
    }

    @MainActor private func performUpdate(_ newImage: CGImage) {
        if let animation {
            withAnimation(animation) {
                self.image = newImage
            }
        } else {
            self.image = newImage
        }
    }

    private func throttle(_ block: @escaping () -> Void) {
        let currentTime = Date()
        if currentTime.timeIntervalSince(lastUpdateTime) >= timing {
            block()
            lastUpdateTime = currentTime
        }
    }

    public init(url: Binding<URL?>, bufferSize: Int = 1 * 1024, animation: Animation? = nil) {
        self._url = url
        self.bufferSize = bufferSize
        self.animation = animation
    }
}

import Foundation
import ImageIO

public struct Incremental {
    public static func perform(
        at url: URL?,
        bufferSize: Int = 32 * 1024, // 32KB
        onUpdate: @escaping @MainActor (CGImage) -> Void
    ) async throws {
        try await Task.detached(priority: .low) {
            let imageSourceOption = [
                kCGImageSourceShouldCache: true
            ] as CFDictionary
            let imageSource = CGImageSourceCreateIncremental(
                imageSourceOption
            )

            guard let url else {
                return
            }
            let (remoteData, _) = try await URLSession.shared.data(from: url)
            let inputStream = InputStream(data: remoteData)
            inputStream.open()

            var data = Data()

            var buffer = [UInt8](
                repeating: 0,
                count: bufferSize
            )
            while inputStream.hasBytesAvailable {
                try Task.checkCancellation()
                let readBytes = inputStream.read(
                    &buffer,
                    maxLength: bufferSize
                )
                if readBytes > 0 {
                    data.append(buffer, count: readBytes)
                    CGImageSourceUpdateData(
                        imageSource,
                        data as CFData,
                        false
                    )
                    if let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) {
                        await onUpdate(image)
                    }
                } else {
                    break
                }
            }
            CGImageSourceUpdateData(imageSource, data as CFData, true)
            if let image = CGImageSourceCreateImageAtIndex(imageSource, 0, imageSourceOption) {
                await onUpdate(image)
            }
            inputStream.close()
        }.value
    }
}
import Foundation
import ImageIO

public struct DownSampling {
    public enum Error: LocalizedError {
        case failedToFetchImage
        case failedToDownsample
    }

    public static func perform(
        at url: URL,
        size: DownSamplingSize
    ) async throws -> CGImage {
        let imageSourceOption = [kCGImageSourceShouldCache: true] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, imageSourceOption) else {
            throw Error.failedToFetchImage
        }

        let maxDimensionsInPixels = size.maxDimensionsInPixels

        let downsampledOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCache: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionsInPixels,
        ] as CFDictionary
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(
            imageSource,
            0,
            downsampledOptions
        ) else {
            throw Error.failedToDownsample
        }
        return downsampledImage
    }
}

fileprivate extension DownSamplingSize {
    var maxDimensionsInPixels: Double {
        switch self {
        case .size(let cGSize, let scale):
            max(cGSize.width, cGSize.height) * scale
        case .width(let double, let scale):
            double * scale
        case .height(let double, let scale):
            double * scale
        }
    }
}
import SwiftUI


private enum LoadingOpacityEdge {
    case upperBound
    case lowerBound

    var value: Double {
        switch self {
        case .upperBound:
            return 1
        case .lowerBound:
            return 0.3
        }
    }

    mutating func toggle() {
        switch self {
        case .upperBound:
            self = .lowerBound
        case .lowerBound:
            self = .upperBound
        }
    }
}

public enum DownSamplingSize {
    case size(CGSize, scale: Double = 1)
    case width(Double, scale: Double = 1)
    case height(Double, scale: Double = 1)

    public var width: Double? {
        switch self {
        case .size(let cGSize, _):
            cGSize.width
        case .width(let double, _):
            double
        case .height:
            nil
        }
    }

    public var height: Double? {
        switch self {
        case .size(let cGSize, _):
            cGSize.height
        case .width:
            nil
        case .height(let double, _):
            double
        }
    }

    var size: (width: CGFloat?, height: CGFloat?) {
        let width: CGFloat? = if let width {
            width
        } else {
            nil
        }
        let height: CGFloat? = if let height {
            height
        } else {
            nil
        }
        return (width, height)
    }
}

/// AsyncDownSamplingImage is a ImageView that can perform downsampling and use less memory use than `AsyncImage`.
///
/// Generic Types:
/// - `Content`: The view displayed when the image is successfully loaded.
/// - `Placeholder`: The view displayed while the image is loading.
/// - `Fail`: The view displayed when the image fails to load.
public struct AsyncDownSamplingImage<Content: View, Placeholder: View, Fail: View>: View {

    /// resource URL where you would like to fetch an image.
    ///
    /// Example: https://via.placeholder.com/1000
    @Binding public var url: URL?
    /// image size to perform downsampling.
    @Binding public var downsampleSize: DownSamplingSize

    /// View which appears when `status` is `Status.loaded`.
    public let content: (Image) -> Content
    /// View which appears when `status` is `Status.loading`.
    public let onLoad: (() -> Placeholder)?
    /// View which appears when `status` is `Status.failed`.
    public let onFail: (any Error) -> Fail

    @State private var status: Status = .idle
    @State private var loadingOpacity: LoadingOpacityEdge = .upperBound

    /// A initializer that requires exact downsampling size.
    ///
    /// - Parameters:
    ///     - url: a resource url which should be downsampled.
    ///     - downSamplingSize: final image buffer size after downsampling.
    ///         choose from ``DownSamplingSize.width``, ``DownSamplingSize.height`` or ``DownSamplingSize.size``
    ///     - content: UI builder which takes ``Image`` as an argument after image is fetched and downsampled.
    ///     - onLoad: UI builder used when ``Image`` is loading or in downsampling phase.
    ///     - onFail: UI builder used when something wrong happened in downsampling phase.
    public init(
        url: Binding<URL?>,
        downsampleSize: Binding<DownSamplingSize>,
        content: @escaping (Image) -> Content,
        onLoad: @escaping () -> Placeholder,
        onFail: @escaping (any Error) -> Fail
    ) {
        self._url = url
        self._downsampleSize = downsampleSize
        self.content = content
        self.onLoad = onLoad
        self.onFail = onFail
        self.status = status

        if let url = self.url {
            startLoading(url: url)
        }
    }

    public var body: some View {
        imageView
            .onAppear {
                if case Status.idle = status, let url {
                    startLoading(url: url)
                }
            }
            .onChange(of: url) { url in
                guard let url else {
                    status = .idle
                    return
                }
                startLoading(url: url)
            }
    }

    @ViewBuilder
    var imageView: some View {
        switch status {
        case .idle:
            loadingView
        case .loading:
            if let onLoad {
                onLoad()
            } else {
                loadingView
            }
        case .failed(let error):
            onFail(error)
        case .loaded(let image), .reloading(let image):
            content(image)
        }
    }

    var loadingView: some View {
        return Image(systemName: "plus") // any image is okay
            .resizable()
            .cornerRadius(2)
            .opacity(loadingOpacity.value)
            .animation(
                Animation.easeInOut(duration: 0.7).repeatForever(autoreverses: true),
                value: loadingOpacity
            )
            .frame(
                width: downsampleSize.size.width,
                height: downsampleSize.size.height
            )
            .redacted(reason: .placeholder)
            .onAppear {
                loadingOpacity.toggle()
            }
    }

    func startLoading(url: URL) {
        if case Status.loaded(let image) = status {
            status = .reloading(image)
        } else {
            status = .loading
        }
        Task.detached {
            do {
                let cgImage = try await DownSampling.perform(
                    at: url,
                    size: downsampleSize
                )
            #if os(macOS)
                let aspectRatio = Double(cgImage.height) / Double(cgImage.width)
                let downsampleSize = await self.downsampleSize
                let width = downsampleSize.width ?? downsampleSize.height! / aspectRatio
                let height = downsampleSize.height ?? downsampleSize.width! * aspectRatio
                let image = ImageType(
                    cgImage: cgImage,
                    size: CGSize(
                        width: width,
                        height: height
                    )
                )
#elseif os(iOS)
                let image = ImageType(
                    cgImage: cgImage
                )
                #endif
                await MainActor.run {
                    status = .loaded(Image(imageType: image))
                }
            } catch {
                await MainActor.run {
                    status = .failed(error)
                }
            }
        }
    }
}

extension AsyncDownSamplingImage {
    enum Status {
        case idle
        case loading
        case reloading(Image)
        case failed(Error)
        case loaded(Image)
    }
}

// MARK: Simple initializer
extension AsyncDownSamplingImage {
    public init(
        url: URL?,
        downsampleSize: Binding<DownSamplingSize>,
        content: @escaping (Image) -> Content,
        onFail: @escaping (any Error) -> Fail
    ) where Placeholder == EmptyView {
        self._url = .constant(url)
        self._downsampleSize = downsampleSize
        self.content = content
        self.onLoad = nil
        self.onFail = onFail
        self.status = status
    }

    public init(
        url: URL?,
        downsampleSize: DownSamplingSize,
        content: @escaping (Image) -> Content,
        onFail: @escaping (any Error) -> Fail
    ) where Placeholder == EmptyView {
        self._url = .constant(url)
        self._downsampleSize = .constant(downsampleSize)
        self.content = content
        self.onLoad = nil
        self.onFail = onFail
        self.status = status
    }

    public init(
        url: URL?,
        downsampleSize: Binding<DownSamplingSize>,
        content: @escaping (Image) -> Content,
        placeholder: @escaping () -> Placeholder,
        onFail: @escaping (any Error) -> Fail
    ) where Placeholder == EmptyView {
        self._url = .constant(url)
        self._downsampleSize = downsampleSize
        self.content = content
        self.onLoad = placeholder
        self.onFail = onFail
        self.status = status
    }

    public init(
        url: URL?,
        downsampleSize: DownSamplingSize,
        content: @escaping (Image) -> Content,
        onLoad: @escaping () -> Placeholder,
        onFail: @escaping (any Error) -> Fail
    ) {
        self._url = .constant(url)
        self._downsampleSize = .constant(downsampleSize)
        self.content = content
        self.onLoad = onLoad
        self.onFail = onFail
        self.status = status
    }
}

enum Util {
    enum Grid {
        static let url = URL(string: "https://picsum.photos/1000/1000")
        static let bufferedImageSize = CGSize(width: 60, height: 60)
    }
    enum VStack {
        static let url = URL(string: "https://picsum.photos/800/600")
        static let bufferedImageHeight = 60.0
    }
}

