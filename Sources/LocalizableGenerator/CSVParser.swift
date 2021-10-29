import Foundation

struct LocalizedModel {
    let key: String
    let value: String
}

enum ParseError: Error {
    case failParse
}

func parser(_ csv: String) -> Result<[String: [LocalizedModel]], Error> {
    let rows = csv.split(separator: "\r\n")
    guard rows.isEmpty == false,
    let firstRow = rows.first else {
        return .failure(ParseError.failParse)
    }
    let languages = firstRow
        .split(separator: ",")
        .filter { $0.contains("ios") == false }
    guard languages.isEmpty == false else {
        return .failure(ParseError.failParse)
    }
    var localizables = [String: [LocalizedModel]]()
    localizables.reserveCapacity(rows.count - 1)
    
    languages.forEach { subs in
        localizables[String(subs)] = []
    }
    rows[1...].forEach { subs in
        let row = subs.split(separator: ",")
        guard row.isEmpty == false else {
            return
        }
        let key = row[0]
        languages
            .enumerated()
            .forEach { (index, lang) in
                let model = LocalizedModel(key: String(key), value: String(row[index + 1]))
                localizables[String(lang)]?.append(model)
            }
    }
    return .success(localizables)
}
