//
//  ViewController.swift
//  ArtBook
//
//  Created by Büşra Özkan on 12.11.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    //Kullanıcının contexte kaydettiği verilerden sadece isim ve id bizim için geçerli. çünkü sadece tableview içine ismi kayıt edeceğiz.
    var idArray = [UUID]()
    var nameArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
        
        // + tuşunu eklemek için
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addClicked))
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newData"), object: nil)
        
    }
    
    
    
    
    @objc func addClicked(){
        performSegue(withIdentifier: "SecondVC", sender: nil)
    }
    
    //Bu fonksiyon altında coredatadan verilerimizi çekeceğiz.
    @objc func getData(){
        
        //coredatadaki bilgileri almadan önce array temizlenmeli ki aynı verileri tekrar tekrar kaydetmesin
        nameArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        
        // contexti yine çağırmamız gerek
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //fetch ile dataları çekme
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings") // context.fetch ile verileri çekmek için önce bu işlemi yapmamız gerek.
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest) //results bir dizi. fetch ettiğimiz değişkenleri bu diziye atayarak tek tek inceleyebilirim
            
            for result in results as! [NSManagedObject]{ //NSManagedObject coredata model objesi
                if let name = result.value(forKey: "name") as? String{
                    self.nameArray.append(name)
                }
                if let id = result.value(forKey: "id") as? UUID{
                    self.idArray.append(id)
                }
                
                self.tableView.reloadData() // tableviewa yeni verinin geldiğini ve güncelleme yapılması gerektiğini bildirir.
            }
            
        }
        catch{
            
        }
}
    
    //TableView için func
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }
    
}
