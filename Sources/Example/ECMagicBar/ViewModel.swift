//
//  ViewModel.swift
//  ECMagicBar_Example
//
//  Created by Eduard Calero on 28/12/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class ViewModel {
    
    struct Message {
        let message: String?
        let image: UIImage?
        let video: URL?
    }
    
    var conversation = [Message]()
    
    func sendMessage(_ message: String, completion: ((Result<Any, Error>)->())? = nil ) {
        let newMessge =  Message(message: message, image: nil, video: nil)
        conversation.append(newMessge)
        completion?(.success(message))
        
    }
    
    func sendImage(_ image: UIImage, completion: ((Result<Any, Error>)->())? = nil) {
        let newMessge =  Message(message: nil, image: image, video: nil)
        conversation.append(newMessge)
        completion?(.success(image))
    }
    
    func sendVideo(_ videoURL: URL, completion: ((Result<Any, Error>)->())? = nil){
        let newMessge =  Message(message: nil, image: nil, video: videoURL)
        conversation.append(newMessge)
        completion?(.success(videoURL))
    }
    
    
}
