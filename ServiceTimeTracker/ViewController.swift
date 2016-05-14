//
//  ViewController.swift
//  ServiceTimeTracker
//
//  Created by Mark Long on 5/11/16.
//  Copyright © 2016 Mark Long. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate {

    @IBOutlet var timeLabel : UILabel!
    @IBOutlet var momentTimeLabel : UILabel!
    @IBOutlet var momentTable : MomentTableView!
    
    var timer = NSTimer()
    var lastStart = NSTimeInterval()
    var lastMoment = NSTimeInterval()
    var inSession = false
    var sessionId = "Session 1"
    var sessionNumber = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func start(sender: UIButton) {
        if !inSession {
            beginSession()
            startTimer()
        }
    }
    
    @IBAction func newMoment(sender: UIButton) {
        if inSession {
            stopTimer()
            endLastMoment()
            beginNewMoment()
            startTimer()
        }
    }
    
    @IBAction func stop(sender: UIButton) {
        if inSession {
            stopTimer()
            beginNewMoment()
            momentTable.reloadData()
            endSession()
        }
    }
    
    func update() {
        timeLabel.text = elapsedTime(fromInterval: lastStart)
        momentTimeLabel.text = elapsedTime(fromInterval: lastMoment)
    }
    
    func startTimer() {
        if !timer.valid {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    func beginSession() {
        inSession = true
        lastStart = NSDate.timeIntervalSinceReferenceDate()
        lastMoment = NSDate.timeIntervalSinceReferenceDate()
        self.databaseBeginSession()
    }
    
    func endSession() {
        inSession = false
        //databaseDeleteSessions()
        saveDatabase()
    }
    
    func endLastMoment() {
    }
    
    func beginNewMoment() {
        testDatabase()
        momentTable.reloadData()
        lastMoment = NSDate.timeIntervalSinceReferenceDate()
    }
    
    func setSessionId() {
        if let dbContext = getDatabaseContext() {
            do {
                let sessionFetch = NSFetchRequest(entityName: "Session")
                
                let results = try dbContext.executeFetchRequest(sessionFetch)
                sessionNumber = results.count
                sessionId = "Session \(sessionNumber)"
                askForSessionName()
            } catch {
                print("Error accessing database: \(error)")
            }
        }
    }
    
    func databaseBeginSession() {
        if let dbContext = getDatabaseContext() {
            if let session1 = Session(insertIntoManagedObjectContext: dbContext) {
                setSessionId()
                session1.id = NSNumber(integer: sessionNumber)
                session1.date = NSDate(timeIntervalSinceReferenceDate: lastStart)
            }
        }
    }
    
    //MARK: momentTableView Methods
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(12.0)
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.font = UIFont.systemFontOfSize(12)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let dbContext = getDatabaseContext() {
            do {
                let sessionFetch = NSFetchRequest(entityName: "Session")
                let sortDescripter = NSSortDescriptor(key: "id", ascending: false)
                sessionFetch.sortDescriptors = [sortDescripter]
                
                if let modelSessions = try dbContext.executeFetchRequest(sessionFetch) as? [Session] {
                    if var momentsArray = modelSessions[indexPath.section].moments?.array as? [Moment] {
                        momentsArray = momentsArray.reverse()
                        let moment = momentsArray[indexPath.row]
                        askForMomentName("initial", moment: moment)
                    }
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func askForMomentName(defaultName: String, moment: Moment) {
        
        let alert = UIAlertController(title: "Moment", message: "Enter Name", preferredStyle: .Alert)
        let changeNameAction = UIAlertAction(title: "Ok", style: .Destructive) {
            action in
            moment.name = alert.textFields!.first!.text!
            self.momentTable.reloadData()
        }
        
        alert.addAction(changeNameAction)
        alert.addTextFieldWithConfigurationHandler() {
            textField in
            textField.text = self.sessionId
        }
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: -- change Session Name
    
    func askForSessionName() {
        let alert = UIAlertController(title: "Session", message: "Enter Name", preferredStyle: .Alert)
        let changeNameAction = UIAlertAction(title: "Ok", style: .Destructive) {
            action in
            self.sessionId = alert.textFields!.first!.text!
        }
        
        alert.addAction(changeNameAction)
        alert.addTextFieldWithConfigurationHandler() {
            textField in
            textField.text = self.sessionId
        }
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func databaseDeleteSessions() {
        if let dbContext = getDatabaseContext() {
            do {
                let sessionFetch = NSFetchRequest(entityName: "Session")
                
                let results = try dbContext.executeFetchRequest(sessionFetch)
                for result in results {
                    dbContext.deleteObject(result as! NSManagedObject)
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func getDatabaseContext() -> NSManagedObjectContext? {
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            return delegate.managedObjectContext
        } else {
            return nil
        }
    }
    
    func testDatabase() {
        if let dbContext = getDatabaseContext() {
            
            do {
                let sessionFetch = NSFetchRequest(entityName: "Session")
                sessionFetch.predicate = NSPredicate(format: "id == %i", sessionNumber)
                
                let results = try dbContext.executeFetchRequest(sessionFetch)
                
                if let session = results.first as? Session {
                    session.name = sessionId
                    
                    if let ment = Moment(insertIntoManagedObjectContext: dbContext) {
                        ment.name = "initial"
                        ment.start_time = NSDate(timeIntervalSinceReferenceDate: lastMoment)
                        ment.end_time = NSDate()
                        session.addMoment(ment)
                    }
                    
                    let lastMent = session.moments?.lastObject as! Moment
                    let lastInterval = lastMent.end_time!.timeIntervalSinceDate(session.date!)
                    let elapsedDate = NSDate(timeIntervalSinceReferenceDate: lastInterval)
                    print("\(session.name!): \(dateToString(elapsedDate, elapsed: true))")
                    
                    for elem in session.moments! {
                        let ment = elem as! Moment
                        let start = ment.start_time!
                        let end = ment.end_time!
                        let elapsed = dateToString(dateToElapsedDate(start, end: end), elapsed: true)
                        print("\(ment.name!): \(dateToString(start)) to \(dateToString(end)) Elapsed:\(elapsed)")
                    }
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func saveDatabase() {
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            delegate.saveContext()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

