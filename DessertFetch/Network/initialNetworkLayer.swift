//
//  NetworkLayer.swift
//  DessertFetch
//
//  Created by Benjamin Simpson on 9/8/24.
//

import Foundation

// This is one way to call the json data, no calls are being made through here with the final network layer

protocol NetworkingProtocol {
    func fetchData(from url: URL) async throws -> Data
}

class Networking: NetworkingProtocol {
    func fetchData(from url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}

class MealService {
    private let networking: NetworkingProtocol
    private let dessertURL = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
    private let lookupURL = "https://themealdb.com/api/json/v1/1/lookup.php?i="
    
    init(networking: NetworkingProtocol = Networking()) {
        self.networking = networking
    }
    
    func getDessertMeals() async throws -> [Meal] {
        guard let url = URL(string: dessertURL) else { throw URLError(.badURL) }
        let data = try await networking.fetchData(from: url)
        let decodedResponse = try JSONDecoder().decode(MealsResponse.self, from: data)
        return decodedResponse.meals.sorted { $0.strMeal < $1.strMeal }
    }
    
    func getMealDetail(by id: String) async throws -> MealDetail {
        guard let url = URL(string: lookupURL + id) else { throw URLError(.badURL) }
        let data = try await networking.fetchData(from: url)
        let decodedResponse = try JSONDecoder().decode(MealDetailResponse.self, from: data)
        return decodedResponse.meals.first!
    }
}


