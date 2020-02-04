//
//  RestaurantTableViewController.swift
//  FoodTracker
//
//  Created by Jane Appleseed on 11/15/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import os.log
import UIKit

class RestaurantTableViewController: UITableViewController {
    // MARK: Properties

    var restaurants = [RestaurantShow]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem

        // Load any saved restaurants, otherwise load sample data.
        if let savedRestaurants = loadRestaurants() {
            restaurants += savedRestaurants
        } else {
            // Load the sample data.
            loadSampleRestaurants()
        }
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
        if let data = restaurant.photos?.first {
            cell.photoImageView.image = UIImage(data: data)
        } else {
            cell.photoImageView.image = UIImage(named: "defaultPhoto")
        }

        cell.ratingControl.rating = restaurant.rating

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
            restaurants.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)

            ServiceLayer.request(api: .deleteRestaurant(restaurants[indexPath.row].id)) { (result: Result<RestaurantShow, Error>) in
                switch result {
                case .success:
                    os_log("The restaurant was deleted", log: OSLog.default, type: .debug)

                case .failure:
                    os_log("Te restaurant could not be deleted", log: OSLog.default, type: .debug)
                }
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        switch segue.identifier ?? "" {
        case "AddItem":
            os_log("Adding a new restaurant.", log: OSLog.default, type: .debug)

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
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    //self.tableView.reloadRows(at: [selectedIndexPath], with: .none)
                }
                ServiceLayer.request(api: .editRestaurant(restaurant)) { (result: Result<RestaurantShow, Error>) in
                    switch result {
                    case .success:
                        print(result)
                    case .failure:
                        print(result)
                    }
                }
            }

        } else if let sourceViewController = sender.source as? RestaurantCreateViewController,
            let restaurant = sourceViewController.restaurant {
            // Add a new restaurant.
            ServiceLayer.request(api: .createRestaurant(restaurant)) { [weak self] (result: Result<RestaurantCreate, Error>) in
                switch result {
                case .success:
                    print(result)
                    self?.tableView.reloadData()
                case .failure:
                    print(result)
                }
            }
        }
    }

    // MARK: Private Methods

    private func loadSampleRestaurants() {
        let photo1 = UIImage(named: "restaurant1")?.jpegData(compressionQuality: 0.5)
        let photo2 = UIImage(named: "restaurant2")?.jpegData(compressionQuality: 0.5)
        let photo3 = UIImage(named: "restaurant3")?.jpegData(compressionQuality: 0.5)

        guard let restaurant1 = RestaurantShow(id: "666", name: "La fabrica 21", photos: [photo1!], rating: 4, desc: "") else {
            fatalError("Unable to instantiate restaurant1")
        }

        guard let restaurant2 = RestaurantShow(id: "666", name: "Casa Dani", photos: [photo2!], rating: 5, desc: "") else {
            fatalError("Unable to instantiate restaurant2")
        }

        guard let restaurant3 = RestaurantShow(id: "666", name: "Mad Grill", photos: [photo3!], rating: 3, desc: "") else {
            fatalError("Unable to instantiate restaurant2")
        }

        restaurants += [restaurant1, restaurant2, restaurant3]
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
