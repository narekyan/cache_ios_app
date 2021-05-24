//
//  NetworkFeature.swift
//  BrainTest
//
//  Created by Narek on 01/17/21.
//

import Foundation
import Combine

class NetworkFeature {
    
    private let session: URLSession
    init(session: URLSession = .shared) {
        self.session = session
    }

    func get<T: Decodable>(_ url: String) -> PassthroughSubject<T?, Error> {
        let signal = PassthroughSubject<T?, Error>()
        guard let url = URL(string: url) else {
            signal.send(completion: .failure(NSError(domain: "wrong url", code: -1000, userInfo: nil)))
            return signal
        }
        session.dataTask(with: url, completionHandler: { (data, urlReponse, error) in
            var response: T?
            defer {
                signal.send(response)
            }
            guard let data = data, (200..<300).contains((urlReponse as? HTTPURLResponse)?.statusCode ?? 0) else {
                signal.send(completion: .failure(error!))
                return
            }
            do  {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                response = try decoder.decode(T.self, from: data)
            
            } catch {
                signal.send(completion: .failure(error))
            }
        }).resume()
        return signal
    }
    
    func constructQuery(params:[String: String]) -> String {
        return params.reduce("") { (result, item) -> String in
            return result + "&\(item.key)=\(item.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        }
    }
}
