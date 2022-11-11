//
//  NetworkManager.swift
//  FlickrTest3
//
//  Created by Muhsin Can Yılmaz on 2.11.2022.
//

import Foundation

class NetworkManager{
    static let shared = NetworkManager()
    
    func fetchPhotos(urlString url: String?, completion: @escaping (Data)->()){
        if let urlString = url{
            if let url = URL(string: urlString){
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    if let data = data {
                        DispatchQueue.main.async {
                            completion(data)
                        }
                    }
                }.resume()
            }
        }
    }
}
