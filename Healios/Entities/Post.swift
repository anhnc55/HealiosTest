import CoreData

struct Post: Decodable {
    var id: Int64
    var userId: Int64
    var title: String?
    var body: String?
}

extension Post: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Post {
    func toPostMO() -> PostMO {
        let postMO = PostMO()
        postMO.id = id
        postMO.userId = userId
        postMO.body = body
        postMO.title = title
        return postMO
    }
}
