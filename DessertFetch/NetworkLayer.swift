//
//  Model.swift
//  DessertFetch
//
//  Created by Benjamin Simpson on 9/8/24.
//

import Foundation

struct Meal: Codable, Identifiable {
    let idMeal: String  // id for meal
    let strMeal: String  // meal name
    let strMealThumb: String? // meal image url
    
    // Computed property to satisfy the Identifiable protocol
    var id: String {
        idMeal
    }
}

struct MealDetail: Codable {
    let strMeal: String // meal name
    let strInstructions: String // Cooking instructions
    let strMealThumb: String? // meal image url
    
    let ingredients: [String: String] // meal ingredients
    
    enum CodingKeys: String, CodingKey {
        case strMeal, strInstructions, strMealThumb
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.strMeal = try container.decode(String.self, forKey: .strMeal)
        self.strInstructions = try container.decode(String.self, forKey: .strInstructions)
        self.strMealThumb = try container.decodeIfPresent(String.self, forKey: .strMealThumb)
        
        let rawContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        
        var tempIngredients: [String: String] = [:]
        
        for i in 1...20 {
            let ingredientKey = DynamicCodingKeys(stringValue: "strIngredient\(i)")!
            let measureKey = DynamicCodingKeys(stringValue: "strMeasure\(i)")!
            
            if let ingredient = try rawContainer.decodeIfPresent(String.self, forKey: ingredientKey),
               let measure = try rawContainer.decodeIfPresent(String.self, forKey: measureKey),
               !ingredient.isEmpty, !measure.isEmpty {
                tempIngredients[ingredient] = measure
            }
        }
        
        self.ingredients = tempIngredients
    }
    
    struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }
}

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
    
    func fetchDessertMeals() async throws -> [Meal] {
        guard let url = URL(string: dessertURL) else { throw URLError(.badURL) }
        let data = try await networking.fetchData(from: url)
        let decodedResponse = try JSONDecoder().decode(MealsResponse.self, from: data)
        return decodedResponse.meals.sorted { $0.strMeal < $1.strMeal }
    }
    
    func fetchMealDetail(by id: String) async throws -> MealDetail {
        guard let url = URL(string: lookupURL + id) else { throw URLError(.badURL) }
        let data = try await networking.fetchData(from: url)
        let decodedResponse = try JSONDecoder().decode(MealDetailResponse.self, from: data)
        return decodedResponse.meals.first!
    }
}

struct MealsResponse: Codable {
    let meals: [Meal]
}

struct MealDetailResponse: Codable {
    let meals: [MealDetail]
}

