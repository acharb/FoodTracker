import UIKit
import os.log // logging to console
// Scene for adding a new meal

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    
    
    /*
     This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new meal.
     */
    var meal: Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field's user input with delegate callbacks
        nameTextField.delegate = self
        // when ViewController instantiated, it sets itself as the text field's delegate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Action called when text field presses return
        // Hide the keyboard
        // First responder - first object to receive events, resigning that when user clicks return
        textField.resignFirstResponder()
        return true // tells system to process press of return key
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // called after textfield resigns as first responder
        // can do something with the text that was entered
        
        
    }
    
    
    
    
    
    
    // MARK: UIImagePickerControllerDelegate functions
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // if cancelled, dismiss picker
        dismiss(animated:true,completion:nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else{
            fatalError("Expected a dictionary containing an image, but was provided with the following: \(info)")
        }
        //assigning image to outlet (element in UI)
        photoImageView.image = selectedImage
        
        //dismiss picker
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Navigation
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        super.prepare(for: segue, sender: sender) // doesn't do anything, good habit
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        meal = Meal(name: name, photo: photo, rating: rating)
    }
    
    // MARK: Actions
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        let imagePickerController = UIImagePickerController() // view controller for picking media from photo library
        
        //only let photos be chosen, not taken
        // really UIImagePickerControllerTypeSourceType.photoLibrary
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        // animate - animates presenetation? completion - code to run once completed
        present(imagePickerController,animated:true,completion:nil)
    }
    
}

