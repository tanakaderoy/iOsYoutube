//
//  Video.swift
//  Youtube
//
//  Created by Tanaka Mazivanhanga on 7/3/19.
//  Copyright © 2019 Tanaka Mazivanhanga. All rights reserved.
//

import UIKit

struct Video: Decodable {
    
    let title: String?
    let number_of_views: Int?
    let thumbnail_image_name: String?
    let channel: Channel?
    let duration: Int?
    //    let uploadDate: NSDate?
    
}


