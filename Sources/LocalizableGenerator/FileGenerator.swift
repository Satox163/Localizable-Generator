import Foundation

func fileGenerator(data: [String: [LocalizedModel]]) throws {
    
    let fileManager = FileManager.default
    
    try data.forEach { (key: String, value: [LocalizedModel]) throws in
        let localizabeText = value
            .map { model in
                "\"\(model.key)\"" + " = " + "\"\(model.value)\";"
            }
            .joined(separator: "\n")
        let directoryPath = "\(fileManager.currentDirectoryPath)/\(key).lproj"
        var isDir: ObjCBool = true
        if fileManager.fileExists(atPath: directoryPath, isDirectory: &isDir) {
            try fileManager.removeItem(atPath: directoryPath)
        }
        try fileManager.createDirectory(atPath: directoryPath, withIntermediateDirectories: false, attributes: [:])
        let filePath = "\(directoryPath)/Localizable.strings"
        isDir = false
        if fileManager.fileExists(atPath: filePath, isDirectory: &isDir) {
            try fileManager.removeItem(atPath: filePath)
        }
        fileManager.createFile(
            atPath: filePath,
            contents: localizabeText.data(using: .utf8),
            attributes: [:]
        )
    }
}
