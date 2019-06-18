import UIKit

class Photo: WXObject {

    @objc private dynamic var urlString: String? = nil
    @objc private dynamic var cached: Data? = nil
    
    var photoUrl: String? {
        set {
            if newValue == urlString { return }
            writeBlock { _ in
                urlString = newValue
            }
        }
        get {
            return urlString
        }
    }
    
    var cachedData: Data? {
        set {
            writeBlock { _ in
                cached = newValue
            }
        }
        get {
            return cached
        }
    }
    
    var url: URL? {
        guard
            let stringUrl = photoUrl
            else { return nil }
        return URL(string: stringUrl)
    }
    
}
