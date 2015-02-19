// Mozart.swift (v. 0.1)
//
// Copyright (c) 2015 Jack Cook
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
