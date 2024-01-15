
// PhotoCache.swift

import UIKit

class PhotoCache {
    // Singleton instance of PhotoCache
    static let shared = PhotoCache()
    
    // NSCache to store UIImage objects with String keys
    private let cache = NSCache<NSString, UIImage>()

    func cacheImage(_ image: UIImage, forKey key: String) {
        // Convert the key (URL) to NSString for NSCache
        cache.setObject(image, forKey: key as NSString)
        // The key represents a URL for the image.
        // The value is the UIImage object itself.
    }

    // Function to retrieve an image from the cache using a url.
    func getImage(forKey key: String) -> UIImage? {
        // Retrieve the UIImage object from the cache using the key
        return cache.object(forKey: key as NSString)
        
        // Note: The key is used to look up and retrieve the UIImage object
        // associated with it. If the key is not present in the cache, the
        // function will return nil, indicating that the image is not cached.
    }
}
