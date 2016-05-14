//
//  MomentTableView.swift
//  ServiceTimeTracker
//
//  Created by Mark Long on 5/12/16.
//  Copyright © 2016 Mark Long. All rights reserved.
//

import UIKit
import CoreData

class MomentTableView: UITableView, UITableViewDelegate, UITableViewDataSource {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var modelSessions = [Session]()
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        getSessions()
        self.dataSource = self
    }
    
    override func reloadData() {
        getSessions()
        super.reloadData()
    }
    
    func getDatabaseContext() -> NSManagedObjectContext? {
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            return delegate.managedObjectContext
        } else {
            return nil
        }
    }
    
    func getSessions() {
        do {
            if let dbContext = getDatabaseContext() {
                let sessionFetch = NSFetchRequest(entityName: "Session")
                let sortDescripter = NSSortDescriptor(key: "id", ascending: false)
                sessionFetch.sortDescriptors = [sortDescripter]
                if let results = try dbContext.executeFetchRequest(sessionFetch) as? [Session] {
                    modelSessions = results
                }
            }
        } catch {
            print ("Error: \(error)")
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return modelSessions.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let session = modelSessions[section]
        return "\(session.name ?? "nil") -- \(elapsedDateToString(session.getTotalElapsedTime()))"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelSessions[section].moments!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("momentCell", forIndexPath: indexPath)
        let session = modelSessions[indexPath.section]
        if var moments = session.moments?.array as? [Moment] {
            moments = moments.reverse()
            if moments.count > indexPath.row {
                let moment = moments[indexPath.row]
                let startElapsedDate = dateToElapsedDate(session.date!, end: moment.start_time!)
                let elapsedDate = dateToElapsedDate(moment.start_time!, end: moment.end_time!)
                cell.textLabel!.text = elapsedDateToString(startElapsedDate)
                cell.detailTextLabel!.text = elapsedDateToString(elapsedDate)
            }
        }
        return cell
    }
}
