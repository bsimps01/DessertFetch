//
//  MealService.swift
//  DessertFetch
//
//  Created by Benjamin Simpson on 9/15/24.
//

import Foundation

struct MealsService: HTTPClient {
    let session: URLSession  // Inject URLSession

    init(session: URLSession = .shared) {
        self.session = session  // Use injected session or default to shared
    }

    func fetchDessertMeals() async -> Result<MealsResponse, RequestError> {
        return await sendRequest(endpoint: MealsEndpoint.dessertMeals,
                                 responseModel: MealsResponse.self,
                                 session: session)
    }

    func fetchMealDetail(id: String) async -> Result<MealDetailResponse, RequestError> {
        return await sendRequest(endpoint: MealsEndpoint.mealDetail(id: id),
                                 responseModel: MealDetailResponse.self,
                                 session: session)
    }
}
