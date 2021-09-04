//
//  TableViewController.swift
//  PhotoList
//
//  Created by Burak İmdat on 3.09.2021.
//

import UIKit
import CoreData

class TableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var frc: NSFetchedResultsController = NSFetchedResultsController<NSFetchRequestResult>()
    // Persistent container
    var pc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // This func borrows datas from database
    func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        let sorter = NSSortDescriptor(key: "titleText", ascending: true)
        fetchRequest.sortDescriptors = [sorter]
        
        return fetchRequest
    }
    
    func getFRC() -> NSFetchedResultsController<NSFetchRequestResult>{
        frc = NSFetchedResultsController(fetchRequest: fetchRequest(), managedObjectContext: pc, sectionNameKeyPath: nil, cacheName: nil)
        return frc
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        frc = getFRC()
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            print(error)
            return
        }
        
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = frc.sections?[section].numberOfObjects
        return numberOfRows!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TableViewCell else { return UITableViewCell() }
        guard let dataRow = frc.object(at: indexPath) as? Entity else { return UITableViewCell() }
        
        cell.lblTitle.text = dataRow.titleText
        cell.lblDescription.text = dataRow.descriptionText
        cell.imgPhoto.image = UIImage(data: (dataRow.image)! as Data)
        return cell
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEdit" {
            let selectedCell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: selectedCell)
            
            if let addPhotoVC: AddPhotoViewController = segue.destination as? AddPhotoViewController,
               let selectedItem: Entity = frc.object(at: indexPath!) as? Entity {
                addPhotoVC.selectedItem = selectedItem
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let managedObject: NSManagedObject = frc.object(at: indexPath) as! NSManagedObject
        pc.delete(managedObject)
        
        do {
            try pc.save()
        } catch  {
            print(error)
            return
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
