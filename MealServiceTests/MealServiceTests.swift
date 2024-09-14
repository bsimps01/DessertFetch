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
        XCTAssertEqual(meals.first?.strMeal, "Apple Tart")
        XCTAssertEqual(meals.last?.strMeal, "Chocolate Cake")
        XCTAssertEqual(meals.first?.strMealThumb, "https://example.com/image2.jpg")
    }
    
    func testFetchDessertMealsNetworkError() async throws {
        // Given: Mocking a network error
        let mockNetworking = MockNetworking()
        mockNetworking.errorToThrow = URLError(.notConnectedToInternet)  // Simulate no internet connection

        let mealService = MealService(networking: mockNetworking)

        // When: Fetching the dessert meals
        do {
            _ = try await mealService.fetchDessertMeals()
            XCTFail("Expected an error but did not receive one")
        } catch {
            // Then: Assert that the error is a URLError
            XCTAssertEqual(error as? URLError, URLError(.notConnectedToInternet))
        }
    }
    
    func testFetchDessertMealsInvalidData() async throws {
        // Given: Mocking invalid JSON data
        let mockNetworking = MockNetworking()
        mockNetworking.dataToReturn = """
        {
            "meals": [
                { "idMeal": "52772", "strMeal": "Chocolate Cake" }  // Missing some fields
            ]
        }
        """.data(using: .utf8)

        let mealService = MealService(networking: mockNetworking)

        // When: Fetching the dessert meals
        do {
            _ = try await mealService.fetchDessertMeals()
            XCTFail("Expected a decoding error but did not receive one")
        } catch {
            // Then: Assert that the error is a decoding error
            XCTAssertTrue(error is DecodingError)
        }
    }

    func testFetchMealDetailSuccess() async throws {
        // Given: Mocking a valid meal detail API response
        let mockNetworking = MockNetworking()
        mockNetworking.dataToReturn = """
        {
            "meals": [
                {
                    "strMeal": "Chocolate Cake",
                    "strInstructions": "Mix and bake.",
                    "strMealThumb": "https://example.com/image.jpg",
                    "strIngredient1": "Flour",
                    "strMeasure1": "200g",
                    "strIngredient2": "Sugar",
                    "strMeasure2": "100g"
                }
            ]
        }
        """.data(using: .utf8)

        let mealService = MealService(networking: mockNetworking)
        
        // When: Fetching meal detail by ID
        let mealDetail = try await mealService.fetchMealDetail(by: "52772")

        // Then: Assert that meal detail is correctly decoded
        XCTAssertEqual(mealDetail.strMeal, "Chocolate Cake")
        XCTAssertEqual(mealDetail.strInstructions, "Mix and bake.")
        XCTAssertEqual(mealDetail.ingredients["Flour"], "200g")
        XCTAssertEqual(mealDetail.ingredients["Sugar"], "100g")
    }

    func testFetchMealDetailInvalidData() async throws {
        // Given: Mocking invalid JSON data for meal detail
        let mockNetworking = MockNetworking()
        mockNetworking.dataToReturn = """
        {
            "meals": [
                { "strMeal": "Chocolate Cake" }  // Missing required fields like instructions
            ]
        }
        """.data(using: .utf8)

        let mealService = MealService(networking: mockNetworking)

        // When: Fetching meal detail
        do {
            _ = try await mealService.fetchMealDetail(by: "52772")
            XCTFail("Expected a decoding error but did not receive one")
        } catch {
            // Then: Assert that the error is a decoding error
            XCTAssertTrue(error is DecodingError)
        }
    }
    
    func testNetworkingPerformance() throws {
        let networking = Networking()
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!

        measure {
            Task {
                do {
                    _ = try await networking.fetchData(from: url)
                } catch {
                    XCTFail("Expected successful network response but received an error")
                }
            }
        }
    }



}
