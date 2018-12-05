//
//  DetailsViewController.swift
//  ChaymaApp
//
//  Created by mac on 04/12/2018.
//  Copyright © 2018 esprit. All rights reserved.
//

import UIKit
import CoreData
class DetailsViewController: UIViewController ,UIPickerViewDelegate,UIPickerViewDataSource{

    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var dateCompletion: UIDatePicker!
    @IBOutlet weak var txtCategoryName: UITextField!
    @IBOutlet weak var txtTaskTitle: UITextField!
    @IBOutlet weak var pickerColor: UIPickerView!
    let colors = ["Red","Yellow","Green","Blue", "Black", "White"]
    var CategoryColor : String = ""
    var task : NSManagedObject?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        container.layer.cornerRadius = container.frame.width/9.0
        container.clipsToBounds = true
        btnEdit.layer.cornerRadius = btnEdit.frame.width/9.0
        btnEdit.clipsToBounds = true
        btnDelete.layer.cornerRadius = btnDelete.frame.width/9.0
        btnDelete.clipsToBounds = true
        pickerColor.delegate = self
        pickerColor.dataSource = self
        //put by default the value of the  selected task
        txtTaskTitle.text = task?.value(forKey: "title") as? String
        txtCategoryName.text = task?.value(forKey: "categoryName") as? String
        //get the index of category color
        let index = colors.index(of: (task?.value(forKey: "categoryColor") as? String)!)
        pickerColor.selectRow(index!, inComponent:0, animated:true)
        dateCompletion.date = (task?.value(forKey: "dateCompletion") as? Date)!
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func EditTask(_ sender: Any) {
        
          updateTask(task: task!, title: txtTaskTitle.text!, categoryName: txtCategoryName.text!, categoryColor: CategoryColor, dateCompletion: dateCompletion.date)
        
         // pass to the List of tasks
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Tasks") as! ViewController
        self.show(nextViewController, sender: nil)
    }
    
    
    @IBAction func DeleteTask(_ sender: Any) {
        deleteTask(task: task!)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Tasks") as! ViewController
        self.show(nextViewController, sender: nil)
    }
    
    // function to display alert message
    func displayMyAlertMessage(userMessage:String)
    {
        
        let myalert = UIAlertController(title:"alert", message: userMessage , preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title:"OK", style: UIAlertActionStyle.default , handler:nil);
        myalert.addAction(okAction);
        self.present(myalert ,animated:true , completion:nil);
        
        
    }
    
  
    
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colors.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colors[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        CategoryColor=colors[row]
    }
    
    
 // function getContext
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
     // fucntion to update the selected task in coreData
    func updateTask(task : NSManagedObject,title:String, categoryName:String, categoryColor:String, dateCompletion:Date) {
        
        if (title.isEmpty )||(categoryName.isEmpty) || (categoryColor.isEmpty)
        { displayMyAlertMessage(userMessage: "All field are requiered !")}
        else
        {

       
        let context = getContext()
       
        
        do {
            
            
            task.setValue(title, forKey: "title")
            task.setValue(categoryName, forKey: "categoryName")
            task.setValue(categoryColor, forKey: "categoryColor")
            task.setValue(dateCompletion, forKey: "dateCompletion")
            
            
            
            //save the context
            do {
                try context.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                
            }
              }
            
        }
    }
    
    
    // fucntion to delete the selected task from coreData
    func deleteTask(task : NSManagedObject) {
        
        let context = getContext()
        do{
            context.delete(task)
            
            try context.save()
        
        }
        catch let error as NSError
        {
            print(error)
        }
        
      
        
       
    }
    

}
