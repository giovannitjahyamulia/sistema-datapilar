//
//  APIService.swift
//  SistemaDatapilar
//
//  Created by Giovanni Tjahyamulia on 04/09/23.
//

import Alamofire
import Foundation

class APIService {
    static let instance = APIService()
    
    // Alamofire Fetch Data Function
    
    func fetchList(completion: @escaping ([Meal]?) -> Void) {
        let request = AF.request(EndPoint.fetchList.url)
        
        request.responseDecodable(of: ResponseMeal.self) { (response) in
            
            if let meals = response.value?.meals {
                completion(meals)
            }
            else {
              return
            }
        }
    }
     
    func fetchDetail(idMeal: String, completion: @escaping (Meal?) -> Void) {
        let request = AF.request("\(EndPoint.fetchDetail.url)\(idMeal)")
        
        request.responseDecodable(of: ResponseMeal.self) { (response) in
            if let meal = response.value?.meals[0] {
                completion(meal)
            }
            else {
                return
            }
        }
    }
    
    /*
    func retrieve<T: Decodable>(
        type: T.Type,
        endpoint: EndPoint,
        completion: @escaping (Result<T, Error>) -> ()
    ) {
        URLSession.shared.dataTask(with: endpoint.url) { data, response, error in
            guard error == nil else { return }
            guard let data = data else { return }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            }
            catch let err {
                DispatchQueue.main.async {
                    completion(.failure(err))
                }
            }
        }.resume()
    }
    */
}
