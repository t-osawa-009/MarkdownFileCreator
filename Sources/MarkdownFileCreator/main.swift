import Foundation
import Commander
import Files
import Yams

let main = command(
    Option<String>("sourcefile", default: ".", description: "parse files"),
    Option<String?>("output_path", default: nil, description: "out put files"),
    Option<String>("keys", default: "", description: "Keys to parse"),
    Option<String>("verbose", default: "false", description: "Display the log")
) { sourcefile, output_path, keys, verbose in
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
    
    let isVerbose = verbose.lowercased() == "true"

    switch PathExtension(rawValue: fileExtension) {
    case .json:
        do {
            let data = try file.read()
            let json = try JSONSerialization.jsonObject(with: data)
            let dictionary: [[String: Any]] = {
                if let array = json as? [[String: Any]] {
                    return array
                }
                
                if let dic = json as? [String: Any] {
                    return [dic]
                }
                
                return []
            }()
            if isVerbose {
                print("json: \n" + dictionary.description)
            }
            let newText = MarkdownRawCreater(map: dictionary, keys: keyArray).create()
            
            if isVerbose {
                print("md: \n" + newText)
            }
            try MarkdownFileCreator(outputPath: output_path ?? file.nameExcludingExtension + ".md", results: newText).write()
        } catch {
            Logger.log(error.localizedDescription)
        }
    case .yml, .yaml:
        do {
            let str = try file.readAsString()
            if isVerbose {
                print("\(file.extension ?? ""): \n\(str)")
            }
            var items = try Yams.load_all(yaml: str)
            var dictionary = [[String: Any]]()
            while let item = items.next() {
                if let array = item as? [[String: Any]] {
                    dictionary.append(contentsOf: array)
                }
                
                if let dic = item as? [String: Any] {
                    dictionary.append(contentsOf: [dic])
                }
            }
            let newText = MarkdownRawCreater(map: dictionary, keys: keyArray).create()
            if isVerbose {
                print("md: \n" + newText)
            }
            try MarkdownFileCreator(outputPath: output_path ?? file.nameExcludingExtension + ".md", results: newText).write()
        } catch {
            Logger.log(error.localizedDescription)
        }
    default:
        Logger.log("Not support file extension")
        break
    }
}
main.run()
