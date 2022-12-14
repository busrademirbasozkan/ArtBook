//
//  SecondVC.swift
//  ArtBook
//
//  Created by Büşra Özkan on 12.11.2022.
//

import UIKit
import CoreData

class SecondVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var artistTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var savebutton: UIButton!
    
    
    var chosenPainting = ""
    var chosenID : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // bir hücre seçilip içindeki bilgiler gösterilmek isteniyorsa yine coredatadan bilgiler alınır
        if chosenPainting != "" {
            //savebutton.isEnabled = false // Verileri görüntülemek için açtığımızda savebutton tıklanamaz duruma geldi.
            savebutton.isHidden = true
            
            //CoreData
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
            let idString = chosenID?.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            do{
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject]{
                        if let name = result.value(forKey: "name") as? String{
                            nameTextField.text = name
                        }
                        if let artist = result.value(forKey: "artist") as? String{
                            artistTextField.text = artist
                        }
                        if let year = result.value(forKey: "year") as? Int{
                            yearTextField.text = String(year)
                        }
                        if let imageData = result.value(forKey: "image") as? Data{
                            let image = UIImage(data: imageData)
                            imageView.image = image
                        }
                    }
                }
            }
            catch{
            }
        }else{
            savebutton.isHidden = false
            savebutton.isEnabled = false
        }
        
        
        
        
        //Recognizer
        //klavyeyi kapatmak için
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gesture) //view olduğunda ekranda herhangi bir yere bastığımızda recognizerın çalışmasını sağlar.
        
        //Görsel seçmek için
        imageView.isUserInteractionEnabled = true
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(imageGesture)
        
}
    
    //Resme tıklanınca resim seçmek için gerekli işlemleri tanımlamak içim
    @objc func selectImage(){
        //UIImagePickerController kullanıcının kamerasına yada medya kütüphanesine erişebilmemizi saplayan bir sınıf
        let picker = UIImagePickerController()
        picker.delegate = self // Bu işlemler için gerekli protokoller eklenmeli ve yetki viewcontrollera verilmeli
        picker.sourceType = .photoLibrary // camera yada photolibrary seçebilir.
        picker.allowsEditing = true // zoomlamak gibi edit yapmaya izin verme yada vermeme için
        present(picker, animated: true, completion: nil)
        
    }
    
    
    //görseli seçince ne olacağını tanımalamalıyız
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage // seçilen resmi original yada editlenmiş olarak mı kaydedeceğimizi seçeriz. Casting yaparak gerçekleşitirilir çünkü kullanıcı fotoğraf seçmeyebilir. Böyle bir durumda sıkıntı yaşanmaması için
        savebutton.isEnabled = true
        self.dismiss(animated: true) // açılan pickerın kapatılabilmesi için
    }
    
    
    //Klavyeyi ekranda herhangi bir yere basıldıpında kapatmak için
    @objc func hideKeyboard(){
        view.endEditing(true) // view içinde yapılan değişiklikleri bitiriyor.
        
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        //Coredatada verileri kaydedebilmek için contexte erişebilmemiz gerekli. Contexte erişebilmek için AppDelegate bir değişken olarak tanımlanmalı.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext // AppDelegate içindeki contexte erişebildim.
        
        let newPainting = NSEntityDescription.insertNewObject(forEntityName: "Paintings", into: context) // contextin içine ne ekleyeceğimizi belirlememiz gerekir. Burda daha önce coredata da tanımladığımız entityi seçeriz.
        
        //Entitydeki attributeları ilgili yerlere tanımlarız
        newPainting.setValue(nameTextField.text!, forKey: "name")
        newPainting.setValue(artistTextField.text!, forKey: "artist")
        if let year = Int(yearTextField.text!) { // yearın int olarak kaydedilmesi sağlanmalı
            newPainting.setValue(year, forKey: "year")
        }
        newPainting.setValue(UUID(), forKey: "id") // swift bizim için bir id oluşturup kaydedecek.
        //image in data olarak çevrilmesi
        let data = imageView.image?.jpegData(compressionQuality: 0.5) //compressionQuality resmin % kaçını alacağımızı belirtmemizi istiyor.
        newPainting.setValue(data, forKey: "image")
        
        // context'i kaydederiz
        do{
            try context.save()
            print("success")
        }
        catch{
            print("error")
        }
        
        
        //Tableviewa dönmeden önce yeni eklenen resmin bilgilerinin tableviewa eklenmesi
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil) // diğer view controllerlara mesaj yollamamızı sağlıyor
        
        
        // save buttonuna basınca tekrar tableviewa dönebilmek için
        self.navigationController?.popViewController(animated: true)
        
        
        
    }
    
}
