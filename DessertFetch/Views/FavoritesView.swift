//
//  FavoritesView.swift
//  DessertFetch
//
//  Created by Benjamin Simpson on 10/8/24.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: MealViewModel  // Use the same ViewModel passed from the parent view
    
    var body: some View {
        VStack {
            if viewModel.favoriteMeals.isEmpty {
                Text("No favorites yet.")
                    .padding()
            } else {
                List(viewModel.favoriteMeals, id: \.idMeal) { meal in
                    HStack {
                        // Navigation link to go to meal detail view
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
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(8)
                                        .foregroundColor(.gray)
                                }
                                
                                // Display the meal name
                                Text(meal.strMeal)
                                
                                Spacer()
                            }
                        }

                        // Button to remove from favorites
                        Button(action: {
                            viewModel.removeMealFromFavorites(meal)
                        }) {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .navigationTitle("Favorites")
            }
        }
        .onAppear {
            viewModel.loadFavoriteMeals()  // Ensure favorites are loaded when the view appears
        }
    }
}
