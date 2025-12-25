//
//  NetworkingManager.swift
//  CryptoSwiftUI
//
//  Created by Antony Huaman Alikhan on 24/12/25.
//

import Foundation
import Combine

class NetworkingManager {
    
    enum NetWorkingError : LocalizedError {
        case badURLResponse(url: URL?)
        case unknown
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url): return "[🔥] Bad URL Response: \(String(describing: url))"
            case .unknown: return "[⚠️] Unknown Error"
                
            }
        }
    }
    static func download(request:URLRequest) -> AnyPublisher<Data, Error> {
        
        return URLSession.shared.dataTaskPublisher(for: request)
             .subscribe(on: DispatchQueue.global(qos: .default))
             .tryMap( {
                 try handleURLResponse(output:$0, url: (request.url ?? URL(string: "Empty URL")!))
                }
             )
             .receive(on: DispatchQueue.main)
             .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url:URL) throws -> Data {
        if let response = output.response as? HTTPURLResponse {
                        print("DEBUG: Status Code: \(response.statusCode)")
                        if response.statusCode == 429 {
                            print("DEBUG: You are Rate Limited! Wait 1 minute.")
                        }
            guard response.statusCode >= 200 && response.statusCode < 300 else {
                throw NetWorkingError.badURLResponse(url: url)
            }
                    }
                    return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure (let error):
            if let decodingError = error as? DecodingError {
                        switch decodingError {
                        case .typeMismatch(let type, let context):
                            print("❌ Type Mismatch: Expected \(type) but found something else.")
                            print("   Field: \(context.codingPath.last?.stringValue ?? "Unknown")")
                        case .valueNotFound(let type, let context):
                            print("❌ Value Not Found: Expected \(type) but it was null/missing.")
                            print("   Field: \(context.codingPath.last?.stringValue ?? "Unknown")")
                        case .keyNotFound(let key, _):
                            print("❌ Key Not Found: The JSON doesn't have the key '\(key.stringValue)'.")
                            print("   Make sure your struct matches the API exactly.")
                        case .dataCorrupted(let context):
                            print("❌ Data Corrupted: \(context.debugDescription)")
                        @unknown default:
                            print("❌ Unknown Decoding Error")
                        }
                    } else {
                        print("Error: \(error.localizedDescription)")
                    }
        }
    }
       
}
