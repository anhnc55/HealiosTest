import Foundation
import Combine

class API {
    static let shared = API()
    static private let BASE_URL = "http://jsonplaceholder.typicode.com/"

    private var session: URLSession
    private let decoder: JSONDecoder
    
    private var oauthStateCancellable: AnyCancellable?
    
    init() {
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        session = URLSession(configuration: Self.makeSessionConfiguration())
    }
    
    static private func makeSessionConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        let headers = [
            "Content-Type": "application/json; charset=utf-8",
            "Accept": "application/json"
        ]
        configuration.httpAdditionalHeaders = headers
        configuration.urlCache = .shared
        configuration.requestCachePolicy = .reloadRevalidatingCacheData
        configuration.timeoutIntervalForRequest = 120
        configuration.timeoutIntervalForResource = 120
        return configuration
    }
    
    static private func makeURL(endpoint: Endpoint) -> URL {
        let url = URL(string: BASE_URL)?.appendingPathComponent(endpoint.path())
        let component = URLComponents(url: url!, resolvingAgainstBaseURL: false)!
        return component.url!
    }
    
    static private func makeRequest(url: URL,
                                    httpMethod: String = "GET",
                                    params: [String: String]? = nil) -> URLRequest {
        var request = URLRequest(url: url)

        request.httpMethod = httpMethod
        return request
    }
    
    func request<T: Decodable>(endpoint: Endpoint,
                               httpMethod: String = "GET",
                               params: [String: String]? = nil) -> AnyPublisher<[T] ,APIError> {
        let url = Self.makeURL(endpoint: endpoint)
        let request = Self.makeRequest(url: url,
                                       httpMethod: httpMethod,
                                       params: params)
        return executeRequest(publisher: session.dataTaskPublisher(for: request))
    }
    
    private func executeRequest<T: Decodable>(publisher: URLSession.DataTaskPublisher) -> AnyPublisher<[T], APIError> {
        publisher
            .tryMap { data, response in
                try self.processResponse(data: data, response: response)
            }
            .handleEvents(receiveOutput: {
                do {
                    _ = try JSONSerialization.jsonObject(with: $0, options: []) as? [String: Any]
                } catch {
                    print(error.localizedDescription)
                }
            })
            .print()
            .decode(type: [T].self, decoder: decoder)
            .mapError {
                APIError.parseError(reason: $0)
            }
            .eraseToAnyPublisher()
    }
    
    private func processResponse(data: Data, response: URLResponse) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown(data: data)
        }
        if (httpResponse.statusCode == 404) {
            throw APIError.message(reason: "Resource not found", data: data)
        }
        if 200 ... 299 ~= httpResponse.statusCode {
            return data
        } else {
            do {
                let error = try decoder.decode(APIResponseError.self, from: data)
                throw APIError.responseError(error: error, data: data)
            } catch {
                throw APIError.unknown(data: data)
            }
        }
    }
}
