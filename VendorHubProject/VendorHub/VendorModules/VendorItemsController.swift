//
//  VendorItemsController.swift
//  VendorHub
//
//  Created by Nana Bonsu on 4/5/22.
//

import UIKit
import Firebase
import FirebaseAuth
class VendorItemsController: UIViewController {
    
    let db = Firestore.firestore()
    let auth = Auth.auth()
   
    var VendorItems: Vendor!
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var TableViewEdit: UIBarButtonItem!
    
    @IBOutlet weak var addItem: UIBarButtonItem!
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
      //  if(auth.currentUser != nil){Progress}
        // Do any additional setup after loading the view.
        //no cnnection to table view omgggg
        VendorItems = Vendor()
        table.delegate = self
        table.dataSource = self
        //table.rowHeight = UITableView.automaticDimension
      
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //need to chheck if there are any documents here...
        super.viewDidAppear(animated)
       
        
        //snapshot listener that listens for changesx
        VendorItems.loadItemsData { dataGet in
            
                self.table.reloadData()
            
        }
    }

    
    @IBAction func VendroSignOut(_ sender: Any) {
        
        do {
            try auth.signOut()
            performSegue(withIdentifier: "unwindtoHome", sender: self)
        } catch {
            print(error.localizedDescription)
        }
       
    }
    
    //when b
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        
        if table.isEditing {
                   table.setEditing(false, animated: true)
                   sender.title = "Edit"
                   addItem.isEnabled = true
               } else {
                   table.setEditing(true, animated: true)
                   sender.title = "Done"
                   addItem.isEnabled = false
               }
           }
    
    func deleteItemCheck(indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: "Are you sure you'd like to delete this item", preferredStyle: .alert)

        // yes action
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            // replace data variable with your own data array
            FirestoreOps.shared.deleteVendorItem(vendorID: (self.auth.currentUser?.uid)!, itemID: self.VendorItems.Items[indexPath.row].itemID)
            self.VendorItems.Items.remove(at: indexPath.row)
           self.table.deleteRows(at: [indexPath], with: .fade)
            
        }
        
        alert.addAction(yesAction)

        // cancel action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }
    
}




extension VendorItemsController:UITableViewDelegate,UITableViewDataSource {
   
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VendorItems.Items.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 420
    }
  //sets ev
    func tableView(_ table: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = table.dequeueReusableCell(withIdentifier:"cell",for: indexPath) as? ItemDisplayCell {
            cell.DescriptionLabel?.text = VendorItems.Items[indexPath.row].itemDescription
            
            
            print(cell.DescriptionLabel.text!)
            cell.PriceLabel?.text = VendorItems.Items[indexPath.row].price
            
            cell.itemImage?.setImage(VendorItems.Items[indexPath.row].id)
            
            
         //   print(cell.PriceLabel.text)
        return cell
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteItemCheck(indexPath: indexPath)
        }
       
    }
    
   
}

