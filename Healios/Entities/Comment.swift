// MARK: - Comment
struct Comment: Codable {
    let postId, id: Int64
    let name, email, body: String
}

extension Comment: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
