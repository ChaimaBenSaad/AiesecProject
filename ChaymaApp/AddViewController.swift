//
//  AddViewController.swift
//  ChaymaApp
//
//  Created by mac on 04/12/2018.
//  Copyright © 2018 esprit. All rights reserved.
//

import UIKit
import CoreData
class AddViewController: UIViewController ,UIPickerViewDelegate,UIPickerViewDataSource{
 
   
  
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var txtCategoryName: UITextField!
    @IBOutlet weak var txtTitleTask: UITextField!
    @IBOutlet weak var dateCompletion: UIDatePicker!
    @IBOutlet weak var pickerDate: UIPickerView!
    let colors = ["Red","Yellow","Green","Blue","Black", "White"]
    var CategoryColor : String = ""
    var tasks:[NSManagedObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerDate.delegate = self
        pickerDate.dataSource = self
        
        container.layer.cornerRadius = container.frame.width/9.0
        container.clipsToBounds = true
        btnAdd.layer.cornerRadius = btnAdd.frame.width/9.0
        btnAdd.clipsToBounds = true
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // set Category Colors
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colors.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colors[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       CategoryColor=colors[row]
    }
    
    @IBAction func AddTask(_ sender: Any) {

        
        saveTask(title:txtTitleTask.text!,categoryName:txtCategoryName.text!,categoryColor: CategoryColor ,dateCompletion: dateCompletion.date)
        
        // pass to the List of tasks
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
        self.present(myalert ,animated:true , completion:nil)
        
        
    }
    
    
    // function to save new task in coreData
    
    func saveTask(title:String, categoryName:String, categoryColor:String ,dateCompletion:Date)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        if (title.isEmpty )||(categoryName.isEmpty) || (categoryColor.isEmpty)
        { displayMyAlertMessage(userMessage: "All field are requiered !")}
        else
         {
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext)
        
        let task = NSManagedObject(entity:entity!, insertInto:managedContext)
        
        task.setValue(title, forKey: "title")
        
        task.setValue(categoryName, forKey: "categoryName")
        task.setValue(categoryColor, forKey: "categoryColor")
         task.setValue(dateCompletion, forKey: "dateCompletion")
        
      
        do{
            try managedContext.save()
            
            tasks.append(task)
            print ("okkk")
            
        }
        catch let error as NSError
        {
            print(error)
        }
        }
        
    }


}
