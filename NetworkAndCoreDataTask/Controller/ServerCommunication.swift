//
//  ServerCommunication.swift
//  NetworkAndCoreDataTask
//
//  Created by Anupam G on 12/12/17.
//  Copyright © 2017 Anupam G. All rights reserved.
//

import UIKit

class ServerCommunication: NSObject {
    static let sharedInstance = ServerCommunication()
    func getUserRequestFromUrl (getUrlString : String, postUrlString: String?, success : @escaping (Data)->Void , failure :@escaping (Data)->Void){
        let url = URL.init(string: getUrlString)
        guard let webURL = url else { return }
        let urlRequest = NSMutableURLRequest(url: webURL, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30.0)
//        guard let postString = postUrlString else {return}
        if (postUrlString != nil){
            let postbody = postUrlString?.data(using: String.Encoding.utf8, allowLossyConversion: true)
            let contentType = "application/x-www-form-urlencoded; charset=utf-8"
            urlRequest.addValue(contentType, forHTTPHeaderField: "Content-Type")
            let contentLength = "\(postbody?.count ?? 1)"
            urlRequest.addValue(contentLength, forHTTPHeaderField: "Content-Length")
            urlRequest.httpBody  = postbody
            urlRequest.httpMethod = "POST"
        }else{
            urlRequest.httpMethod = "GET"
        }
        requestWithHttpRequest(urlRequest: urlRequest as URLRequest, success: success, failure: failure)
        
    }
    func getImageDateFromUrl (urlString : String?, success : @escaping (Data)->Void, failure : @escaping (Data)->Void){
        print("Image Url = \(urlString)")
        guard let url = urlString else {
            return
        }
        guard let imageURL = URL.init(string: url) else {
            return
        }
        
        let session = URLSession.shared.dataTask(with: imageURL) { (data, response, er) in
            guard let mydata = data else {
                return
            }
            if er != nil{
                DispatchQueue.main.async(execute: {
                   
                    success(mydata)
                })
            }else{
                failure(mydata)
            }
        }
        session.resume()
    }
    
    private  func requestWithHttpRequest (urlRequest :URLRequest, success : @escaping (Data)->Void, failure : @escaping (Data)->Void){
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        guard let myReachable = appDelegate.reachability  else {
            return
        }
        // check if connection have some value then only
        if myReachable.connection != .none {
            print("Reachable")
            let session = URLSession.shared
            let task = session.dataTask(with: urlRequest) { (data, urlResponse, error) ->Void in
                if error != nil{
                    let custom = Data()
                    DispatchQueue.main.async(execute: {
                        failure(custom)
                    })
                }else{
                    DispatchQueue.main.async(execute: {
                        success(data!)
                    })
                }
            }
            task.resume()
        }else{
            let custom = Data()
            failure(custom)
            print("No Reachable")
        }
        }
    
}

