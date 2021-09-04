//
//  AddPhotoViewController.swift
//  PhotoList
//
//  Created by Burak İmdat on 3.09.2021.
//

import UIKit
import CoreData

class AddPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var pc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedItem: Entity?
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var btnSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if IsSelectedItemEmpty() {
            self.navigationItem.title = "Add a new photo"
        } else {
            self.navigationItem.title = selectedItem?.titleText
            txtTitle.text = selectedItem?.titleText
            txtDescription.text = selectedItem?.descriptionText
            if let selectedImage = selectedItem?.image {
                imgPhoto.image = UIImage(data: (selectedImage as Data))
            }
            
            btnSave.setTitle("Update", for: .normal)
        }

    }
    
    @IBAction func btnCameraClicked(_ sender: UIButton) {
        openPicker(.camera)
    }
    
    
    @IBAction func btnGalleryClicked(_ sender: UIButton) {
        openPicker(.photoLibrary)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage  {
            imgPhoto.image = selectedImage
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func openPicker(_ sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func btnSaveClicked(_ sender: UIButton) {
        if IsSelectedItemEmpty() {
            let entityDescription = NSEntityDescription.entity(forEntityName: "Entity", in: pc)
            let newItem = Entity(entity: entityDescription!, insertInto: pc)
            newItem.titleText = txtTitle.text
            newItem.descriptionText = txtDescription.text
            newItem.image = imgPhoto.image!.jpegData(compressionQuality: 0.8) as NSData?
        } else {
            selectedItem?.titleText = txtTitle.text
            selectedItem?.descriptionText = txtDescription.text
            selectedItem?.image = imgPhoto.image?.jpegData(compressionQuality: 0.8) as NSData?
        }
        
        
        do {
            if pc.hasChanges {
                try pc.save()
            }
        } catch  {
            print(error)
            return
        }
        navigationController?.popViewController(animated: true)
    }
    
    func IsSelectedItemEmpty() -> Bool {
        return selectedItem == nil
    }
    @IBAction func dismissKeyboard(_ sender: UITextField) {
        self.resignFirstResponder()
    }
}
