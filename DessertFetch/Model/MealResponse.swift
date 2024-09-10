//
//  MealResponse.swift
//  DessertFetch
//
//  Created by Benjamin Simpson on 9/9/24.
//

import Foundation

struct MealsResponse: Codable {
    let meals: [Meal]
}

struct MealDetailResponse: Codable {
    let meals: [MealDetail]
}
