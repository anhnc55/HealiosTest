enum Endpoint {
    case posts
    case users
    case comments
    
    func path() -> String {
        switch self {
        case .posts:
            return "posts"
        case .users:
            return "users"
        case .comments:
            return "comments"
        }
    }
}
