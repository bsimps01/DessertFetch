//
//  DessertFetchTests.swift
//  DessertFetchTests
//
//  Created by Benjamin Simpson on 9/12/24.
//

import XCTest
@testable import DessertFetch

final class MealDetailsTests: XCTestCase {

    override func setUpWithError() throws {
        // This method is called before the invocation of each test method in the class.
        // You can set up any initial state or dependencies needed for your tests here.
    }

    override func tearDownWithError() throws {
        // This method is called after the invocation of each test method in the class.
        // Clean up any resources or state that need to be reset after each test here.
    }

    // Example test for decoding MealDetail with valid ingredients
    func testMealDetailDecodingWithValidIngredients() throws {
        let jsonData = """
        {
            "strMeal": "Chocolate Cake",
            "strInstructions": "Mix all ingredients and bake.",
            "strMealThumb": "https://example.com/image.jpg",
            "strIngredient1": "Flour",
            "strMeasure1": "200g",
            "strIngredient2": "Sugar",
            "strMeasure2": "100g",
            "strIngredient3": "Eggs",
            "strMeasure3": "2"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let mealDetail = try decoder.decode(MealDetail.self, from: jsonData)
        
        XCTAssertEqual(mealDetail.strMeal, "Chocolate Cake")
        XCTAssertEqual(mealDetail.strInstructions, "Mix all ingredients and bake.")
        XCTAssertEqual(mealDetail.ingredients.count, 3)
        XCTAssertEqual(mealDetail.ingredients["Flour"], "200g")
        XCTAssertEqual(mealDetail.ingredients["Sugar"], "100g")
        XCTAssertEqual(mealDetail.ingredients["Eggs"], "2")
    }

    // Test for handling missing ingredients
    func testMealDetailDecodingWithMissingIngredients() throws {
        let jsonData = """
        {
            "strMeal": "Pancakes",
            "strInstructions": "Mix ingredients and fry.",
            "strMealThumb": "https://example.com/image.jpg",
            "strIngredient1": "Flour",
            "strMeasure1": "300g",
            "strIngredient2": "",
            "strMeasure2": "",
            "strIngredient3": "Milk",
            "strMeasure3": "250ml"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let mealDetail = try decoder.decode(MealDetail.self, from: jsonData)
        
        XCTAssertEqual(mealDetail.ingredients.count, 1)
        XCTAssertEqual(mealDetail.ingredients["Flour"], "300g")
        XCTAssertEqual(mealDetail.ingredients["Milk"], nil)
    }

    // Test for decoding with no ingredients
    func testMealDetailDecodingWithNoIngredients() throws {
        let jsonData = """
        {
            "strMeal": "Salad",
            "strInstructions": "Just mix everything.",
            "strMealThumb": "https://example.com/image.jpg"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let mealDetail = try decoder.decode(MealDetail.self, from: jsonData)
        
        XCTAssertEqual(mealDetail.strMeal, "Salad")
        XCTAssertEqual(mealDetail.strInstructions, "Just mix everything.")
        XCTAssertEqual(mealDetail.ingredients.count, 0)
    }

    // Test for dynamic ingredients decoding
    func testMealDetailWithDynamicIngredients() throws {
        let jsonData = """
        {
            "strMeal": "Fruit Salad",
            "strInstructions": "Mix fruits.",
            "strMealThumb": "https://example.com/image.jpg",
            "strIngredient1": "Apple",
            "strMeasure1": "2",
            "strIngredient2": "Banana",
            "strMeasure2": "1",
            "strIngredient3": "Grapes",
            "strMeasure3": "A bunch",
            "strIngredient4": "Orange",
            "strMeasure4": "2"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let mealDetail = try decoder.decode(MealDetail.self, from: jsonData)
        
        XCTAssertEqual(mealDetail.ingredients.count, 4)
        XCTAssertEqual(mealDetail.ingredients["Apple"], "2")
        XCTAssertEqual(mealDetail.ingredients["Banana"], "1")
        XCTAssertEqual(mealDetail.ingredients["Grapes"], "A bunch")
        XCTAssertEqual(mealDetail.ingredients["Orange"], "2")
    }
}
