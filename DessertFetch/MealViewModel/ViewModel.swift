//
//  ViewModel.swift
//  DessertFetch
//
//  Created by Benjamin Simpson on 9/8/24.
//

import Foundation
import Combine

class MealViewModel: ObservableObject {
    @Published var dessertMeals: [Meal] = [] // list of meals
    @Published var selectedMealDetail: MealDetail? // meal detail
    @Published var errorMessage: String? // error message
    @Published var searchText: String = ""  // Search text entered by the user
    @Published var filteredDesserts: [Meal] = []  // Filtered list of meals

    private let mealService = MealsService()
    private var cancellables = Set<AnyCancellable>()  // To store Combine subscriptions
    
    init() {
        // Bind searchText changes to the filteredDesserts array
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map { searchText in
                if searchText.isEmpty {
                    return self.dessertMeals
                } else {
                    return self.dessertMeals.filter {
                        $0.strMeal.lowercased().contains(searchText.lowercased())
                    }
                }
            }
            .assign(to: &$filteredDesserts)
    }
    
    func getDessertMeals() async {
        let result = await mealService.fetchDessertMeals()

        DispatchQueue.main.async {
            switch result {
            case .success(let mealResponse):
                self.dessertMeals = mealResponse.meals
                self.filteredDesserts = mealResponse.meals  // Initially, all meals are shown
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

// previous logic for sorting out meal detail service

//do {
//    let mealDetail = try await mealService.fetchMealDetail(by: id)
//    self.selectedMealDetail = mealDetail
//} catch {
//    print("Error fetching meal detail: \(error)")
//}
