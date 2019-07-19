//
//  APIHelper.swift
//  Created by Maulik Pandya on 19/07/19.
//  Copyright © 2019 Maulik Pandya. All rights reserved.
//

import Foundation
import Alamofire

class APIHelper: NSObject {
    
    typealias SuccessHandler = (Data) -> Void
    typealias FailureHandler = (Error) -> Void
    
    // MARK: - Helper Methods
    
    class func getWebServiceCall(_ strURL : String, isShowLoader : Bool, success : @escaping SuccessHandler, failure : @escaping FailureHandler)
    {
        
        if isShowLoader == true {
            AppDelegate.getDelegate().showLoader()
        }
        
        let header : HTTPHeaders = ["with" : "songs,members"]
        
        Alamofire.request(strURL, headers: header).responseJSON { (resObj) -> Void in
            
            print(resObj)
            
            if resObj.result.isSuccess {
                
                let resJsonData = resObj.data
                
                if isShowLoader == true {
                    AppDelegate.getDelegate().dismissLoader()
                }
                
                success(resJsonData!)
            }
            if resObj.result.isFailure {
                let error : Error = resObj.result.error!
                
                if isShowLoader == true {
                    AppDelegate.getDelegate().dismissLoader()
                }
                debugPrint(error)
                failure(error)
            }
        }
    }
    
    class func getWebServiceCall(_ strURL : String, params : [String : AnyObject]?, isShowLoader : Bool, success : @escaping SuccessHandler,  failure :@escaping FailureHandler){
        
        
        if isShowLoader == true {
            AppDelegate.getDelegate().showLoader()
        }
        
        
        Alamofire.request(strURL, method: .get, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(resObj) -> Void in
            
            print(resObj)
            
            if resObj.result.isSuccess {
                let resJson = resObj.data
                
                if isShowLoader == true {
                    AppDelegate.getDelegate().dismissLoader()
                }
                
                success(resJson!)
            }
            if resObj.result.isFailure {
                let error : Error = resObj.result.error!
                
                if isShowLoader == true {
                    AppDelegate.getDelegate().dismissLoader()
                }
                
                failure(error)
            }
            
        })
        
    }
    
    
    
    class func postWebServiceCall(_ strURL : String, params : [String : AnyObject]?, isShowLoader : Bool, success : @escaping SuccessHandler, failure :@escaping FailureHandler)
    {
        
        if isShowLoader == true
        {
            AppDelegate.getDelegate().showLoader()
        }
        
        Alamofire.request(strURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(resObj) -> Void in
            
            print(resObj)
            
            if resObj.result.isSuccess
            {
                let resJson = resObj.data
                
                if isShowLoader == true
                {
                    AppDelegate.getDelegate().dismissLoader()
                }
                
                success(resJson!)
            }
            
            if resObj.result.isFailure
            {
                let error : Error = resObj.result.error!
                
                if isShowLoader == true
                {
                    AppDelegate.getDelegate().dismissLoader()
                }
                
                failure(error)
            }
        })
        
    }
    
    
    class func postWebServiceCallWithImage(_ strURL : String, image : UIImage!, strImageParam : String, params : [String : AnyObject]?, isShowLoader : Bool, success : @escaping SuccessHandler, failure : @escaping FailureHandler)
    {
        
        if isShowLoader == true
        {
            AppDelegate.getDelegate().showLoader()
        }
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                if let imageData = image.jpegData(compressionQuality: 0.5) {
                    multipartFormData.append(imageData, withName: "Image.jpg")
                }
                
                for (key, value) in params! {
                    
                    let data = value as! String
                    
                    multipartFormData.append(data.data(using: String.Encoding.utf8)!, withName: key)
                    print(multipartFormData)
                }
        },
            to: strURL,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    if isShowLoader == true
                    {
                        AppDelegate.getDelegate().dismissLoader()
                    }
                    
                    let error : NSError = encodingError as NSError
                    failure(error)
                }
                
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { (response) -> Void in
                        
                        if response.result.isSuccess
                        {
                            let resJson = response.data
                            
                            if isShowLoader == true
                            {
                                AppDelegate.getDelegate().dismissLoader()
                            }
                            
                            success(resJson!)
                        }
                        
                        if response.result.isFailure
                        {
                            let error : Error = response.result.error! as Error
                            
                            if isShowLoader == true
                            {
                                AppDelegate.getDelegate().dismissLoader()
                            }
                            
                            failure(error)
                        }
                        
                    }
                case .failure(let encodingError):
                    if isShowLoader == true
                    {
                        AppDelegate.getDelegate().dismissLoader()
                    }
                    
                    let error : NSError = encodingError as NSError
                    failure(error)
                }
        }
        )
    }
}



