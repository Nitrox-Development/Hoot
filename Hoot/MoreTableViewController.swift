//
//  MoreTableViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/13/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit
import Social

class MoreTableViewController: UITableViewController {
    
    var sectionZero = ["10 Tokens For 100 Points", "20 Tokens For 250 Points", "50 Tokens For 400 Points"]
    var sectionOne = ["Twitter", "Facebook", "App Store"]
    var sectionTwo = ["Rules", "Contact Us"]
    var sectionThree = ["My Questions", "My Class Questions", "Log Out"]
    var points = String()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        var currentUser = PFUser.currentUser()
        do {
            try currentUser?.fetchInBackgroundWithBlock(nil)
        }catch{
            //nothing
        }
        points = String(currentUser!.objectForKey("points")!)
        let myPoints:UIBarButtonItem = UIBarButtonItem(title: self.points, style: .Plain, target: self, action: nil)
        self.navigationItem.setRightBarButtonItem(myPoints, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var currentUser = PFUser.currentUser()
        do {
            try currentUser?.fetchInBackgroundWithBlock(nil)
        }catch{
            //nothing
        }
        points = String(currentUser!.objectForKey("points")!)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        //MARK: Nav Bar Customize
        navigationController!.navigationBar.barTintColor = UIColor(red: 255.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
        let myPoints:UIBarButtonItem = UIBarButtonItem(title: self.points, style: .Plain, target: self, action: nil)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(14.0)], forState: UIControlState.Normal)
        self.navigationItem.setRightBarButtonItem(myPoints, animated: true)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.title = "More"
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        if section == 0 {
            return 3
        }else if section == 1 {
            return 3
        }else if section == 2 {
            return 2
        }else {
            return 3
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Get Tokens"
        }else if section == 1 {
            return "Help Us Out"
        }else if section == 2 {
            return "Extra Information"
        }else {
            return "My Stuff"
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("moreCell", forIndexPath: indexPath)
        let row = indexPath.row
        // Configure the cell...
        if indexPath.section == 0 {
            cell.textLabel?.text = sectionZero[row]
        }else if indexPath.section == 1 {
            cell.textLabel?.text = sectionOne[row]
        }else if indexPath.section == 2 {
            cell.textLabel?.text = sectionTwo[row]
        }else {
            cell.textLabel?.text = sectionThree[row]
        }
    return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        if indexPath.section == 0{
            var currentUser = PFUser.currentUser()
            if row == 0{
                if Int((currentUser?.objectForKey("tokens"))! as! NSNumber) >= 50{
                    let alert = UIAlertController(title: "Max Tokens", message: "You already have over 50 tokens, save your points for some other cool stuff.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    presentViewController(alert, animated: true, completion: nil)
                }else if Int((currentUser?.objectForKey("points"))! as! NSNumber) >= 100{
                    currentUser?.incrementKey("tokens", byAmount: 10)
                    currentUser?.incrementKey("points", byAmount: -100)
                    currentUser?.saveInBackground()
                    do {
                        try currentUser?.fetchInBackgroundWithBlock(nil)
                    }catch{
                        //nothing
                    }
                    points = String(currentUser!.objectForKey("points")!)
                    let myPoints:UIBarButtonItem = UIBarButtonItem(title: self.points, style: .Plain, target: self, action: nil)
                    self.navigationItem.setRightBarButtonItem(myPoints, animated: true)
                    let alert = UIAlertController(title: "Tokens Obtained", message: "You now have 10 more question tokens.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    presentViewController(alert, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "Not Enough Points", message: "You do not have enough points to trade in.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    presentViewController(alert, animated: true, completion: nil)
                }
            }else if row == 1{
                if Int((currentUser?.objectForKey("tokens"))! as! NSNumber) >= 50{
                    let alert = UIAlertController(title: "Max Tokens", message: "You already have over 50 tokens, save your points for some other cool stuff.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    presentViewController(alert, animated: true, completion: nil)
                }else if Int((currentUser?.objectForKey("points"))! as! NSNumber) >= 250{
                    currentUser?.incrementKey("tokens", byAmount: 20)
                    currentUser?.incrementKey("points", byAmount: -250)
                    currentUser?.saveInBackground()
                    do {
                        try currentUser?.fetchInBackgroundWithBlock(nil)
                    }catch{
                        //nothing
                    }
                    points = String(currentUser!.objectForKey("points")!)
                    let myPoints:UIBarButtonItem = UIBarButtonItem(title: self.points, style: .Plain, target: self, action: nil)
                    self.navigationItem.setRightBarButtonItem(myPoints, animated: true)
                    let alert = UIAlertController(title: "Tokens Obtained", message: "You now have 20 more question tokens.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    presentViewController(alert, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "Not Enough Points", message: "You do not have enough points to trade in.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    presentViewController(alert, animated: true, completion: nil)
                }
            }else{
                if Int((currentUser?.objectForKey("tokens"))! as! NSNumber) >= 50{
                    let alert = UIAlertController(title: "Max Tokens", message: "You already have over 50 tokens, save your points for some other cool stuff.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    presentViewController(alert, animated: true, completion: nil)
                }else if Int((currentUser?.objectForKey("points"))! as! NSNumber) >= 400{
                    currentUser?.incrementKey("tokens", byAmount: 50)
                    currentUser?.incrementKey("points", byAmount: -400)
                    currentUser?.saveInBackground()
                    do {
                        try currentUser?.fetchInBackgroundWithBlock(nil)
                    }catch{
                        //nothing
                    }
                    points = String(currentUser!.objectForKey("points")!)
                    let myPoints:UIBarButtonItem = UIBarButtonItem(title: self.points, style: .Plain, target: self, action: nil)
                    self.navigationItem.setRightBarButtonItem(myPoints, animated: true)
                    let alert = UIAlertController(title: "Tokens Obtained", message: "You now have 50 more question tokens.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    presentViewController(alert, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "Not Enough Points", message: "You do not have enough points to trade in.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    presentViewController(alert, animated: true, completion: nil)
                }
            }
        }else if indexPath.section == 1 {
            if row == 0{
                let twitterPost = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                twitterPost.setInitialText("Everyone go to the app store and download Hoot!")
                self.presentViewController(twitterPost, animated: true, completion: nil)
            }else if row == 1{
                let facebookPost = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                facebookPost.setInitialText("Everyone go to the app store and download Hoot!")
                self.presentViewController(facebookPost, animated: true, completion: nil)
            }else{
                //App Store
            }
        }else if indexPath.section == 2 {
            if row == 0{
                self.performSegueWithIdentifier("rulesSegue", sender: self)
            }else{
                self.performSegueWithIdentifier("contactUsSegue", sender: self)
            }
        }else {
            if row == 0{
                //My Questions
                self.performSegueWithIdentifier("myQuestionsSegue", sender: self)
            }else if row == 1{
                //My Class Questions
                self.performSegueWithIdentifier("myClassQuestionsSegue", sender: self)
            }else {
                //Log Out
                PFUser.logOut()
                self.performSegueWithIdentifier("logOutSegue", sender: self)
            }
        }
        
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.textLabel!.textColor = UIColor(red: 255.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
        header.alpha = 1.0 //make the header transparent
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
