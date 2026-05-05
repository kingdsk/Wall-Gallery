import Foundation

enum APIConstants {
    static let baseURL = "https://unchain-thumb-uprising.ngrok-free.dev/"

    private static let api     = "api/v1"
    private static let auth    = "\(api)/auth"
    private static let dietary = "\(api)/dietary-choices"

    // Endpoints
    static let authGuest        = "\(baseURL)\(auth)/guest"
    static let dietaryOptions   = "\(baseURL)\(dietary)/options"
    static let cuisines         = "\(baseURL)\(api)/cuisines"
    static let mealPlanGenerate          = "\(baseURL)\(api)/meal-plan/generate"
    static let mealPlanRecentlyGenerated = "\(baseURL)\(api)/meal-plan/recently-generated"
}
