//
//  UserListTableCell.swift
//  NetworkAndCoreDataTask
//
//  Created by Anupam Gupta on 13/12/17.
//  Copyright © 2017 Anupam G. All rights reserved.
//

import UIKit

class UserListTableCell: UITableViewCell {

    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView?.clipsToBounds = true
        imageView?.layer.cornerRadius = 4;
        imageView?.layer.borderColor = UIColor.darkGray.cgColor
        imageView?.layer.borderWidth = 0.5
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
}
extension UIImageView{
    public func imageViewWithUrl (urlString : String?){
         unowned var weakSelf = self
        let imageurl = URL.init(string: urlString!)
        guard let imageURL = imageurl else {
            return
        }
        let session = URLSession.shared.dataTask(with: imageURL) { (data, response, er) in
            if er != nil{//it means some error
                DispatchQueue.main.async(execute: {
                    print("Some error occured")
                })
            }else{
                DispatchQueue.main.async(execute: {
                    weakSelf.image = nil
                    let img = UIImage.init(data: data!)
                    weakSelf.image = img
                })
            }
        }
        session.resume()
//        let session = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in -> Void
//
//        }
    }
}
