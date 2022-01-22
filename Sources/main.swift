import ArgumentParser
import Foundation
import PathKit

func exitSuccess() {
    exit(EXIT_SUCCESS)
}

func exitFailure() {
    exit(EXIT_FAILURE)
}

struct Main: ParsableCommand {
    @Argument(help: "file name")
    var fileName: String
    
    @Argument(help: "output path")
    var outputPath: String
    
    mutating func run() throws {
        print(fileName)
        print(outputPath)
        let path = (Path.current + Path(fileName))
        do {
            let csvString: String = try path.read()
            let data = try parser(csvString).get()
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
