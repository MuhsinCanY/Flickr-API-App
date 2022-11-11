//
//  ViewController.swift
//  FlickrTest3
//
//  Created by Muhsin Can Yılmaz on 31.10.2022.
//

import UIKit

class ViewController: UITableViewController, UISearchResultsUpdating {
    
    
    var response: Response?{
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var selectedPhoto: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchResponse()
        search()
        
    }
    
    //MARK: - Segue works
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail"{
            if let destination = segue.destination as? DetailViewController{
                destination.selectedPhotoDetailVC = selectedPhoto
            }
        }
    }
    
    
    //MARK: -Fetch Data from URL
    func fetchResponse(){
        let url = URL(string: "https://www.flickr.com/services/rest/?format=json&nojsoncallback=1&method=flickr.photos.getRecent&api_key=36b09a7f7cb72232ec7fc39db967165e&extras=description,owner_name,icon_server,url_m,url_n,url_z,url_c,url_l,url_o")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let data = data {
                let result = try? JSONDecoder().decode(Response.self, from: data)
                self.response = result
            }
            
        }.resume()
    }
    
    func fetchSearchResponse(with text: String){
        let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=6e756a73d97e0b60ffd16646acf28896&text=\(text)&format=json&nojsoncallback=1&extras=description,owner_name,icon_server,url_m,url_n,url_z,url_c,url_l,url_o")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let data = data {
                let result = try? JSONDecoder().decode(Response.self, from: data)
                self.response = result
            }
            
        }.resume()
    }
    
    //MARK: -SearchController
    func search(){
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search"
        navigationItem.searchController = search
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {return}
        if text.count > 2{
            fetchSearchResponse(with: text)
        }
    }
    
    //MARK: - TableViewController
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response?.photos?.photo?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        if let item = response?.photos?.photo?[indexPath.row]{
            cell.descriptionLabel.text = item.photoDescription?.content
            cell.usernameLabel.text = item.ownername
            cell.userImageView.layer.cornerRadius = 24.0
            cell.mainImageView.layer.cornerRadius = 10.0
            
            NetworkManager.shared.fetchPhotos(urlString: item.urlM) { data in
                cell.mainImageView.image = UIImage(data: data)
            }
            
            if let iconfarm = item.iconfarm, let iconserver = item.iconserver, let id = item.owner, let iconserverInt = Int(iconserver){
                let iconfarmString = String(iconfarm)
                var urlString = ""
                if iconserverInt > 0{
                    urlString = "https://farm\(iconfarmString).staticflickr.com/\(iconserver)/buddyicons/\(id).jpg"
                    NetworkManager.shared.fetchPhotos(urlString: urlString) { data in
                        cell.userImageView.image = UIImage(data: data)
                    }
                }else{
                    urlString = "https://www.flickr.com/images/buddyicon.gif"
                    NetworkManager.shared.fetchPhotos(urlString: urlString) { data in
                        cell.userImageView.image = UIImage(data: data)
                    }
                    
                }
                
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let photo = response?.photos?.photo?[indexPath.row]{
            selectedPhoto = photo
        }
        performSegue(withIdentifier: "toDetail", sender: nil)
    }
    
    
}

