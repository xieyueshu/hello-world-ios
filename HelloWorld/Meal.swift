//
//  Meal.swift
//  HelloWorld
//
//  Created by yueshu on 2019/6/14.
//  Copyright © 2019年 yueshu. All rights reserved.
//

import UIKit

class Meal {
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var rating:Int
    
    //MARK: Initialization
    
    init?(name: String, photo: UIImage?, rating: Int) {
        //Initialization shold fail if there is no name or if the rating is negative.
//        if name.isEmpty || rating < 0 {
//            return nil
//        }
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        //The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        // Initialize stored properties
        self.name = name
        self.photo = photo
        self.rating = rating
        
        print("test meal *************************")
    }
}
