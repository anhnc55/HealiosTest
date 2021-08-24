//
//  PostsUseCase.swift
//  Healios
//
//  Created by Anh Nguyen on 24/08/2021.
//
import Combine

protocol PostsUseCaseType {
    func getPosts() -> AnyPublisher<[Post], APIError>
    func savePostsToDB(_ posts: [Post]) -> AnyPublisher<Bool, Error>
    func retrievePostFromDB() -> AnyPublisher<[Post], Error>

}

struct PostsUseCase: PostsUseCaseType {
    func getPosts() -> AnyPublisher<[Post], APIError> {
        Post.getPosts()
    }
    
    func savePostsToDB(_ posts: [Post]) -> AnyPublisher<Bool, Error> {
        Post.savePostsToDB(posts)
    }
    
    func retrievePostFromDB() -> AnyPublisher<[Post], Error> {
        Post.retrievePostFromDB()
    }
}
