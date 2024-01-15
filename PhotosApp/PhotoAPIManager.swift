
// PhotoAPIManager.swift

import Foundation

class PhotoAPIManager {
    // Singleton instance of PhotoAPIManager
    static let shared = PhotoAPIManager()
    
    // Function to fetch photo information from an API
    // The completion handler is used to provide the fetched photos to the caller.
    // It does not download the actual images but retrieves information about the photos,
    // including download URLs. The completion handler receives an array of Photo objects.
    
    func fetchPhotos(completion: @escaping ([Photo]) -> Void) {
        // URL of the API endpoint providing photo information
        let apiURL = URL(string: "https://jsonblob.com/api/jsonBlob/1182735235283804160")!
        
        // Initiating a data task to fetch data from the specified API URL
        URLSession.shared.dataTask(with: apiURL) { (data, response, error) in
            // Ensure there is valid data and no error
            guard let data = data, error == nil else {
                // If there is an error or no data, exit the function
                return
            }
            
            do {
                // JSONDecoder to parse the received data into an array of Photo objects
                let decoder = JSONDecoder()
                let photos = try decoder.decode([Photo].self, from: data)
                
                print("Fetched \(photos.count) photos from the API")
                
                // Execute the provided completion handler on the main thread
                DispatchQueue.main.async {
                    // Pass the fetched photos to the completion handler
                    completion(photos)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()  // Start the data task, we won't start the network request until explicitly told to do so.
    }
}
