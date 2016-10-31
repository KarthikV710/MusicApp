//
//  SongViewController.swift
//  
//
//  Created by Karthik Muppala on 10/30/16.
//
//

import Foundation
import UIKit
import AVFoundation

class SongViewController: UIViewController {
    
    var image = UIImage()
    var name = String()
    var link = String()
    
    
    
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var songImage: UIImageView!
    
    override func viewDidLoad() {
        songName.text = name
        songImage.image = image
        backgroundImageView.image = image
        playPauseButton.setTitle("Pause", for: .normal)
        downloadSongFromUrl(downloadUrl: URL(string: link)!)
    }
    
    func downloadSongFromUrl(downloadUrl: URL){
        var downloadTask = URLSessionDownloadTask()
        downloadTask = URLSession.shared.downloadTask(with: downloadUrl, completionHandler: {
            customUrl, response, error in
            self.playSong(url: customUrl!)
        })
        downloadTask.resume()
    }
    
    func playSong(url: URL) {
        do{
            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.play()
        }catch{
            print(error)
        }
    }
    
    @IBAction func playPauseAction(_ sender: AnyObject) {
        
        if player.isPlaying {
            player.pause()
            playPauseButton.setTitle("Play", for: .normal)
        }else{
            player.play()
            playPauseButton.setTitle("Pause", for: .normal)
        }
    }
    
    
}
