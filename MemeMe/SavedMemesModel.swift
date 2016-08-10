//
//  SavedMemesModel.swift
//  MemeMe
//
//  Created by Yan Zverev on 6/27/16.
//  Copyright © 2016 Yan Zverev. All rights reserved.
//

import UIKit
import Foundation

let memeUserDefaultObjectKey = "memeObjectsKey"

class SavedMemesModel: NSObject
{
    static let sharedInstance = SavedMemesModel() //Singleton pattern
    
    var savedMemes = [MemeModel]()
    
    override init() {
        super.init()
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let memesPropertyList = userDefaults.objectForKey(memeUserDefaultObjectKey) as? [NSDictionary]{
            for memePropertyList in memesPropertyList {
                savedMemes.append(MemeModel.memeFromPropertyList(memePropertyList))
                
            }
        }
        
    }
    
    func count() -> Int
    {
        return savedMemes.count
    }
    
    func getMemeForIndex(index: Int) -> MemeModel?
    {
        if index >= 0 && index < savedMemes.count {
            return savedMemes[index]
        }
        return nil
    }
    
//    func uniqueImageURL() -> String
//    {
//        let guid = NSProcessInfo.processInfo().globallyUniqueString
//        let documentsFolderPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
//        let uniqueImageName = "MememImage_ + \(guid)"
//        let uniqueImageURL = documentsFolderPath.stringByAppendingString("/\(uniqueImageName)")
//        print(uniqueImageURL)
//        return uniqueImageURL
//    }
    
    func addMemeToUserDefaults(meme: MemeModel)
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if var memesPropertyList = userDefaults.objectForKey(memeUserDefaultObjectKey) as? [NSDictionary]
        {
            memesPropertyList.append(meme.toPropertyList())
            userDefaults.setObject(memesPropertyList, forKey: memeUserDefaultObjectKey)
        } else {
            var tempMemesArray = [NSDictionary]()
            tempMemesArray.append(meme.toPropertyList())
            userDefaults.setObject(tempMemesArray, forKey: memeUserDefaultObjectKey)
        }
        userDefaults.synchronize()
    }
    
    
    func saveMeme(meme: MemeModel)
    {
        savedMemes.append(meme)
        addMemeToUserDefaults(meme)        
    }


}
