import ArgumentParser
import Foundation
import PathKit
import Localizable_Core

func exitSuccess() {
    exit(EXIT_SUCCESS)
}

func exitFailure() {
    exit(EXIT_FAILURE)
}

struct Main: ParsableCommand {
    @Argument(help: "source file path")
    var sourceFilePath: String
    
    @Argument(help: "output path")
    var outputPath: String
    
    func run() throws {
        do {
            let path = (Path.current + Path(sourceFilePath))

            let data = try xlsParser(path.string)
            try fileGenerator(outputPath: outputPath, data: data)
            exitSuccess()
        } catch {
            print(error)
            exitFailure()
        }
        dispatchMain()
    }
}

Main.main()
