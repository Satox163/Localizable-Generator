import ArgumentParser
import Foundation
import PathKit

func exitSuccess() {
    exit(EXIT_SUCCESS)
}

func exitFailure() {
    exit(EXIT_FAILURE)
}

actor Main: ParsableCommand {
    @Option(help: "source file path")
    var sourceFilePath: String?
    
    @Option(help: "source file path")
    var sourceFileURL: String?
    
    @Argument(help: "output path")
    var outputPath: String
    
    nonisolated func run() throws {
        Task {
            func csvString(sourceFilePath: String?, sourceFileURL: String?) async throws -> String {
                if let sourceFilePath = sourceFilePath {
                    let path = (Path.current + Path(sourceFilePath))
                    return try path.read()
                }
                if let sourceFileURL = sourceFileURL,
                   let url = URL(string: sourceFileURL) {
                    return try await download(url: url)
                }
                return ""
            }
            do {
                let content = try await csvString(
                    sourceFilePath: sourceFilePath,
                    sourceFileURL: sourceFileURL
                )
                let data = try parser(content)
                try await fileGenerator(outputPath: outputPath, data: data)
                exitSuccess()
            } catch {
                print(error)
                exitFailure()
            }
        }
        dispatchMain()
    }
}

Main.main()
