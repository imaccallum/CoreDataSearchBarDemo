//
//  FetchedResultsController.swift
//  CoreDataSearchBarDemo
//
//  Created by Ian MacCallum on 12/7/14.
//  Copyright (c) 2014 MacCDevTeam. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ContactsViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
    
    var managedObjectContext: NSManagedObjectContext? {
        get {
            if let delegate = appDelegate {
                return delegate.managedObjectContext
            }
            return nil
        }
    }
    
    var fetchedResultsController: NSFetchedResultsController?
    var searchResultsController: NSFetchedResultsController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchDisplayController?.searchResultsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CellID")
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: allContactsFetchRequest(nil), managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        fetchedResultsController?.performFetch(nil)
    }
    

    
    //MARK: UITableView Data Source and Delegate Functions
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsControllerForTableView(tableView)?.sections?.count ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchedResultsControllerForTableView(tableView)?.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as UITableViewCell

        if let cellContact = fetchedResultsControllerForTableView(tableView)?.objectAtIndexPath(indexPath) as? Contact {
            cell.textLabel?.text = "\(cellContact.nameLast), \(cellContact.nameFirst)"
        }
      
        
        return cell
    }
    
    //MARK: NSFetchedResultsController Delegate Functions
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        
        let tableView = controller == fetchedResultsController ? self.tableView : searchDisplayController?.searchResultsTableView
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        let tableView = controller == fetchedResultsController ? self.tableView : searchDisplayController?.searchResultsTableView

        switch type {
        case NSFetchedResultsChangeType.Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: UITableViewRowAnimation.Fade)
            break
        case NSFetchedResultsChangeType.Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: UITableViewRowAnimation.Fade)
            break
        case NSFetchedResultsChangeType.Move:
            break
        case NSFetchedResultsChangeType.Update:
            break
        default:
            break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        let tableView = controller == fetchedResultsController ? self.tableView : searchDisplayController?.searchResultsTableView

        switch type {
        case NSFetchedResultsChangeType.Insert:
            tableView.insertRowsAtIndexPaths(NSArray(object: newIndexPath!), withRowAnimation: UITableViewRowAnimation.Fade)
            break
        case NSFetchedResultsChangeType.Delete:
            tableView.deleteRowsAtIndexPaths(NSArray(object: indexPath!), withRowAnimation: UITableViewRowAnimation.Fade)
            break
        case NSFetchedResultsChangeType.Move:
            tableView.deleteRowsAtIndexPaths(NSArray(object: indexPath!), withRowAnimation: UITableViewRowAnimation.Fade)
            tableView.insertRowsAtIndexPaths(NSArray(object: newIndexPath!), withRowAnimation: UITableViewRowAnimation.Fade)
            break
        case NSFetchedResultsChangeType.Update:
            tableView.cellForRowAtIndexPath(indexPath!)
            break
        default:
            break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        let tableView = controller == fetchedResultsController ? self.tableView : searchDisplayController?.searchResultsTableView
        tableView.endUpdates()
    }
    
    //MARK: NSFetchRequest
    func fetchedResultsControllerForTableView(tableView: UITableView) -> NSFetchedResultsController? {
        return tableView == searchDisplayController?.searchResultsTableView ? searchResultsController? : fetchedResultsController?
    }
    
    func allContactsFetchRequest(predicate: NSPredicate?) -> NSFetchRequest {
        
        var fetchRequest = NSFetchRequest(entityName: "Contact")
        let sortDescriptor = NSSortDescriptor(key: "nameLast", ascending: true)
 
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 20
        
        return fetchRequest
    }
}

extension ContactsViewController: UISearchBarDelegate, UISearchDisplayDelegate {
    
    func searchDisplayController(controller: UISearchDisplayController, willUnloadSearchResultsTableView tableView: UITableView) {
        searchResultsController?.delegate = nil
        searchResultsController = nil
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        
        let firstNamePredicate = NSPredicate(format: "nameFirst CONTAINS[cd] %@", searchString.lowercaseString)
        let lastNamePredicate = NSPredicate(format: "nameLast CONTAINS[cd] %@", searchString.lowercaseString)
        let predicate = NSCompoundPredicate.orPredicateWithSubpredicates([firstNamePredicate!, lastNamePredicate!])
        
        searchResultsController = NSFetchedResultsController(fetchRequest: allContactsFetchRequest(predicate), managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        searchResultsController?.performFetch(nil)

        return true
    }
}
