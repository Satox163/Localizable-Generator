import Foundation

func fileGenerator(data: [String: [LocalizedModel]]) throws {
    let fileManager = FileManager.default
    data.forEach { (key: String, value: [LocalizedModel]) in
        let localizabeText = value.map { model in
            "\"\(model.key)\"" + " = " + "\"\(model.value)\";"
        }.joined(separator: "\n")
        let directoryPath = "\(fileManager.currentDirectoryPath)/\(key).lproj"
        try? fileManager.createDirectory(atPath: directoryPath, withIntermediateDirectories: false, attributes: [:])
        fileManager.createFile(
            atPath: "\(directoryPath)/Localizable.strings",
            contents: localizabeText.data(using: .utf8),
            attributes: [:]
        )
    }
}
