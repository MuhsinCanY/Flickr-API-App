//
//  DetailViewController.swift
//  FlickrTest3
//
//  Created by Muhsin Can Yılmaz on 31.10.2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var mainImageView: UIImageView!
    
    var selectedPhotoDetailVC: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.text = selectedPhotoDetailVC?.photoDescription?.content
        titleLabel.text = selectedPhotoDetailVC?.ownername
        
        NetworkManager.shared.fetchPhotos(urlString: selectedPhotoDetailVC?.urlO) { data in
            self.mainImageView.image = UIImage(data: data)
        }
        
        if let iconfarm = selectedPhotoDetailVC?.iconfarm, let iconserver = selectedPhotoDetailVC?.iconserver, let id = selectedPhotoDetailVC?.owner, let iconserverInt = Int(iconserver){
            let iconfarmString = String(iconfarm)
            var urlString = ""
            if iconserverInt > 0{
                urlString = "https://farm\(iconfarmString).staticflickr.com/\(iconserver)/buddyicons/\(id).jpg"
                NetworkManager.shared.fetchPhotos(urlString: urlString) { data in
                    self.userImageView.image = UIImage(data: data)
                }
            }else{
                urlString = "https://www.flickr.com/images/buddyicon.gif"
                NetworkManager.shared.fetchPhotos(urlString: urlString) { data in
                    self.userImageView.image = UIImage(data: data)
                }
                
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
