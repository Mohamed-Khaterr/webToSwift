//
//  ViewController.swift
//  WebToSwift
//
//  Created by Khater on 6/17/22.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var linkLabel: UILabel!
    
    var webView = WKWebView()
    var alert: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
    }

    @IBAction func getButtonPressed(_ sender: UIButton) {
        //getResult(movieQuality: 720, qualityType: "BluRay", movieName: "fatherhood-2021", vewController: self)
        let urlString: String = "https://yts.mx/movies/" + "fatherhood-2021"
        
        if let url = URL(string: urlString){
            
            webView.load(URLRequest(url: url))
            alert = UIAlertController(title: "Waiting", message: "Getting Link...", preferredStyle: .alert)
            present(self.alert, animated: true, completion: nil)
        }
    }
}


extension ViewController: WKNavigationDelegate{
    // WebView Start
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        alert.message = "Loading..."
    }
    
    // WebView load Completely
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let js = getScript(type: "BluRay", quality: 720)
        
        webView.evaluateJavaScript(js) { (response, error) in
            if error != nil{
                print()
                print(error!.localizedDescription)
                print(error!)
                
                self.alert = UIAlertController(title: "Field", message: "Sorry field to get response", preferredStyle: .alert)
                self.alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(self.alert, animated: true, completion: nil)
                
                return
            }
            
            
            if let result = response as? String{
                self.alert.dismiss(animated: true, completion: nil)
                print(result)
                self.linkLabel.text = result
            }
        }
    }
    
    
    func getScript(type: String, quality: Int) -> String{
        var jsCommand: String?
        
        switch type {
            case "BluRay":
                switch quality {
                case 720:
                    jsCommand = "document.getElementById('movie-info').getElementsByTagName('a')[0].getAttribute('href')"
                case 1080:
                    jsCommand = "document.getElementById('movie-info').getElementsByTagName('a')[1].getAttribute('href')"
                default:
                    jsCommand = "x"
                }
                
            case "WEB":
                switch quality {
                case 720:
                    jsCommand = "document.getElementById('movie-info').getElementsByTagName('a')[2].getAttribute('href')"
                case 1080:
                    jsCommand = "document.getElementById('movie-info').getElementsByTagName('a')[3].getAttribute('href')"
                default:
                    jsCommand = "x"
                }
            default:
                jsCommand = "x"
        }
        
        return jsCommand!
    }
}

