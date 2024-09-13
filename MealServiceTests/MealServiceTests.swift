//
//  MealServiceTests.swift
//  MealServiceTests
//
//  Created by Benjamin Simpson on 9/13/24.
//

import XCTest
@testable import DessertFetch

final class MealServiceTests: XCTestCase {
    
    class MockNetworking: NetworkingProtocol {
        var dataToReturn: Data?
        var errorToThrow: Error?

        func fetchData(from url: URL) async throws -> Data {
            if let error = errorToThrow {
                throw error
            }
            return dataToReturn ?? Data()
        }
    }

    func testFetchDessertMealsSuccess() async throws {
        // Given: Mock data to simulate a successful API response
        let mockNetworking = MockNetworking()
        mockNetworking.dataToReturn = """
        {
            "meals": [
                { "idMeal": "52772", "strMeal": "Chocolate Cake", "strMealThumb": "https://example.com/image.jpg" },
                { "idMeal": "52893", "strMeal": "Apple Tart", "strMealThumb": "https://example.com/image2.jpg" }
            ]
        }
        """.data(using: .utf8)

        let mealService = MealService(networking: mockNetworking)

        // When: Fetching the dessert meals
        let meals = try await mealService.fetchDessertMeals()

        // Then: Assert that meals are correctly decoded
        XCTAssertEqual(meals.count, 2)
        XCTAssertEqual(meals.first?.strMeal, "Chocolate Cake")
        XCTAssertEqual(meals.last?.strMeal, "Apple Tart")
        XCTAssertEqual(meals.first?.strMealThumb, "https://example.com/image.jpg")
    }
}
