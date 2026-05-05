// MARK: - APIEnvelope
// Generic wrapper that matches the server's standard response shape:
// { "code": "1", "message": "...", "keyword": "...", "data": <T> }

import Foundation

struct APIEnvelope<T: Decodable>: Decodable {
    let code: String
    let message: String?
    let keyword: String?
    let data: T?
}
