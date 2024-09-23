//
//  MealDetail.swift
//  DessertFetch
//
//  Created by Benjamin Simpson on 9/9/24.
//

import Foundation

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
        
        var tempIngredients: [String: String] = [:]
        
        let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        
        // Dynamically iterate over all keys in the API response
        for key in dynamicContainer.allKeys {
            if key.stringValue.starts(with: "strIngredient") {
                let index = key.stringValue.replacingOccurrences(of: "strIngredient", with: "")
                let measureKey = DynamicCodingKeys(stringValue: "strMeasure\(index)")!

                let ingredient = try dynamicContainer.decodeIfPresent(String.self, forKey: key) ?? ""
                let measure = try dynamicContainer.decodeIfPresent(String.self, forKey: measureKey) ?? ""

                // Only add non-empty ingredient and measurement
                if !ingredient.isEmpty && !measure.isEmpty {
                    tempIngredients[ingredient] = measure
                }
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
