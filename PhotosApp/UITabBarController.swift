
//  UITabBarController.swift

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let libraryVC = PhotosViewController()
        let forYouVC = ForYouViewController()
        let albumsVC = AlbumsViewController()
        let searchVC = SearchViewController()
        
        libraryVC.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "photo.on.rectangle"), tag: 0)
        forYouVC.tabBarItem = UITabBarItem(title: "For You", image: UIImage(systemName: "heart.text.square"), tag: 1)
        albumsVC.tabBarItem = UITabBarItem(title: "Albums", image: UIImage(systemName: "rectangle.stack.fill"), tag: 2)
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 3)
        
        let controllers = [libraryVC, forYouVC, albumsVC, searchVC]
        viewControllers = controllers.map { UINavigationController(rootViewController: $0) }
    }
}
