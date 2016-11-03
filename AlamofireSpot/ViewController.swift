//
//  ViewController.swift
//  AlamofireSpot
//
//  Created by Karthik Muppala on 10/29/16.
//  Copyright © 2016 Karthik Muppala. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

var player = AVAudioPlayer()

struct song {
    let songImage : UIImage!
    let songName : String!
    let songUrl : String!
}

class TableViewController: UITableViewController, UISearchBarDelegate {
    
    var searchUrl = String()
    typealias jsonFetchString = [String:AnyObject]
    var songs = [song]()
    @IBOutlet var searchBar: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keyWords = searchBar.text
        let updatedKeyWords = keyWords?.replacingOccurrences(of: " ", with: "+")
        searchUrl = "https://api.spotify.com/v1/search?q=\(updatedKeyWords!)&type=track"
        callAlamo(url: searchUrl)
        self.view.endEditing(true)
    }
    
    func callAlamo(url:String) {
        Alamofire.request(url).responseJSON(completionHandler: {
            response in
            self.parseData(jsonData: response.data!)
        })
    }
    
    func parseData(jsonData : Data) {
        do{
            var readableJson = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! jsonFetchString
            if let tracks = readableJson["tracks"] as? jsonFetchString  {
                if let items = tracks["items"] as? [jsonFetchString]{
                    for i in 0..<items.count{
                        let item = items[i]
                        print(item)
                        let name = item["name"] as! String
                        let preveiwUrl = item["preview_url"] as! String
                        
                        if let album = item["album"] as? jsonFetchString {
                            if let images = album["images"] as? [jsonFetchString]{
                                let imageUrlData = images[0]
                                let imageUrl = URL(string: imageUrlData ["url"] as! String)
                                let imageData = NSData(contentsOf: imageUrl!)
                                let image = UIImage(data:imageData as! Data)
                                songs.append(song.init(songImage: image, songName: name, songUrl: preveiwUrl))
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
        catch{
            print(error)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let songImage = cell?.viewWithTag(2) as! UIImageView
        songImage.image = songs[indexPath.row].songImage
        let songLabel = cell?.viewWithTag(1) as! UILabel
        songLabel.text = songs[indexPath.row].songName
        return cell!
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tableView.indexPathForSelectedRow?.row
        
        let vc = segue.destination as! SongViewController
        vc.image = songs[indexPath!].songImage
        vc.name = songs[indexPath!].songName
        vc.link = songs[indexPath!].songUrl
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

