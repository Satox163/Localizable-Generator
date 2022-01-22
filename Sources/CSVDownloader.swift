import Foundation

enum DownloadError: Swift.Error {
    case networkError(Swift.Error)
    case otherError
}

func download(url: URL) async throws -> String {
    let config = URLSessionConfiguration.ephemeral
    let urlSession = URLSession(configuration: config)
    
    let (data, _) = try await urlSession.data(from: url)
    
    if let csv: String = .init(data: data, encoding: .utf8) {
        return csv
    }
    throw DownloadError.otherError
}
