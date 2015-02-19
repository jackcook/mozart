//
//  Mozart.swift
//  MozartDemo
//
//  Created by Jack Cook on 2/18/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import UIKit

class Mozart {
    
    class func load(url: String) -> LoadingClass {
        let loadingClass = LoadingClass(url: url)
        return loadingClass
    }
}

class LoadingClass {
    
    var url: String!
    var completionBlock: (UIImage -> Void)!
    
    var imageView: UIImageView!
    var button: UIButton!
    var controlState: UIControlState!
    var controlStates: [UIControlState]!
    var holderType = ImageHolder.Unknown
    
    init(url: String) {
        self.url = url
        
        getImage() { (img) -> Void in
            if let cb = self.completionBlock {
                self.completionBlock(img)
            }
            
            switch self.holderType {
            case .ImageView:
                self.imageView.image = img
            case .ButtonWithoutControlState:
                self.button.setImage(img, forState: .Normal)
            case .ButtonWithControlState:
                self.button.setImage(img, forState: self.controlState)
            case .ButtonWithControlStates:
                for state in self.controlStates {
                    self.button.setImage(img, forState: state)
                }
            case .Unknown:
                break
            }
        }
    }
    
    func into(imageView: UIImageView) -> LoadingClass {
        self.imageView = imageView
        holderType = .ImageView
        
        return self
    }
    
    func into(button: UIButton) -> LoadingClass {
        self.button = button
        holderType = .ButtonWithoutControlState
        
        return self
    }
    
    func into(button: UIButton, forState state: UIControlState) -> LoadingClass {
        self.button = button
        controlState = state
        holderType = .ButtonWithControlState
        
        return self
    }
    
    func into(button: UIButton, forStates states: [UIControlState]) -> LoadingClass {
        self.button = button
        controlStates = states
        holderType = .ButtonWithControlStates
        
        return self
    }
    
    func completion(block: UIImage -> Void) {
        completionBlock = block
    }
    
    internal func getImage(block: UIImage -> Void) {
        let actualUrl = NSURL(string: url)!
        let request = NSURLRequest(URL: actualUrl)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            if error == nil {
                let image = UIImage(data: data)!
                block(image)
                if (self.completionBlock != nil) {
                    self.completionBlock(image)
                }
            } else {
                println("Error: \(error.localizedDescription)")
            }
        }
    }
}

enum ImageHolder {
    case ImageView, ButtonWithoutControlState, ButtonWithControlState, ButtonWithControlStates, Unknown
}
