//
//  ViewModel.swift
//  DessertFetch
//
//  Created by Benjamin Simpson on 9/8/24.
//

import Foundation

class MealViewModel: ObservableObject {
    @Published var dessertMeals: [Meal] = []
    @Published var selectedMealDetail: MealDetail?
    @Published var errorMessage: String?

    private let mealService = MealsService()
    
    func getDessertMeals() async {
        let result = await mealService.fetchDessertMeals()

        DispatchQueue.main.async {
            switch result {
            case .success(let mealResponse):
                self.dessertMeals = mealResponse.meals
            case .failure(let error):
                self.errorMessage = error.customMessage
            }
        }
    }
    
    // previous logic for sorting out meal service
    
//    do {
//        let meals = try await mealService.fetchDessertMeals()
//        self.meals = meals
//    } catch {
//        print("Error fetching dessert meals: \(error)")
//    }
//}
    
    func getMealDetail(id: String) async {
        let result = await mealService.fetchMealDetail(id: id)

        DispatchQueue.main.async {
            switch result {
                case .success(let mealDetailResponse):
                    self.selectedMealDetail = mealDetailResponse.meals.first
                case .failure(let error):
                    self.errorMessage = error.customMessage
                }
            }
        }
}

// previous logic for sorting out meal service

//do {
//    let mealDetail = try await mealService.fetchMealDetail(by: id)
//    self.selectedMealDetail = mealDetail
//} catch {
//    print("Error fetching meal detail: \(error)")
//}
