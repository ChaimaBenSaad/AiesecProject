//
//  ViewController.swift
//  ChaymaApp
//
//  Created by mac on 04/12/2018.
//  Copyright © 2018 esprit. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
 var tasks:[NSManagedObject] = []

   
    var details: DetailsViewController?
    // List of completed tasks
    var Completedliste = [NSManagedObject]()
    //List of available tasks
    var Availableliste = [NSManagedObject]()
    
    // SectionHeader to distinguish tasks
    var sectionHeader = ["Completed" , "Available"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSManagedObject>(entityName:"Task")
        
        do{
            tasks = try managedContext.fetch(request)
        }
        catch let error as NSError
        {
            
            print(error)
        }
        
        // fill completed and available list
        for task in tasks {
            
            let date = task.value(forKeyPath: "dateCompletion") as? Date
            if (date?.timeIntervalSinceNow.sign == .minus) {
              
                Availableliste.append(task)
                
            } else {
              
                Completedliste.append(task)
            }
        }
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = sectionHeader[section]
       label.font = UIFont(name: label.font.fontName, size: 22)
       
     // Edit the backgroundColor of headerSection
        if ( section == 1)
        { label.backgroundColor = UIColor( red: CGFloat(246) / 255.0,green: CGFloat(139) / 255.0,blue: CGFloat(44) / 255.0,alpha: CGFloat(1.0))
        }
        else
        {
            label.backgroundColor = UIColor( red: CGFloat(189) / 255.0,green: CGFloat(218) / 255.0,blue: CGFloat(2) / 255.0,alpha: CGFloat(1.0))
        }
        return label
        
    }
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeader.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        if ( section == 1)
        {rows = Completedliste.count
           
             }
      else
        {
            rows = Availableliste.count
           
        }
        return rows
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "myCell")!
       var task = tasks[indexPath.row]
       //get data from coreData
        if ( indexPath.section == 1)
        { task = Completedliste[indexPath.row]
        }
        else
        {
            task = Availableliste[indexPath.row]
        }
        let lblTaskTitle:UILabel = myCell.viewWithTag(1) as! UILabel
        
        lblTaskTitle.text = task.value(forKeyPath: "title") as? String
        
        let lblCategoryName:UILabel = myCell.viewWithTag(2) as! UILabel
        lblCategoryName.text=task.value(forKeyPath: "categoryName") as? String
        
        let lblCategoryColor:UILabel = myCell.viewWithTag(3) as! UILabel
        let taskColor = task.value(forKeyPath: "categoryColor") as? String
        lblCategoryColor.backgroundColor = stringToColor(color: taskColor!)
        //lblCategoryColor.text=task.value(forKeyPath: "categoryColor") as? String
   
        return myCell
    }

    
    // function to get UIcolor from a string
    func stringToColor(color: String) ->UIColor
    {  var uiColor : UIColor
        switch color {
        case "Green":uiColor = UIColor.green
            break
        case "Red":uiColor = UIColor.red
             break
            case "Black":uiColor = UIColor.black
             break
            case "Yellow":uiColor = UIColor.yellow
             break
            case "Blue":uiColor = UIColor.blue
             break
            case "White":uiColor = UIColor.white
             break
        default:
            uiColor = UIColor.white
        }
        return uiColor
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle==UITableViewCellEditingStyle.delete
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            do{
                if ( indexPath.section == 1)
                {
                    
                    managedContext.delete(Completedliste[indexPath.row])
                    
                    try managedContext.save()
                    
                    Completedliste.remove(at: indexPath.row)
                }
                else
                {
                    managedContext.delete(Availableliste[indexPath.row])
                    
                    try managedContext.save()
                    
                    Availableliste.remove(at: indexPath.row)
                }
                
             
                
            }
            catch let error as NSError
            {
                print(error)
            }
        }
        
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailview:DetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "detailsView") as! DetailsViewController
        
        
        if ( indexPath.section == 1)
        { detailview.task = Completedliste[indexPath.row]
        }
        else
        {
            detailview.task = Availableliste[indexPath.row]
        }
        //send data of the  selected task to detailsViewController
        self.show(detailview, sender: nil)
    }
    

}

