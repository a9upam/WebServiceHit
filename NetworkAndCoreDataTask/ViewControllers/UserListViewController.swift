//
//  UserListViewController.swift
//  NetworkAndCoreDataTask
//
//  Created by Anupam G on 12/12/17.
//  Copyright © 2017 Anupam G. All rights reserved.
//

import UIKit
let urlString = "http://sd2-hiring.herokuapp.com/api/users?offset=10&limit=10"


class UserListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var cache:NSCache<AnyObject, AnyObject>!
    var myServerResponse : ServerResponseModel!
    var coreDataUserArray : [User]?
    let identifier = "UserListTableCell"
    @IBOutlet weak var userTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        cache = NSCache()
        userTableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)

        unowned let selfObject = self
        ServerCommunication.sharedInstance.getUserRequestFromUrl(getUrlString: urlString, postUrlString: nil, success: { (data) in
            selfObject.getServerResponseOnSuccess(successData: data)
        }) { (failureData) in
            selfObject.getServerResponseOnFailure(failureData: failureData)
        }
        // Do any additional setup after loading the view.
    }
    private func getServerResponseOnSuccess(successData : Data){
        let str = String.init(data: successData, encoding: String.Encoding.utf8)
        print("ServerResponse = \(str!)")
        do {
               myServerResponse =  try JSONDecoder().decode(ServerResponseModel.self, from: successData)
        } catch let er {
            print(er)
        }
        saveServerResponseInCoreData()
    }
    func saveServerResponseInCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        for user in (myServerResponse.data?.users)! {
            let userContext = User(context: context)
            userContext.name = user.name
            userContext.image = user.image;
            userContext.items = user.items! as NSObject
            appDelegate.saveContext()
        }
        grabData()
    
    }
    func grabData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        do {
               coreDataUserArray =  try context.fetch(User.fetchRequest())
        } catch let error {
            print(error)
            print("Unuable to fetch")
        }
        userTableView.reloadData()
    }
    private func getServerResponseOnFailure(failureData : Data){
        grabData()
        userTableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataUserArray?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var userModel = User()
        userModel = coreDataUserArray![indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! UserListTableCell
        cell.nameLabel.text = userModel.name
        cell.imageView?.imageViewWithUrl(urlString: userModel.image)
        
//        if (self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil){
//            // 2
//            // Use cache
//            print("Cached image used, no need to download it")
//            cell.imageView?.image = self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
//        }else{
//
//        ServerCommunication.sharedInstance.getImageDateFromUrl(urlString: userModel.image, success: { (data) in
//            if let updateCell = tableView.cellForRow(at: indexPath) {
//                let img:UIImage! = UIImage(data: data)
//                DispatchQueue.main.async(execute: {
//                                  updateCell.imageView?.image = img
//                })
//
//                self.cache.setObject(img, forKey: (indexPath as NSIndexPath).row as AnyObject)
//            }
//
//        }) { (failureData) in
//            //
//        }
//        }

       
        return cell
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var userModel = User()
        userModel = coreDataUserArray![indexPath.row]
    }
}
