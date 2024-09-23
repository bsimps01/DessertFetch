//
//  MealDetailView.swift
//  DessertFetch
//
//  Created by Benjamin Simpson on 9/8/24.
//

import SwiftUI

struct MealDetailView: View {
    let mealID: String
    @StateObject private var viewModel = MealViewModel()
        
        var body: some View {
            ScrollView {
                if let meal = viewModel.selectedMealDetail {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(meal.strMeal)
                            .font(.largeTitle)
                            .bold()
                        
                        // Display the meal image if available
                        if let thumb = meal.strMealThumb, let url = URL(string: thumb) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)  // Larger image
                                    .frame(maxWidth: .infinity)      // Full width image
                            } placeholder: {
                                ProgressView()
                            }
                        }

                        Text("Instructions")
                            .font(.headline)
                        
                        Text(meal.strInstructions)
                            .padding(.bottom)
                        
                        Text("Ingredients")
                            .font(.headline)
                        
                        ForEach(Array(meal.ingredients.keys), id: \.self) { key in
                            if let value = meal.ingredients[key], !value.isEmpty {
                                Text("\(key): \(value)")
                            }
                        }
                    }
                    .padding()
                } else {
                    ProgressView()
                        .task {
                            await viewModel.getMealDetail(id: mealID)
                        }
                }
            }
        }
}

//#Preview {
//    MealDetailView()
//}
