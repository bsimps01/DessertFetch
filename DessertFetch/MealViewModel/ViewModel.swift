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
    @Published var isLoading: Bool = false
    @Published var favoriteMeals: [Meal] = [] // List of favorite meals

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
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        let result = await mealService.fetchDessertMeals()

        DispatchQueue.main.async {
            self.isLoading = false
            switch result {
            case .success(let mealResponse):
                self.dessertMeals = mealResponse.meals
                self.filteredDesserts = mealResponse.meals  // Initially, all meals are shown
            case .failure(let error):
                self.errorMessage = error.customMessage
            }
        }
    }
    
    //Meal Details
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
    
    // Save favorite meal
    func addMealToFavorites(_ meal: Meal) {
        if !favoriteMeals.contains(where: { $0.idMeal == meal.idMeal }) {
            favoriteMeals.append(meal)
            saveFavoriteMeals()
        }
    }
    
    // Remove favorite meal
    func removeMealFromFavorites(_ meal: Meal) {
        if let index = favoriteMeals.firstIndex(where: { $0.idMeal == meal.idMeal }) {
            favoriteMeals.remove(at: index)
            saveFavoriteMeals()
        }
    }
    
    // Save favorite meals to UserDefaults
    func saveFavoriteMeals() {
        if let encoded = try? JSONEncoder().encode(favoriteMeals) {
            UserDefaults.standard.set(encoded, forKey: "favoriteMeals")
        }
    }

    // Load favorite meals from UserDefaults
    func loadFavoriteMeals() {
        if let savedMeals = UserDefaults.standard.object(forKey: "favoriteMeals") as? Data {
            if let decodedMeals = try? JSONDecoder().decode([Meal].self, from: savedMeals) {
                favoriteMeals = decodedMeals
            }
        }
    }
}
