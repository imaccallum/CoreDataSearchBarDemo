//
//  AddContactViewController.swift
//  CoreDataSearchBarDemo
//
//  Created by Ian MacCallum on 12/7/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddContactViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
    var managedObjectContext: NSManagedObjectContext? {
        get {
            if let delegate = appDelegate {
                return delegate.managedObjectContext
            }
            return nil
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    func createContact() {
        
        var newContact: Contact = NSEntityDescription.insertNewObjectForEntityForName("Contact", inManagedObjectContext: managedObjectContext!) as Contact
        newContact.nameFirst = firstNameTextField.text
        newContact.nameLast = lastNameTextField.text
        
        managedObjectContext?.insertObject(newContact)
        managedObjectContext?.save(nil)
        }
    



    
    @IBAction func saveButtonPressed(sender: UIBarButtonItem) {
        createContact()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
