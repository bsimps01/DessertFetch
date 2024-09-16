//
//  MealService.swift
//  DessertFetch
//
//  Created by Benjamin Simpson on 9/15/24.
//

import Foundation

struct MealsService: HTTPClient {
    func fetchDessertMeals() async -> Result<MealsResponse, RequestError> {
        return await sendRequest(endpoint: MealsEndpoint.dessertMeals, responseModel: MealsResponse.self)
    }

    func fetchMealDetail(id: String) async -> Result<MealDetailResponse, RequestError> {
        return await sendRequest(endpoint: MealsEndpoint.mealDetail(id: id), responseModel: MealDetailResponse.self)
    }
}
