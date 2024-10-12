//
//  DessertMainView.swift
//  DessertFetch
//
//  Created by Benjamin Simpson on 9/8/24.
//

import SwiftUI

struct DessertMainView: View {
    @StateObject private var viewModel = MealViewModel()
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    // Search bar for filtering desserts
                    SearchBar(text: $viewModel.searchText)
                    
                    // List of meals
                    if viewModel.filteredDesserts.isEmpty {
                        Text("No desserts found.")
                            .padding()
                    } else {
                        List(viewModel.filteredDesserts, id: \.idMeal) { meal in
                            HStack {
                                // Add or remove from favorites button
                                Button(action: {
                                    if viewModel.favoriteMeals.contains(where: { $0.idMeal == meal.idMeal }) {
                                        viewModel.removeMealFromFavorites(meal)
                                    } else {
                                        viewModel.addMealToFavorites(meal)
                                    }
                                }) {
                                    Image(systemName: viewModel.favoriteMeals.contains(where: { $0.idMeal == meal.idMeal }) ? "heart.fill" : "heart")
                                        .foregroundColor(viewModel.favoriteMeals.contains(where: { $0.idMeal == meal.idMeal }) ? .red : .gray)
                                }
                                .buttonStyle(PlainButtonStyle()) // Prevent button from affecting the ListRow background
                                
                                // Navigation link for meal detail
                                NavigationLink(destination: MealDetailView(mealID: meal.idMeal)) {
                                    HStack {
                                        // Display the image using AsyncImage
                                        if let imageURL = meal.strMealThumb,
                                           let url = URL(string: imageURL) {
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
                            }
                        }
                    }
                }
                
                // Show loading indicator when isLoading is true
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle())
                        .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)) // Overlay effect
                        .zIndex(1)  // Make sure it's on top of other views
                }
                
                // Display error message if one exists
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                        .multilineTextAlignment(.center)
                        .zIndex(2) // Make sure it appears on top of other views
                }
            }
            .navigationTitle("Desserts")
            .toolbar {
                // Pass the same ViewModel instance to FavoritesView
                NavigationLink(destination: FavoritesView(viewModel: viewModel)) {
                    Text("Favorites")
                }
            }
            .onAppear {
                viewModel.searchText = ""  // Clear search text when the view appears
                Task {
                    await viewModel.getDessertMeals()
                }
            }
        }
    }
}

//#Preview {
//    DessertMainView()
//}
