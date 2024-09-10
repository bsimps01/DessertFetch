//
//  Meal.swift
//  DessertFetch
//
//  Created by Benjamin Simpson on 9/9/24.
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
