import ArgumentParser
import Foundation

func exitSuccess() {
    exit(EXIT_SUCCESS)
}

func exitFailure() {
    exit(EXIT_FAILURE)
}

struct Main: ParsableCommand {
    @Argument(help: "google sheet url")
    var url: String
    
    mutating func run() throws {
        guard let url = URL(string: url) else {
            exitFailure()
            return
        }
        download(url: url) { response in
            do {
                let csvString = try response.get()
                let data = try parser(csvString).get()
                try fileGenerator(data: data)
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
