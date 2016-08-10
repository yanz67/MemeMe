//
//  MemeModel.swift
//  MemeMe
//
//  Created by Yan Zverev on 6/27/16.
//  Copyright © 2016 Yan Zverev. All rights reserved.
//

import Foundation
import UIKit

struct MemeModel
{
    var topText = "TOP"
    var bottomText = "BOTTOM"
    var backgroundImage: UIImage?
    var memeImage: UIImage?
    
    static func memeFromPropertyList(propertyList: NSDictionary) -> MemeModel
    {
        var memeModel = MemeModel()
        
        memeModel.topText = propertyList["TopText"] as! String
        memeModel.bottomText = propertyList["BottomText"] as! String
        
        if let memeImage = propertyList["MemeImage"] as? NSData {
            memeModel.memeImage = UIImage(data: memeImage)
        }
        
        return memeModel
    }
    
    func toPropertyList() -> NSDictionary
    {
        var propertyList = [String:AnyObject]()
        propertyList["TopText"] = topText
        propertyList["BottomText"] = bottomText
        
        if memeImage != nil {
            let imageData = UIImagePNGRepresentation(memeImage!)
            propertyList["MemeImage"] = imageData
        }
        
        return propertyList
    }
    
}
