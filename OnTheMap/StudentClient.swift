//
//  StudentClient.swift
//  OnTheMap
//
//  Created by Wassim Seifeddine on 13/4/16.
//  Copyright (c) 2016 Wassim Seifeddine. All rights reserved.
//

import Foundation
import MapKit

class StudentClient : NSObject{

    /* Shared session */
    var session: NSURLSession
    
    var studentLocations: [StudentLocation] = model.studentLocations
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    // MARK: - Get and Post Student Locations
    
    func getStudentLocations(completionHandler: (success: Bool, errorString: String?) -> Void) {
        var temp: [StudentLocation] = []
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit=100&order=-updatedAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                print("Could not complete the request \(error)")
                completionHandler(success: false, errorString: error!.description)
            } else if error == nil {
                StudentClient.parseJSONWithCompletionHandler(data!) { (result, error) -> Void in
                    if let results = result["results"] as? [AnyObject] {
                        for result in results {
                            var student = StudentLocation(dictionary: result as! NSDictionary)
                            temp.append(student)
                        }
                         model.studentLocations = temp
                        completionHandler(success: true, errorString: nil)
                    }else {
                        completionHandler(success: false, errorString: "Problem in result data.")
                    }
                }
            }else {
                print("Could not reach server here")
            }
        }
        task.resume()
      }

    func postStudentLocation(mapString: String, location: CLLocation, mediaURL: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
            var tempStudentLocations: [StudentLocation] = []
            let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
            request.HTTPMethod = "POST"
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
            request.HTTPBody = "{\"uniqueKey\": \"324586\", \"firstName\": \"\(UdacityClient.sharedInstance().user.firstName!)\", \"lastName\": \"\(UdacityClient.sharedInstance().user.lastName!)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\":\(location.coordinate.latitude), \"longitude\": \(location.coordinate.longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) { data, response, error in
                if error != nil { // Handle error...
                    completionHandler(success: false, errorString: error!.description)
                } else {
                    print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                    Helper.parseJSONWithCompletionHandler(data!) { (result, error) -> Void in
                        print(result)
                    }
                    completionHandler(success: true, errorString: nil)
                }
            }
            task.resume()
    }


    /* Helper: Given raw JSON, return a usable Foundation object */
     class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsingError: NSError? = nil
        
        let parsedResult: AnyObject?
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
        } catch let error as NSError {
            parsingError = error
            parsedResult = nil
        }
        
        if let error = parsingError {
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }
    


    // MARK: - Shared Instance
   class func sharedInstance() -> StudentClient {
    
    struct Singleton {
        static var sharedInstance = StudentClient()
    }
    
    return Singleton.sharedInstance
}

}
