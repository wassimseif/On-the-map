//
//  StudentTableViewController.swift
//  OnTheMap
//
//  Created by Wassim Seifeddine on 13/4/16.
//  Copyright (c) 2016 Wassim Seifeddine. All rights reserved.
//

import UIKit

class StudentTableViewController: UITableViewController,UINavigationBarDelegate {
    
    @IBOutlet weak var studentsTableView: UITableView!
    
    var alert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Helper.isConnectedToNetwork(){
        StudentClient.sharedInstance().getStudentLocations { (success, errorString) -> Void in
            if(success) {
                self.studentsTableView.reloadData()
            }
            else{
                Helper.displayAlert(inViewController: self.alert!, withTitle: "Error", message: "Error dowmloading student data", completionHandler: { (alertAction) -> Void in
                    self.alert!.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        }
        } else {
            let alert = UIAlertController(title: "Network error", message: "Please make sure device is connected to Wi-Fi or phone data", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
//        // Create the navigation bar
//        let navigationBar = UINavigationBar(frame: CGRectMake(0, 20, self.view.frame.size.width, 44))
//        navigationBar.backgroundColor = UIColor.whiteColor()
//        navigationBar.delegate = self;
//        
//        // Create a navigation item with a title
//        let navigationItem = UINavigationItem()
//        navigationItem.title = "On The Map"
//        
        // Create left and right button for navigation item
        let logoutButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logoutButton")
        let postButton = UIBarButtonItem(image: UIImage(named: "pin"), style: UIBarButtonItemStyle.Plain, target: self, action: "tapPost")
        let refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refreshStudents")
        
        // Create three buttons for the navigation item
        navigationItem.leftBarButtonItem = logoutButton
        navigationItem.setRightBarButtonItems([refreshButton,postButton], animated: true)
        
        // Assign the navigation item to the navigation bar
       // navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
       // let ns = NSLayoutConstraint(item: navigationBar, attribute: .Top , relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 0)
        //navigationBar.addConstraint(ns)
      //  self.view.addSubview(navigationBar)
        
        
        navigationController?.title = "On The Map  "
        
        navigationController?.navigationBar.topItem?.title = "On the map"
        
        navigationController?.navigationBar.items = [navigationItem]
        
        
        

        // Reload table view
        var studentLocations = model.studentLocations
        self.studentsTableView.reloadData()
        
    }
    
    func refreshStudents() {
        if Helper.isConnectedToNetwork(){
        StudentClient.sharedInstance().getStudentLocations { (success, errorString) -> Void in
            if(success) {
                self.studentsTableView.reloadData()
            }
            else{
                Helper.displayAlert(inViewController: self.alert!, withTitle: "Error", message: "Error dowmloading student data", completionHandler: { (alertAction) -> Void in
                    self.alert!.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        }
        } else {
            let alert = UIAlertController(title: "Network error", message: "Please make sure device is connected to Wi-Fi or phone data", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

        }
    }
    
    // Logout Button
    func logoutButton() {
        UdacityClient.sharedInstance().logoutSession()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Load Information posting view
    func tapPost(){
        let vc: UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("InformationPostingVC") 
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    //MARK: Table View Methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.studentLocations.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentTableViewCell",forIndexPath: indexPath) 
        cell.textLabel!.text = model.studentLocations[indexPath.row].description
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if model.studentLocations[indexPath.row].mediaURL != "" {
        UIApplication.sharedApplication().openURL(NSURL(string: model.studentLocations[indexPath.row].mediaURL)!)
        }
    }
    
}
