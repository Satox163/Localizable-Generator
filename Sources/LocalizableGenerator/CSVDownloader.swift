import Foundation


enum DownloadError: Swift.Error {
    case networkError(Swift.Error)
    case otherError
}

func download(url: URL, responseCallback: @escaping (Result<String, Error>) -> Void) {
    let config = URLSessionConfiguration.ephemeral
    let urlSession = URLSession(configuration: config)

    print("Downloading Localizable file ...")
    urlSession.dataTask(with: url) { data, response, error in
        print("Finished downloading Localizable file ...")
        if let error = error {
            responseCallback(.failure(DownloadError.networkError(error)))
            return
        }
        if let csv = data.flatMap({ String.init(data: $0, encoding: .utf8) }) {
            responseCallback(.success(csv))
        } else {
            responseCallback(.failure(DownloadError.otherError))
        }
    }
    .resume()
}
