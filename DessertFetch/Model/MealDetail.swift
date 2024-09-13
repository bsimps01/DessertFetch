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
        
        let rawContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        
        var tempIngredients: [String: String] = [:]
        
        let maxIngredients = 20  // Defined as a constant for easier maintenance
        
        for i in 1...maxIngredients {
            let ingredientKey = DynamicCodingKeys(stringValue: "strIngredient\(i)")!
            let measureKey = DynamicCodingKeys(stringValue: "strMeasure\(i)")!
            
            guard let ingredient = try rawContainer.decodeIfPresent(String.self, forKey: ingredientKey),
                  let measure = try rawContainer.decodeIfPresent(String.self, forKey: measureKey),
                  !ingredient.isEmpty, !measure.isEmpty else {
                break // Stops the loop if no more ingredients or measurements are found
            }
            tempIngredients[ingredient] = measure // stores the ingredient with the corresponding measurement
        }
        
        self.ingredients = tempIngredients // takes the temporary dictionary of ingredient-measurement pairs and stores it into the ingredients property of the MealDetail struct
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
