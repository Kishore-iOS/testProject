//
//  APIDownload.swift
//  knila project
//
//  Created by Fuzionest on 08/07/21.
//
import UIKit
import Alamofire
import AlamofireImage


let APPWindow = UIApplication.shared.keyWindow?.rootViewController
let imageCache = AutoPurgingImageCache(memoryCapacity: 111_111_111, preferredMemoryUsageAfterPurge: 90_000_000)
private let downloader = ImageDownloader()

class APIDownload:NSObject {
    static let shared = APIDownload()
    func downloadDataFromURL(_ url:String,_ apiName:String,_ method:String,_ postDic:[String:Any],_ completion: @escaping (Userslist) -> ()) {
        var httpMethod = HTTPMethod(rawValue: method)
        if method == "GET" {
            httpMethod = .get
        }else if method == "POST" {
            httpMethod = .post
        }else {
            httpMethod = .delete
        }
        print("URL --> \(url)")
        if url != ""  {
            
            let headers = HTTPHeaders()
            let urlString = url+apiName
            print("URL --> \(urlString)")
            DispatchQueue.main.async {
                
                AF.request(urlString, method: httpMethod, parameters: postDic, headers: headers).validate(statusCode: 200 ..< 299).responseJSON { response in
                    
                    if response.value != nil {
                        
                        do {
                            let val = try JSONSerialization.jsonObject(with: response.data!, options: [])
                            print("val --> \(val)")
                            var completionData : Userslist!
                            let decoder = JSONDecoder()
                            do {
                                completionData = try decoder.decode(Userslist.self, from: response.data!)
                
                        }
                            catch (let error){
                                print("error: \(error.localizedDescription)")
                            }
                           
                            completion(completionData)
                                        
                        }
                        catch {
                            print(error.localizedDescription)
                        }
                        
                        
                    }else {
                        Extensions.showAlert("Data nil", APPWindow ?? UIViewController())
                    }}}}
        else {
            Extensions.showAlert("URL Not Found", APPWindow ?? UIViewController())
        }
        
    }
    

}

extension UIImageView {
    
    func loadImage(_ url:String) {
        
      let urlRequest = URLRequest(url: URL(string: url)!)

      downloader.download(urlRequest) { response in
        if let image = imageCache.image(withIdentifier: url)
        {
           self.image = image
        }else {
          if response.data != nil {
              let image = UIImage(data: response.data!, scale: 1.0)!
              imageCache.add(image, withIdentifier: url)
            self.image = image
          }
      }
        }
}
}
