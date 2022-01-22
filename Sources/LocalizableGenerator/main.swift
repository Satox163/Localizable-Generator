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
    
    mutating func run() throws {
        let path = (Path.current + Path(fileName))
        do {
            let csvString: String = try path.read()
            let data = try parser(csvString).get()
            try fileGenerator(data: data)
            exitSuccess()
        } catch {
            exitFailure()
        }
        dispatchMain()
    }
}

Main.main()
