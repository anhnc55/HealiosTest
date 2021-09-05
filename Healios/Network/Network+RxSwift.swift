//
//  Network+RxSwift.swift
//  Network+RxSwift
//
//  Created by Anh Nguyen on 05/09/2021.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift

final class Network<T: Decodable> {
    private let BASE_URL = "http://jsonplaceholder.typicode.com"
    private let scheduler = ConcurrentDispatchQueueScheduler(qos: DispatchQoS(qosClass: DispatchQoS.QoSClass.background, relativePriority: 1))

    func getItems(_ endPoint: Endpoint) -> Observable<[T]> {
        let absolutePath = "\(BASE_URL)/\(endPoint.path())"
        return RxAlamofire
            .data(.get, absolutePath)
            .debug()
            .observe(on: scheduler)
            .map({ data -> [T] in
                return try JSONDecoder().decode([T].self, from: data)
            })
    }
}
