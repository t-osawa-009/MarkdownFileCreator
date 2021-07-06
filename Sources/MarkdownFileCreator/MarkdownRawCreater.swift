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
                text += "| \(dic[key] ?? "") "
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
}
