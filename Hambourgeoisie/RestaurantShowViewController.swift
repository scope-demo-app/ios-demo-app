//
//  RestaurantViewController.swift
//  Hambourgeoisie
//
//  Created by Ignacio Bonafonte on 03/02/2020.
//  Copyright © 2020 Undefined Labs. All rights reserved.
//

import os.log
import UIKit
import Nuke
import UITextView_Placeholder
import MapKit

class RestaurantShowViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: Properties

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var ratingControl: RatingControl!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet weak var descriptionTextView: UITextView!

    var photoURL:String? = nil

    /*
     This value is either passed by `RestaurantTableViewController` in `prepare(for:sender:)`
     */
    var restaurant: RestaurantShow?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self

        // Set up views if editing an existing Restaurant.
        if let restaurant = restaurant {
            print("Show restaurant: \(restaurant.name)")

            navigationItem.title = restaurant.name
            nameTextField.text = restaurant.name
            if let url = restaurant.images?.first,
                let photoURL = GlobalData.completeURLforResource(resource: url) {
                Nuke.loadImage(with: photoURL, into: photoImageView)
            } else {
                photoImageView.image = UIImage(named: "defaultPhoto")
            }
            ratingControl.rating = restaurant.rating ?? 0.0
            descriptionTextView.text = restaurant.desc
        }
        // Enable the Save button only if the text field has a valid Restaurant name.
        updateSaveButtonState()
    }

    // MARK: UITextFieldDelegate

    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }

    // MARK: UIImagePickerControllerDelegate

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }

        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage

        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }

    // MARK: Navigation

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        print("cancel Show")

        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddRestaurantMode = presentingViewController is UINavigationController

        if isPresentingInAddRestaurantMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The RestaurantViewController is not inside a navigation controller.")
        }
    }

    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            print("The save button was not pressed, cancelling")
            return
        }

        let name = nameTextField.text ?? ""
        let rating = ratingControl.rating
        let desc = descriptionTextView.text

        // Set the restaurant to be passed to RestaurantTableViewController after the unwind segue.
        restaurant = RestaurantShow(id: restaurant?.id ?? "", name: name, images:(photoURL != nil) ? [photoURL!] : nil, rating: rating, desc:desc, latitude: restaurant?.latitude ?? "", longitude:  restaurant?.longitude ?? "")
    }

    // MARK: Actions

    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        print("Select image from photo library")

        // Hide the keyboard.
        nameTextField.resignFirstResponder()

        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()

        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary

        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func showInMaps(_ sender: Any) {
        print("Show in Maps")

        if let rest = restaurant {
            openMapForRestaurant(rest: rest)
        }
    }
    // MARK: Private Methods

    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }

    private func openMapForRestaurant(rest: RestaurantShow) {
        guard let lat = rest.latitude, let lon =  rest.longitude  else {
            return
        }
        let latitude:CLLocationDegrees =  CLLocationDegrees(lat)!
        let longitude:CLLocationDegrees =  CLLocationDegrees(lon)!

        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(rest.name)"
        mapItem.openInMaps(launchOptions: options)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (key.rawValue, value) })
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
