//
//  AskQuestionViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/2/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class AskQuestionViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate  {
    
    var askQuestionCancelBtn:UIBarButtonItem = UIBarButtonItem()
    var askQuestionAskBtn:UIBarButtonItem = UIBarButtonItem()
    
    //MARK: Picture
    @IBOutlet var askQuestionPicPreview: UIImageView!
    
    //MARK: Add Picture
    @IBAction func askQuestionAddPicBtn(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            
            imagePicker.sourceType = .Camera
            if (UIImagePickerController.isCameraDeviceAvailable(.Rear)) { imagePicker.cameraDevice = .Rear
            }else{
                imagePicker.cameraDevice = .Front
            }
            
        }else{
            imagePicker.sourceType = .PhotoLibrary
        }
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!){
        askQuestionPicPreview.image = image; self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Text Felds
    @IBOutlet var askQuestionCourseTF: UITextField!
    
    //MARK: Text Views
    @IBOutlet var askQuestionAskQuestionTV: UITextView!
    
    
    //MARK: Labels
    @IBOutlet var askQuestionCountLabel: UILabel!
    @IBOutlet var askQuestionCourseCountLabel: UILabel!
    
    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        //Circle Edges on Pic
        askQuestionPicPreview.layer.cornerRadius = 8.0
        askQuestionPicPreview.clipsToBounds = true
        
        //Keyboard up at start
        askQuestionCourseTF.becomeFirstResponder()
        
        //Live Count Delegate
        self.askQuestionCountLabel.text = "200"
        self.askQuestionAskQuestionTV.delegate = self
        self.askQuestionCourseCountLabel.text = "20"
        self.askQuestionCourseTF.delegate = self
        
        askQuestionAskQuestionTV.textInputView.needsUpdateConstraints()
        askQuestionAskQuestionTV.textInputView.sizeToFit()
        
        //MARK: Nav Bar Customize
        askQuestionCancelBtn = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "askQuestionCancel")
        askQuestionAskBtn = UIBarButtonItem(title: "Ask", style: .Plain, target: self, action: "askQuestionAskQuestion")
        self.navigationItem.setRightBarButtonItem(askQuestionAskBtn, animated: true)
        self.navigationItem.setLeftBarButtonItem(askQuestionCancelBtn, animated: true)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(14.0)], forState: UIControlState.Normal)
        askQuestionAskBtn.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(14.0)], forState: UIControlState.Normal)
        askQuestionAskBtn.tintColor = UIColor.orangeColor()
        self.title = "Ask Question"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        //Ask Button Activation
        askQuestionAskBtn.enabled = true
        
        /*tart TV at Top Left
        askQuestionAskQuestionTV.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.New, context: nil)*/
    }
    //DID RECIEVE MEMORY WARNING
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
    }
    //Go Back Function
    func askQuestionCancel() {
        //askQuestionAskQuestionTV.removeObserver(self, forKeyPath: "contentSize")
        navigationController?.popViewControllerAnimated(true)
    }
    
    //Ask Function Question
    func askQuestionAskQuestion() {
        let currentUser = PFUser.currentUser()
        let question = PFObject(className: "Question")
        question["course"] = askQuestionCourseTF.text
        question["question"] = askQuestionAskQuestionTV.text
        question["user"] = currentUser!.username
        question["solved"] = false
        question["school"] = currentUser!.objectForKey("school")
        question["subject"] = currentUser!.objectForKey("subject")
        question["reportNumber"] = 0
        question["reported"] = false
        question["answerCount"] = 0
        question["hasPic"] = true
        let randomCode = randomNumber()
        question["pushCode"] = randomCode
        //PIC
        if askQuestionPicPreview.image != nil {
            question["hasPic"] = true
            let imageData = UIImageJPEGRepresentation(self.askQuestionPicPreview.image!,0.5)
            let imageFile = PFFile(name:"image.jpeg", data:imageData!)
            question.setObject(imageFile!, forKey: "picture")
            let image: PFFile = imageFile!
            let askQuestionWithPic = AskQuestionWithPic(course: askQuestionCourseTF.text!, text: askQuestionAskQuestionTV.text!, img: image)
            do {
                try askQuestionWithPic.askQuestionAlert()
                //MARK: Save Question
                question.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    if error == nil {
                        // Success, no creating error
                        currentUser!.incrementKey("points", byAmount: 1)
                        currentUser!.incrementKey("tokens", byAmount: -1)
                        currentUser!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                            if error == nil {
                                //Points Updated
                            } else {
                                //Not Saved
                            }
                        }
                        let currentInstallation = PFInstallation.currentInstallation()
                        currentInstallation.addUniqueObject(randomCode, forKey: "channels")
                        currentInstallation.saveInBackground()
                        self.performSegueWithIdentifier("askQuestionAskedSegue", sender: self)
                    } else {
                        //Not Saved
                    }
                }
                // Error Caught Alert Settings
            } catch let message as ErrorType {
                let alert = UIAlertController(title: "Uh-Oh!", message: "\(message)", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                presentViewController(alert, animated: true, completion: nil)
            }
        }else{
            question["hasPic"] = false
            let askQuestion = AskQuestion(course: askQuestionCourseTF.text!, text: askQuestionAskQuestionTV.text!)
            do {
                try askQuestion.askQuestionAlert()
                //MARK: Save Question
                question.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    if error == nil {
                        // Success, no creating error
                        currentUser!.incrementKey("points", byAmount: 5)
                        currentUser!.incrementKey("tokens", byAmount: -1)
                        currentUser!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                            if error == nil {
                                //Prints Updated
                            } else {
                                //Not Saved
                            }
                        }
                        let currentInstallation = PFInstallation.currentInstallation()
                        currentInstallation.addUniqueObject(randomCode, forKey: "channels")
                        currentInstallation.saveInBackground()
                        self.performSegueWithIdentifier("askQuestionAskedSegue", sender: self)
                    } else {
                        print("Error")
                    }
                }
                // Error Caught Alert Settings
            } catch let message as ErrorType {
                let alert = UIAlertController(title: "Uh-Oh!", message: "\(message)", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                presentViewController(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    //Live Count Text Field
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        //Ask Enabled
        //Count Function
            let newLength = (askQuestionCourseTF.text?.characters.count)! + string.characters.count - range.length
            if(newLength <= 20){
                self.askQuestionCourseCountLabel.text = "\(20 - newLength)"
                return true
            }else{
                return false
            }
    }
    
    //Live Count Text View
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText string: String) -> Bool {
        let newLength = (askQuestionAskQuestionTV.text?.characters.count)! + string.characters.count - range.length
        if(newLength <= 200){
            askQuestionCountLabel.text = "\(200 - newLength)"
            return true
        }else{
            return false
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if askQuestionAskQuestionTV.text == "What are you having trouble with?"
        {
            askQuestionAskQuestionTV.text = ""
            askQuestionAskQuestionTV.textColor = UIColor.blackColor()
        }
    }
    
    func randomNumber() -> String{
        let alphabet =  "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" as NSString
        var i = 10
        var randomString = "C"
        while (i > 0){
            let num = arc4random_uniform(10)
            let alphanum = Int(arc4random_uniform(52))
            let letter = alphabet.substringWithRange(NSRange(location: alphanum, length: 1))
            randomString = randomString + letter
            randomString = randomString + String(num)
            i = i - 1
        }
        return randomString
    }

}
