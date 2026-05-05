// MARK: - SessionManager
// Stores the guest/user session data returned from the API.
// Access via SessionManager.shared from anywhere in the app.

import Foundation

struct GuestUser: Codable {
    let id: Int
    let name: String
    let isGuest: Bool
    let guestUID: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case isGuest  = "is_guest"
        case guestUID = "guest_uid"
    }
}

struct SessionData: Codable {
    let user: GuestUser
    let token: String
}

final class SessionManager {

    static let shared = SessionManager()
    private init() {}

    // MARK: Keys
    private let kToken     = "session_token"
    private let kUser      = "session_user"
    private let kLaunched  = "hasContinuedAsGuest"

    // MARK: Public API

    var token: String? {
        UserDefaults.standard.string(forKey: kToken)
    }

    var currentUser: GuestUser? {
        guard let data = UserDefaults.standard.data(forKey: kUser) else { return nil }
        return try? JSONDecoder().decode(GuestUser.self, from: data)
    }

    var hasValidSession: Bool {
        token != nil && UserDefaults.standard.bool(forKey: kLaunched)
    }

    func save(session: SessionData) {
        UserDefaults.standard.set(session.token, forKey: kToken)
        if let encoded = try? JSONEncoder().encode(session.user) {
            UserDefaults.standard.set(encoded, forKey: kUser)
        }
        UserDefaults.standard.set(true, forKey: kLaunched)
    }

    func clear() {
        UserDefaults.standard.removeObject(forKey: kToken)
        UserDefaults.standard.removeObject(forKey: kUser)
        UserDefaults.standard.set(false, forKey: kLaunched)
    }
}
