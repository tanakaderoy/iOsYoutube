//
//  APIService.swift
//  Youtube
//
//  Created by Tanaka Mazivanhanga on 7/5/19.
//  Copyright © 2019 Tanaka Mazivanhanga. All rights reserved.
//

import UIKit

class ApiService: NSObject {
    
    let baseUrl = "https://s3-us-west-2.amazonaws.com/youtubeassets"

    static let sharedInstance = ApiService()
    
    func fetchVideos(completion: @escaping ([Video]) -> ()){
        let url = "\(baseUrl)/home.json"
        fetchWithUrl(urlString: url, completion: completion)
    }
    func fetchTrendingFeed(completion: @escaping ([Video]) -> ()){
       let url =  "\(baseUrl)/trending.json"
        fetchWithUrl(urlString: url, completion: completion)
    
}

    func fetchSubscriptionFeed(completion: @escaping ([Video]) -> ()){
        let url = "\(baseUrl)/subscriptions.json"
        fetchWithUrl(urlString: url, completion: completion)
    }
    
    func fetchWithUrl(urlString: String, completion: @escaping ([Video]) -> ()) {
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
                guard let data = data else {return}
                do {
                    let json = try JSONDecoder().decode([Video].self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(json)
                    }
                    
                
                
            } catch let jsonError{
                print(jsonError)
            }
            
            //            let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            // print(str)
            
            }.resume()
    }
    
}


//let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
////                print(json)
//var videos = [Video]()
//for dict in json as! [[String: AnyObject]] {
//    let video = Video()
//    video.title = (dict["title"]) as? String
//    video.thumbnailImageName = dict["thumbnail_image_name"] as? String
//    video.numberOfViews = dict["number_of_views"] as? NSNumber
//
//    let channelDict = dict["channel"] as! [String: AnyObject]
//
//    let channel = Channel()
//
//    channel.name = channelDict["name"] as? String
//    channel.profileImageName = channelDict["profile_image_name"] as? String
//
//    video.channel = channel
//    videos.append(video)
//
//}
//DispatchQueue.main.async {
//    completion(videos)
//}
