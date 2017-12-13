//
//  MyCustomClasses.swift
//  NetworkAndCoreDataTask
//
//  Created by Anupam G on 13/12/17.
//  Copyright © 2017 Anupam G. All rights reserved.
//

import UIKit

class MyCustomClasses: NSObject {

}
struct ServerResponseModel: Decodable {
    var status : Bool?
    var message : String?
    var data : UserDataModel?
}
struct UserDataModel: Decodable {
    var users : [UserModel]?
    var has_more : Bool?
}
struct UserModel: Decodable {
    var name : String?
    var image : String?
    var items : [String]?
}
