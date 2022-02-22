import Foundation
import CoreXLSX

func xlsParser(_ filePath: String) throws -> [String: [LocalizedModel]] {
    guard let file = XLSXFile(filepath: filePath),
          let firstWbk = (try file.parseWorkbooks()).first,
          let firstWorksheet = (try file.parseWorksheetPathsAndNames(workbook: firstWbk)).first,
          let sharedStrings = try file.parseSharedStrings() else {
              fatalError("XLSX file at is corrupted or does not exist")
          }

    let worksheet = try file.parseWorksheet(at: firstWorksheet.path)

    let languages = worksheet.data?.rows.first
        .map { row -> [String] in
            worksheet
                .cells(atRows: row.cells.map(\.reference.row))
                .dropFirst()
                .compactMap { $0.stringValue(sharedStrings) }
        } ?? []

    var localizables = [String: [LocalizedModel]]()

    languages.forEach { subs in
        localizables[String(subs.lowercased())] = []
    }

    worksheet
        .data?
        .rows[1...]
        .forEach { row in
            let result: [String?] = row.cells.map {
                if let value = $0.stringValue(sharedStrings) {
                    return value
                }
                let richString = $0.richStringValue(sharedStrings)
                if richString.isEmpty == false {
                    return richString.reduce("") { partialResult, rich in
                        return partialResult + (rich.text ?? "")
                    }
                }
                return nil
            }

            guard let key = result.first as? String,
                  result.isEmpty == false else { return }

            result[1...].enumerated().forEach { (index, string) in
                guard let string = string,
                      string.isEmpty == false else { return }
                let model = LocalizedModel(key: key, value: string)
                let valueIndex = index
                if languages.indices.contains(valueIndex) {
                    localizables[languages[valueIndex].lowercased()]?.append(model)
                }
            }
        }
    return localizables
}
