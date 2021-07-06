protocol FileCreatable {
    func write() throws
}

enum CreatorError: Error {
    case invalidFormat
}

enum PathExtension: String {
    case json
    case yml
    case yaml
    case markdown = "md"
}
