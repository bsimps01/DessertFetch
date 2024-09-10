//
//  DessertMainView.swift
//  DessertFetch
//
//  Created by Benjamin Simpson on 9/8/24.
//

import SwiftUI

struct DessertMainView: View {
    @StateObject private var viewModel = MealViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.meals) { meal in
                NavigationLink(destination: MealDetailView(mealID: meal.idMeal)) {
                    HStack {
                        // Display the image using AsyncImage
                        if let imageURL = meal.strMealThumb, let url = URL(string: imageURL) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(8)
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 50, height: 50)
                            }
                        } else {
                            // Display placeholder if no image is available
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .cornerRadius(8)
                                .foregroundColor(.gray)
                        }
                        
                        // Display the meal name
                        Text(meal.strMeal)
                    }
                }
            }
            .navigationTitle("Desserts")
            .task {
                await viewModel.getDessertMeals()
            }
        }
    }
}

//#Preview {
//    DessertMainView()
//}
