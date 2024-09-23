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
                    List(viewModel.filteredDesserts, id: \.idMeal) { meal in
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
                }
                
                // Show loading indicator when isLoading is true
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle())
                        .zIndex(1)  // Make sure it's on top of other views
                }
                
                // Display error message if one exists
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
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
