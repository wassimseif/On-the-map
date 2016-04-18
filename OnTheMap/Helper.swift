//
//  Helper.swift
//  OnTheMap
//
//  Created by Wassim Seifeddine on 13/4/16.
//  Copyright (c) 2016 Wassim Seifeddine. All rights reserved.
//

import Foundation
import UIKit

class Helper: NSObject {
    
    // Parse JSON Data
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        var parsingError: NSError? = nil
        let parsedResult: AnyObject?
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
        } catch let error as NSError {
            parsingError = error
            parsedResult = nil
        }
        if parsingError != nil {
            completionHandler(result: nil, error: parsingError)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }
    // Display Alert View
    class func displayAlert(inViewController viewController: UIViewController, withTitle title: String, message: String, completionHandler: ((UIAlertAction!) -> Void)) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: completionHandler))
        viewController.presentViewController(alert, animated: true, completion: nil)
        return alert
    }
    
    // Display Activity indicator
    class func displayActivityIndicator(view : UIView, withActivityIndicator activityIndicator: UIActivityIndicatorView, andAnimate enable: Bool) {
        if enable {
            view.alpha = 0.6
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        } else {
            view.alpha = 1
            activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
        }
    }
    
    //Check network connectivity
    class func isConnectedToNetwork()->Bool{
        
        var Status:Bool = false
        let url = NSURL(string: "http://google.com/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: NSURLResponse?
        
        var data = (try? NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)) as NSData?
        
        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
                Status = true
            }
        }
        
        return Status
    }
    
}

