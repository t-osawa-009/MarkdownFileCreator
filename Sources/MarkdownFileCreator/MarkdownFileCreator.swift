import Foundation
import Files

struct MarkdownFileCreator: FileCreatable {
    private let outputPath: String
    private let results: String
    init(outputPath: String, results: String) {
        self.outputPath = outputPath
        self.results = results
    }
    
    func write() throws {
        let urlPath = URL(fileURLWithPath: outputPath)
        let path = urlPath.deletingLastPathComponent().absoluteString
        let _path = path.replacingOccurrences(of: "file://", with: "")
        let folder = try Folder(path: _path)
        let fileName = urlPath.lastPathComponent
        let file = try folder.createFileIfNeeded(at: fileName.replacingOccurrences(of: "file://", with: ""))
        let pathExtension = urlPath.pathExtension
        guard pathExtension == PathExtension.markdown.rawValue else {
            print("⚠️: format is not json")
            throw CreatorError.invalidFormat
        }
        
        let oldData = try file.readAsString()
        if oldData == results {
            print("Not writing the file as content is unchanged")
        } else {
            try file.write(results)
            print("Generate Success")
        }
    }
}
