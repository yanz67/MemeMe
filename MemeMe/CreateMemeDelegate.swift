//
//  ShareMemeDelegate.swift
//  MemeMe
//
//  Created by Yan Zverev on 7/6/16.
//  Copyright © 2016 Yan Zverev. All rights reserved.
//



protocol CreateMemeDelegate
{
    func memeDidCreate(memeModel: MemeModel)
    func memeCancelCreate()
}
