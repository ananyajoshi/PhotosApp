
// FullScreenPhotoViewController.swift

import UIKit

class FullScreenPhotoViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let imageView: UIImageView = {
        // Image view to display the full-screen photo
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let closeButton: UIButton = {
        // Button to close the full-screen view
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    // MARK: - Properties
    
    private let photo: Photo
    
    // MARK: - Initialization
    
    init(photo: Photo) {
        // Initialize the view controller with a photo
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
        setupUI()      // Set up the user interface
        loadImage()    // Load the image (either from cache or download)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - User Interface Setup
    
    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(imageView)
        view.addSubview(closeButton)
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - Image Loading
    
    private func loadImage() {
        // Load the photo image, either from cache or download asynchronously
        
        if let cachedImage = PhotoCache.shared.getImage(forKey: photo.downloadURL) {
            // 1: Load image from cache if available
            imageView.image = cachedImage
        } else {
            // 2: If the image is not in the cache, start downloading it asynchronously
            
            // 3: Create a background queue to perform the image download asynchronously
            DispatchQueue.global(qos: .background).async { [weak self] in
                // 4: Use a weak self reference to avoid potential retain cycles
                guard let self = self else { return }
                
                // 5: Convert the download URL to a valid URL
                guard let imageURL = URL(string: self.photo.downloadURL) else {
                    return
                }
                
                // 6: Attempt to fetch image data from the URL
                guard let imageData = try? Data(contentsOf: imageURL),
                      let image = UIImage(data: imageData) else {
                    return
                }
                
                // 7: Cache the downloaded image
                PhotoCache.shared.cacheImage(image, forKey: self.photo.downloadURL)
                
                // 8: Ensure the imageView is still on-screen before updating it
                DispatchQueue.main.async {
                    // 9: Set the image to the imageView on the main thread
                    self.imageView.image = image
                }
            }
        }
    }
    
    // MARK: - Button Actions
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
