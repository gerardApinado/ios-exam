//
//  PersonsService.swift
//  LazyLoadingList
//
//  Created by Gerard on 8/23/24.
//

import Foundation
import UIKit

class PersonService {
    
    static let shared = PersonService()
    
    private init() {
        
    }
    
    func fetchPersons(results: Int, completion: @escaping (Result<[Person], APError>) -> Void) {
        let urlString = String(format: APIConstants.Person.getNumberOfPersons, results) 
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, res, error in
            if let error = error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let res = res as? HTTPURLResponse, res.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Response Data as JSON: \(json)")
                }
                let persons = try JSONDecoder().decode([Person].self, from: data)
                completion(.success(persons))
            } catch {
                completion(.failure(.invalidData))
            }
        }.resume()
    }
    
    func loadMorePersons(completion: @escaping () -> Void) {
        
        completion()
    }
    
}
