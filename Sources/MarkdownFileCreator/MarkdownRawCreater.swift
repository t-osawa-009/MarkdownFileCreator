import Foundation

final class MarkdownRawCreater {
    private var map: [[String: Any]]
    private var keys: [String]
    init(map: [[String: Any]], keys: [String]) {
        self.map = map
        self.keys = keys
    }
    
    func create() -> String {
        var results = [String]()
        map.forEach { dic in
            var text = ""
            keys.forEach { key in
                let object: Any
                if key.contains("."), let value = dic.valueForKeyPath(keyPath: key) {
                    object = value
                } else {
                    object = dic[key] ?? ""
                }
            
                let jsonStr = Self.stringify(json: object)
                text += "| \(jsonStr) "
            }
            text += "|"
            results.append(text)
        }
        let new = results.joined(separator: "\n")
        let headerText = keys.joined(separator: "  |")
        let markText = keys.map({ _ in "---|" }).joined()
        let header = """
|\(headerText)
|\(markText)
"""
        return header + "\n" + new
    }
    
    private static func stringify(json: Any) -> String {
        guard JSONSerialization.isValidJSONObject(json) else {
            return "\(json)"
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted, .sortedKeys])
            if let string = String(data: data, encoding: String.Encoding.utf8) {
                return string.replacingOccurrences(of: "\n", with: "<br>")
            }
        } catch {
            print(error)
        }
        
        return "\(json)"
    }
}

extension Dictionary {
    public func valueForKeyPath(keyPath: String) -> Any? {
        var keys = keyPath.components(separatedBy: ".")
        guard let first = keys.first as? Key else { print("Unable to use string as key on type: \(Key.self)"); return nil }
        guard let value = self[first] else { return nil }
        keys.remove(at: 0)
        if !keys.isEmpty, let subDict = value as? [String : Any] {
            let rejoined = keys.joined(separator: ".")
            return subDict.valueForKeyPath(keyPath: rejoined)
        }
        return value
    }
}
