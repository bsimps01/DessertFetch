# 🍰 DessertFetch

DessertFetch is a Swift-based iOS app that allows users to browse dessert recipes. The app fetches data from [TheMealDB API](https://www.themealdb.com/api.php) and displays various desserts with detailed information about each recipe.

## Features
- List of desserts fetched from TheMealDB API.
- Detailed view of each dessert including ingredients, measurements, and cooking instructions.
- Asynchronous networking using `async/await` in Swift.
- Decodes dynamic number of ingredients and measurements.
- Unit tests and UI tests implemented with `XCTest`.

## API Endpoints
DessertFetch uses two endpoints from TheMealDB:
- **List of Desserts**: `https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert`
- **Meal Details**: `https://www.themealdb.com/api/json/v1/1/lookup.php?i=MEAL_ID`

## Technologies
- **SwiftUI**: For building the UI.
- **Swift Concurrency**: For asynchronous networking using `async/await`.
- **XCTest**: For unit and UI tests.
- **TheMealDB API**: External API providing dessert data.

## Project Structure
```bash
DessertFetch/
├── DessertFetch.xcodeproj   # Xcode project file
├── DessertFetch/
│   ├── Model/              # Data models (Meal, MealDetail, etc.)
│   ├── MealViewModel/          # SwiftUI view models
│   ├── Views/               # SwiftUI views
│   ├── Network/          # Network layer and API service
│   ├── Tests/               # Unit and UI tests
│   ├── Resources/           # Assets, icons, etc.
└── README.md                # Project documentation
