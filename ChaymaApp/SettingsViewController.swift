//
//  SettingsViewController.swift
//  ChaymaApp
//
//  Created by mac on 04/12/2018.
//  Copyright © 2018 esprit. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData
class SettingsViewController: UIViewController {
    
 private let notificationPublisher = NotificationPublisher()
    @IBOutlet weak var mySwitch: UISwitch!
    @IBOutlet weak var container: UIView!
     var tasks:[NSManagedObject] = []
    //List of available tasks
    var Availableliste = [NSManagedObject]()
    
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
        for task in tasks {
           
            let date = task.value(forKeyPath: "dateCompletion") as? Date
            if !(date?.timeIntervalSinceNow.sign == .minus) {
              
                Availableliste.append(task)
                
            }
            
          
        }
        
        container.layer.cornerRadius = container.frame.width/9.0
        container.clipsToBounds = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func switchNotification(_ sender: Any) {
        
     
        if mySwitch.isOn
        {
            //test if there are tasks available notify the user
            if !Availableliste.isEmpty
            {print (Availableliste.count)
            notificationPublisher.sendNotification(tittle: "You have tasks to complete!" , subtitle: "" , body: "Open the task manager to see which tasks" , badge : 1 , delayInterval: nil)
           
                
                 }
        } else
        {
            
            let center = UNUserNotificationCenter.current()
            center.removeAllDeliveredNotifications() // To remove all delivered notifications
            center.removeAllPendingNotificationRequests() // To remove all pending notifications which are not delivered yet but scheduled
            
        }
        
      
        
    }

    

    

}
