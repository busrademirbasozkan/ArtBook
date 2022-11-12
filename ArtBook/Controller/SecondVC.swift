//
//  SecondVC.swift
//  ArtBook
//
//  Created by Büşra Özkan on 12.11.2022.
//

import UIKit

class SecondVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var artistTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        //Recognizer
        //klavyeyi kapatmak için
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gesture)
        
        //Görsel seçmek için
        imageView.isUserInteractionEnabled = true
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(imageGesture)
        
}
    
    //Resme tıklanınca resim seçmek için gerekli işlemleri tanımlamak içim
    @objc func selectImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    
    //görseli seçince ne olacağını tanımalamalıyız
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
        
    }
    
    
    //Klavyeyi ekranda herhangi bir yere basıldıpında kapatmak için
    @objc func hideKeyboard(){
        view.endEditing(true)
        
    }
    
    @IBAction func saveButton(_ sender: Any) {
    }
    
}
