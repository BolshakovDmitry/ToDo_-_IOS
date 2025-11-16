import Foundation

enum NetworkErrors: Error {
    case networkError(String)
    case httpError(code: Int)
    case noData
    case dataParseError(Int)
    case decodingError
}

final class NetworkClient {
    
    func fetch<T: Codable>(type: T.Type, urlRequest: URLRequest, completion: @escaping (Result<T, NetworkErrors>) -> Void) {
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            if let error = error {
                completion(.failure(NetworkErrors.networkError(error.localizedDescription)))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                completion(.failure(NetworkErrors.httpError(code: response.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(NetworkErrors.decodingError))
            }
        }
        
        task.resume()  
    }
}
