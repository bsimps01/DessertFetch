//
//  MealsEndpoint.swift
//  DessertFetch
//
//  Created by Benjamin Simpson on 9/15/24.
//

import Foundation

enum MealsEndpoint: Endpoint {
    case dessertMeals
    case mealDetail(id: String)

    var path: String {
        switch self {
        case .dessertMeals:
            return "/api/json/v1/1/filter.php"
        case .mealDetail:
            return "/api/json/v1/1/lookup.php"
        }
    }

    var method: HTTPMethod {
        return .get
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .dessertMeals:
            return [URLQueryItem(name: "c", value: "Dessert")]
        case .mealDetail(let id):
            return [URLQueryItem(name: "i", value: id)]
        }
    }
}

