
//  PhotoCell.swift

import UIKit

class PhotoCell: UICollectionViewCell {
    //To save the resources, and make the application efficient we reuse the cells. those cells can be identified with this identifier.
    static let reuseIdentifier = "PhotoCell"
    
    // URLSessionDataTask to keep a track of the image download task
    private var task: URLSessionDataTask?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        // Only the content within the bounds of the parent view will be visible.
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with photo: Photo) {
        // 1: Cancel any existing image download task
        task?.cancel()
        let imageURL = photo.downloadURL
        
        // 2: Check if the image is already in the cache
        if let cachedImage = PhotoCache.shared.getImage(forKey: imageURL) {
            // If cached, use the cached image and set it to the imageView
            print("Image is already in the cache. No download needed. Image of id: \(photo.id)")
            self.imageView.image = cachedImage
        } else {
            // 3: If not in the cache, we will start a network request to download the image
            guard let url = URL(string: imageURL) else { return }
            
            let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                // 4: Ensure self is still in scope and there is valid data with no errors
                guard let self = self, let data = data, error == nil else { return }
                
                // 5: Update the UI on the main thread
                DispatchQueue.main.async {
                    // Set the image to the imageView using the downloaded data
                    self.imageView.image = UIImage(data: data)
                    
                    // 6: Cache the downloaded image
                    if let downloadedImage = UIImage(data: data) {
                        PhotoCache.shared.cacheImage(downloadedImage, forKey: imageURL)
                    }
                }
            }
            
            // 7: Start the data task to download the image
            task.resume()
            
            // 8: Assign the task to the class property to keep track of it
            self.task = task
        }
    }
}


