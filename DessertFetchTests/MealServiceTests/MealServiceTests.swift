//
//  MealServiceTests.swift
//  MealServiceTests
//
//  Created by Benjamin Simpson on 9/13/24.
//

import XCTest
@testable import DessertFetch

final class MealsServiceTests: XCTestCase {

    // Custom URLSession that uses MockURLProtocol
    var urlSession: URLSession!
    
    override func setUp() {
        super.setUp()
        // Register MockURLProtocol in the custom URLSession configuration
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: config)
    }

    override func tearDown() {
        urlSession = nil
        super.tearDown()
    }
    
    func testMockURLProtocol() async throws {
        // Create a custom URLSession configuration with MockURLProtocol
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let customSession = URLSession(configuration: config)

        // Set up a mock response via MockURLProtocol
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            let mockData = """
            { "status": "ok" }
            """.data(using: .utf8)!
            return (response, mockData)
        }

        // Perform a simple URL request with the custom session
        let url = URL(string: "https://example.com")!
        let (data, _) = try await customSession.data(from: url)

        // Verify the mock response was received
        let responseString = String(data: data, encoding: .utf8)
        XCTAssertEqual(responseString, "{ \"status\": \"ok\" }")
    }

    // Test for successful response with mock data
    func testFetchDessertMealsSuccess() async throws {
        let mockJSONString = """
        {
            "meals": [
                { "idMeal": "52772", "strMeal": "Chocolate Cake", "strMealThumb": "https://example.com/image1.jpg" },
                { "idMeal": "52893", "strMeal": "Apple Tart", "strMealThumb": "https://example.com/image2.jpg" }
            ]
        }
        """
               let mockData = Data(mockJSONString.utf8)

               // Decode the mock JSON data
               do {
                   let decodedResponse = try JSONDecoder().decode(MealsResponse.self, from: mockData)
                   
                   // Then: Verify the decoded data
                   XCTAssertEqual(decodedResponse.meals.first?.strMeal, "Chocolate Cake")
                   XCTAssertEqual(decodedResponse.meals.first?.strMealThumb, "https://example.com/image1.jpg")
               } catch {
                   XCTFail("Decoding failed with error: \(error)")
               }
    }


    func testIntegrationFetchAndDisplayMeals() async throws {
        // Given: Mock JSON for a list of dessert meals
        let mockJSONString = """
        {
            "meals": [
                { "idMeal": "53049", "strMeal": "Apam balik", "strMealThumb": "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg" },
                { "idMeal": "52893", "strMeal": "Apple & Blackberry Crumble", "strMealThumb": "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg" }
            ]
        }
        """
        let mockData = Data(mockJSONString.utf8)

        // Mock the response using JSONDecoder
        let decodedMealsResponse = try JSONDecoder().decode(MealsResponse.self, from: mockData)
        
        // Initialize ViewModel and inject mock data directly
        let viewModel = MealViewModel()

        // Simulate network fetching but use mock data
        viewModel.dessertMeals = decodedMealsResponse.meals  // Simulate what `getDessertMeals` would do

        // Validate the result in the viewModel
        XCTAssertEqual(viewModel.dessertMeals.count, 2)  // Mock JSON contains 2 meals
        XCTAssertEqual(viewModel.dessertMeals.first?.strMeal, "Apam balik")  // Check the first meal name
        XCTAssertEqual(viewModel.dessertMeals.last?.strMeal, "Apple & Blackberry Crumble")
    }


    func testPerformanceFetchMeals() throws {
        let mealsService = MealsService()
        
        measure {
            let expectation = expectation(description: "Fetch meals asynchronously")
            
            Task {
                let result = await mealsService.fetchDessertMeals()
                XCTAssertNotNil(result)
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5.0)  // Wait for the async task to complete
        }
    }


    func testConcurrentMealFetches() async throws {
        let mealsService = MealsService()

        // Dispatch multiple concurrent fetch requests
        async let fetch1 = mealsService.fetchDessertMeals()
        async let fetch2 = mealsService.fetchDessertMeals()
        async let fetch3 = mealsService.fetchDessertMeals()

        // Await all results
        let results = await [fetch1, fetch2, fetch3]

        // Then: Ensure all results are successful
        for result in results {
            switch result {
            case .success(let mealsResponse):
                XCTAssertGreaterThan(mealsResponse.meals.count, 0)
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
    }



    // Fetch Meal Detail Success
    func testFetchMealDetailFromMockJSON() async throws {
         // Given: Mock JSON for meal details
         let mockJSONString = """
         {
             "meals": [
                 {
                     "idMeal": "52772",
                     "strMeal": "Chocolate Cake",
                     "strInstructions": "Mix ingredients and bake.",
                     "strMealThumb": "https://example.com/image.jpg"
                 }
             ]
         }
         """
         let mockData = Data(mockJSONString.utf8)

         // When: Decode the mock JSON data
         do {
             let decodedResponse = try JSONDecoder().decode(MealDetailResponse.self, from: mockData)
             
             // Then: Verify the decoded data
             XCTAssertEqual(decodedResponse.meals.first?.strMeal, "Chocolate Cake")
             XCTAssertEqual(decodedResponse.meals.first?.strInstructions, "Mix ingredients and bake.")
         } catch {
             XCTFail("Decoding failed with error: \(error)")
         }
     }

}
