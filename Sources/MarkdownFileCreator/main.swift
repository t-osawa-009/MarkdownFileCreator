import Foundation
import Commander
import Files
import Yams

let main = command(
    Option<String>("sourcefile", default: ".", description: "parse files"),
    Option<String?>("output_path", default: nil, description: "out put files"),
    Option<String>("keys", default: "", description: "Keys to parse")
) { sourcefile, output_path, keys in
    guard let file = try? File(path: sourcefile) else {
        Logger.log("Not found file")
        return
    }
    
    guard let fileExtension = file.extension else {
        Logger.log("Not found file extension")
        return
    }
    let keyArray = keys.split(separator: ",").map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
    guard !keyArray.isEmpty else {
        Logger.log("keys is Empty")
        return
    }

    switch PathExtension(rawValue: fileExtension) {
    case .json:
        do {
            let data = try file.read()
            let dictionary = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] ?? []
            let newText = MarkdownRawCreater(map: dictionary, keys: keyArray).create()
            print(newText)
            try MarkdownFileCreator(outputPath: output_path ?? UUID().uuidString + ".md", results: newText).write()
        } catch {
            Logger.log(error.localizedDescription)
        }
    case .yml, .yaml:
        do {
            let str = try file.readAsString()
            var items = try Yams.load_all(yaml: str)
            print(items)
            var dictionary = [[String: Any]]()
            while let item = items.next() {
                if let _item = item as? [[String: Any]] {
                    dictionary.append(contentsOf: _item)
                }
            }
            let newText = MarkdownRawCreater(map: dictionary, keys: keyArray).create()
            print(newText)
            try MarkdownFileCreator(outputPath: output_path ?? UUID().uuidString + ".md", results: newText).write()
        } catch {
            Logger.log(error.localizedDescription)
        }
    default:
        Logger.log("Not support file extension")
        break
    }
}
main.run()
