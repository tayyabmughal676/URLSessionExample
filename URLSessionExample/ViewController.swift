//
//  ViewController.swift
//  URLSessionExample
//
//  Created by Thor on 02/07/2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var downloadImageview: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        progressBar.progress = 0
        getPost()
//        postNewPost()
        
        createPost()
        
    }
    
    func createPost() {
            let newPost = Post(
                id: 101,
                title: "Encodable Title",
                body: "This data was created using the encodable format"
            )
            
            guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONEncoder().encode(newPost)
            
            let session = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("The error was: \(error.localizedDescription)")
                } else {
                    let post = try? JSONDecoder().decode(Post.self, from: data!)
                    print("The title is: \(String(describing: post?.title))")
                    print("The body is: \(String(describing: post?.body))")
                }
            }.resume()
        }
    

    func postNewPost(){
        
        let newPost = Post(id: 101, title: "New Post", body: "New Post Body")
        
        guard let mURL =
                URL(string: "https://jsonplaceholder.typicode.com/posts")  else {return}
        
        var request = URLRequest(url: mURL)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type ")
        request.httpBody = try? JSONEncoder().encode(newPost)
        
        let session = URLSession.shared.dataTask(with: request){
            data, response, error in
            
            if let error = error{
                print("there is an error: \(error)")
            }else{
                let post = try? JSONDecoder().decode(Post.self, from: data!)
                print("The title is: \(post?.title)")
                print("The body is: \(post?.body)")
            }
            
        }.resume()
        
    }
    
    func getPost() {
        guard let mURL =
                URL(string: "https://jsonplaceholder.typicode.com/posts")  else {return}
        
        let sesssion = URLSession.shared.dataTask(with: mURL){
            data, response, error in
            
            if let error = error{
                print("There is an error: \(error.localizedDescription)")
            }else{
                let JSONRes = try? JSONSerialization.jsonObject(
                    with: data!,
                    options: []
                )
                print("Response: \(String(describing: JSONRes))")
            }
        }.resume()    }
    
    @IBAction func DownloadImage(_ sender: UIButton) {
        progressLabel.isHidden = false
        //        downloadImageview.image = nil
        
        let imageURL =
            "https://hips.hearstapps.com/digitalspyuk.cdnds.net/18/09/1519729389-thor-ragnarok-reviews-big.jpg"
        
        guard let URL = URL(string: imageURL) else {
            print("This is not invalide URL")
            return
        }
        
        let session = URLSession(
            configuration: .default,
            delegate: self,
            delegateQueue: OperationQueue()
        )
        //        delegateQueue: .main
        
        session.downloadTask(with: URL).resume()
        
    }
    
}

extension ViewController: URLSessionDownloadDelegate{
    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL
    ) {
        guard let Data = try? Data(contentsOf: location) else {
            print("Data contains an error")
            return
        }
        
        let image = UIImage(data: Data)
        
        DispatchQueue.main.async { [weak self] in
            self?.downloadImageview.image = image
            self?.progressLabel.isHidden = true
        }
        
        //        downloadImageview.image = image
        //        progressLabel.isHidden = true
    }
    
    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64
    ) {
        
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        
        //        progressBar.progress = progress
        //        progressLabel.text = "\(progress * 100)%"
        
        DispatchQueue.main.async { [weak self] in
            self?.progressBar.progress = progress
            self?.progressLabel.text = "\(progress * 100)%"
        }
        
        
        print("Progress: \(progress)")
        
    }
    
}

