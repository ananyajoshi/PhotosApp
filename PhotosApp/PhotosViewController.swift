
// PhotosViewController.swift

import UIKit

// The first screen of the app - This screen will contain all the photos at a time.
class PhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    
    // MARK: - Properties
    
    private var photos: [Photo] = []                 // Array to hold fetched photos
    private var currentDate = Date()                 // Current date for display
    private var photosScrolled = 0                  // Track the number of photos scrolled
    
    // MARK: - UI Elements
    
    private lazy var collectionView: UICollectionView = {
        // Set up the collection view with a vertical flow layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        // Create a UICollectionView with a custom layout (UICollectionViewFlowLayout) and configure its properties
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false  // Disable autoresizing mask translation to constraints
        collectionView.delegate = self      // Set the delegate to handle collection view events
        collectionView.dataSource = self    // Set the data source to provide content for the collection view
        collectionView.prefetchDataSource = self  // Set the prefetching data source to improve performance during scrolling

        // Register the custom UICollectionViewCell class (PhotoCell) for reuse with the given identifier
        // You need to tell the view - I have a custom cell class named PhotoCell,
        // and I want you to use it for displaying items in the collection view.
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)

        return collectionView
    }()
    
    private lazy var dateLabel: UILabel = {
        // Label to display the current date
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private lazy var selectButton: UIButton = {
        // Button to perform a select action
        let button = UIButton(type: .system)
        // telling the view not to automatically translate its autoresizing mask into Auto Layout constraints
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Select", for: .normal)
        return button
    }()
    
    private let floatingTabBar: UIToolbar = {
        // Floating toolbar for additional actions
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.layer.cornerRadius = 15
        toolbar.clipsToBounds = true
        return toolbar
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchData()  // Fetch photos from the API
        setupUI()    // Set up the user interface
    }
    
    // MARK: - Data Fetching
    
    private func fetchData() {
        // Fetch photos using the shared instance of PhotoAPIManager
        PhotoAPIManager.shared.fetchPhotos { [weak self] photos in
            self?.photos = photos
            self?.collectionView.reloadData()  // Reload collection view after fetching data
        }
    }

    // MARK: - User Interface Setup
    
    private func setupUI() {
        // Add UI elements to the view and set up constraints
        
        view.addSubview(dateLabel)
        view.addSubview(selectButton)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            selectButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            selectButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            collectionView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Update date label based on current date
        updateDateLabel()
        
        // Add the floating tab bar to the view
        view.addSubview(floatingTabBar)
        
        // Set constraints for the floating tab bar
        NSLayoutConstraint.activate([
            floatingTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            floatingTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            floatingTabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -10),
            floatingTabBar.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Add buttons to the floating tab bar
        let yearsButton = UIBarButtonItem(title: "Years", style: .plain, target: self, action: #selector(tabBarButtonTapped))
        let daysButton = UIBarButtonItem(title: "Days", style: .plain, target: self, action: #selector(tabBarButtonTapped))
        let monthsButton = UIBarButtonItem(title: "Months", style: .plain, target: self, action: #selector(tabBarButtonTapped))
        let allPhotosButton = UIBarButtonItem(title: "All Photos", style: .plain, target: self, action: #selector(tabBarButtonTapped))
        
        // Flexible space to distribute buttons evenly
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // Set the buttons to the toolbar
        floatingTabBar.items = [yearsButton, flexibleSpace, daysButton, flexibleSpace, monthsButton, flexibleSpace, allPhotosButton]
    }
    
    // MARK: - Button Actions
    
    @objc private func tabBarButtonTapped(sender: UIBarButtonItem) {
        // Handle button taps on the floating tab bar
        switch sender.title {
        case "Years":
            print("Years tab tapped")
            break
        case "Days":
            print("Days tab tapped")
            break
        case "Months":
            print("Months tab tapped")
            break
        case "All Photos":
            print("All photos tab tapped")
            break
        default:
            break
        }
    }
    
    private func updateDateLabel() {
        // Update the date label with the current date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        dateLabel.text = dateFormatter.string(from: currentDate)
    }
    
    // The Photos view controller acts as the delegate for the collection view,
    // implementing methods to provide data,
    // respond to user interactions,
    // and manage the layout.
    
    // MARK: - UICollectionViewDelegate & UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Configure and return cells for the collection view
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as? PhotoCell else {
            fatalError("Unable to dequeue PhotoCell")
        }
        
        let photo = photos[indexPath.item]
        cell.configure(with: photo)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle selection of a photo item in the collection view
        let selectedPhoto = photos[indexPath.item]
        let fullScreenVC = FullScreenPhotoViewController(photo: selectedPhoto)
        present(fullScreenVC, animated: true, completion: nil)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Set the size of items in the collection view
        let collectionViewWidth = collectionView.frame.size.width
        let itemWidth = collectionViewWidth / 3
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    // MARK: - UICollectionViewDataSourcePrefetching

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        // Prefetch images for upcoming items in the collection view
        for indexPath in indexPaths {
            let photo = photos[indexPath.item]
            
            // Check if the image is already in the cache
            if PhotoCache.shared.getImage(forKey: photo.downloadURL) == nil {
                // If the image is not in the cache, start downloading it asynchronously
                DispatchQueue.global(qos: .background).async {
                    guard let imageURL = URL(string: photo.downloadURL),
                          let imageData = try? Data(contentsOf: imageURL),
                          let image = UIImage(data: imageData) else {
                        return
                    }
                    
                    // Cache the downloaded image
                    PhotoCache.shared.cacheImage(image, forKey: photo.downloadURL)
                    
                    // Ensure the cell is still on-screen before updating it
                    DispatchQueue.main.async {
                        if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell {
                            cell.configure(with: photo)
                        }
                    }
                    print("Prefetched and cached image for id: \(photo.id)")
                }
            }
        }
    }

    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Handle scrolling in the collection view and update date label accordingly
        let visibleIndexPaths = collectionView.indexPathsForVisibleItems
        guard let firstIndexPath = visibleIndexPaths.min() else {
            return
        }
        
        let currentRow = firstIndexPath.row / 3  // Assuming 3 columns
        
        if currentRow > photosScrolled {
            // Scrolling down
            let rowsScrolledDown = currentRow - photosScrolled
            if rowsScrolledDown >= 8 {
                // If scrolled down by 8 rows, increment the date
                photosScrolled = currentRow
                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
                updateDateLabel()
            }
        } else if currentRow < photosScrolled {
            // Scrolling up
            let rowsScrolledUp = photosScrolled - currentRow
            if rowsScrolledUp >= 8 {
                // If scrolled up by 8 rows, decrement the date
                photosScrolled = currentRow
                currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
                updateDateLabel()
            }
        }
    }
}
