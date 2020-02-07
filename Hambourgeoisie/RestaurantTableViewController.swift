//
//  RestaurantTableViewController.swift
//  FoodTracker
//
//  Created by Jane Appleseed on 11/15/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import Nuke
import os.log
import UIKit

class RestaurantTableViewController: UITableViewController {
    // MARK: Properties

    var restaurants = [RestaurantShow]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem

        // We dont want to initialize view when testing
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            return
        }

        // Load any saved restaurants, otherwise load sample data.
        DispatchQueue.global(qos: .userInitiated).async {
            self.reloadAllRestaurants()
        }

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshRestaurants(_:)), for: .valueChanged)
        refreshControl?.tintColor = UIColor(red: 0.25, green: 0.72, blue: 0.85, alpha: 1.0)
        refreshControl?.attributedTitle = NSAttributedString(string: "Fetching Restaurants ...", attributes: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "RestaurantTableViewCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RestaurantTableViewCell else {
            fatalError("The dequeued cell is not an instance of RestaurantTableViewCell.")
        }

        // Fetches the appropriate restaurant for the data source layout.
        let restaurant = restaurants[indexPath.row]

        cell.nameLabel.text = restaurant.name
        if let path = restaurant.images?.first,
            let url = GlobalData.completeURLforResource(resource: path) {
            print("loading image \(url)")
            Nuke.loadImage(with: url, into: cell.photoImageView)
        } else {
            cell.photoImageView.image = UIImage(named: "defaultPhoto")
        }

        cell.ratingControl.rating = restaurant.rating ?? 0

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            ServiceLayer.request(api: .deleteRestaurant(restaurants[indexPath.row].id)) { (result: Result<String, Error>) in
                switch result {
                case .success:
                    print("The restaurant was deleted")

                case .failure:
                    print("The restaurant could not be deleted")
                }
            }
            restaurants.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        switch segue.identifier ?? "" {
        case "AddItem":
            print("Adding a new restaurant.")

        case "ShowDetail":
            guard let restaurantDetailViewController = segue.destination as? RestaurantShowViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }

            guard let selectedRestaurantCell = sender as? RestaurantTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }

            guard let indexPath = tableView.indexPath(for: selectedRestaurantCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }

            let selectedRestaurant = restaurants[indexPath.row]
            restaurantDetailViewController.restaurant = selectedRestaurant

        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }

    // MARK: Actions

    @IBAction func unwindToRestaurantList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? RestaurantShowViewController, let restaurant = sourceViewController.restaurant {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing restaurant.
                restaurants[selectedIndexPath.row] = restaurant
                ServiceLayer.request(api: .updateRestaurant(restaurant.id, RestaurantUpdateData(restaurantShow: restaurant))) { (result: Result<String, Error>) in
                    switch result {
                    case .success:
                        print(result)
                    case .failure:
                        print(result)
                    }
                }
                reloadAllRestaurants()
            }

        } else if let sourceViewController = sender.source as? RestaurantCreateViewController,
            let restaurant = sourceViewController.restaurant {
            // Add a new restaurant.
            ServiceLayer.request(api: .createRestaurant(restaurant)) { [weak self] (result: Result<RestaurantShow, Error>) in
                switch result {
                case .success:
                    print(result)
                    self?.reloadAllRestaurants()
                case .failure:
                    print(result)
                }
            }
        }
    }

    // MARK: Private Methods

    @objc private func refreshRestaurants(_ sender: Any) {
        // Fetch Weather Data
        reloadAllRestaurants()
    }

    private func reloadAllRestaurants() {
        if let allRestaurants = loadRestaurants() {
            restaurants = allRestaurants
        } else {
            print("The restaurants could not be loaded")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        DispatchQueue.global().async {
            usleep(500_000)
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
            }
        }
    }

    private func loadSampleRestaurants() {
//        let photo1 = "https://u.tfstatic.com/restaurant_photos/121/311121/169/612/la-fabrica-21-entrada-1d13d.jpg")
//        let photo2 = "https://imag.bonviveur.es/articulos/vista-exterior-de-la-cafeteria-restaurante-casa-dani-de-madrid.jpg");
//        let photo3 = "https://u.tfstatic.com/restaurant_photos/725/281725/169/612/mad-grill-vista-entrada-2288b.jpg")
//
//        guard let restaurant1 = RestaurantShow(id: "888", name: "La fabrica 21", photos: [photo1!], rating: 4, desc: "") else {
//            fatalError("Unable to instantiate restaurant1")
//        }
//
//        guard let restaurant2 = RestaurantShow(id: "888", name: "Casa Dani", photos: [photo2!], rating: 5, desc: "") else {
//            fatalError("Unable to instantiate restaurant2")
//        }
//
//        guard let restaurant3 = RestaurantShow(id: "888", name: "Mad Grill", photos: [photo3!], rating: 3, desc: "") else {
//            fatalError("Unable to instantiate restaurant2")
//        }
//
//        restaurants += [restaurant1, restaurant2, restaurant3]
    }

    private func loadRestaurants() -> [RestaurantShow]? {
        var restArray: [RestaurantShow]?
        let semaphore = DispatchSemaphore(value: 0)
        ServiceLayer.request(api: .getRestaurants(nil)) { (result: Result<[RestaurantShow], Error>) in
            switch result {
            case let .success(array):
                restArray = array
            case .failure:
                print(result)
            }
            semaphore.signal()
        }
        semaphore.wait()
        return restArray
    }
}
