//
//  ViewModel.swift
//  DessertFetch
//
//  Created by Benjamin Simpson on 9/8/24.
//

import Foundation

@MainActor
class MealViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var selectedMealDetail: MealDetail?

    private let mealService = MealService()
    
    func getDessertMeals() async {
        do {
            let meals = try await mealService.fetchDessertMeals()
            self.meals = meals
        } catch {
            print("Error fetching dessert meals: \(error)")
        }
    }
    
    func getMealDetail(id: String) async {
        do {
            let mealDetail = try await mealService.fetchMealDetail(by: id)
            self.selectedMealDetail = mealDetail
        } catch {
            print("Error fetching meal detail: \(error)")
        }
    }
}
