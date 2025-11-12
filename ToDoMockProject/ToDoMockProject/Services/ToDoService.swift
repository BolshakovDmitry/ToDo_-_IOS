import Foundation

final class ToDoService {
    let networkClient = NetworkClient()
    
    func fetchToDoes(){
        guard let url = URL(string: Constans.url) else { return }
        let request = URLRequest(url: url)
        networkClient.fetch(type: ToDoResponse.self, urlRequest: request) { result in
            switch result {
            case .success(let ToDoResponse):
                print(ToDoResponse.todos[2])
            case .failure(let NetworkErrors):
                print(NetworkErrors)
                
            }
        }
    }
    
    
    
}
