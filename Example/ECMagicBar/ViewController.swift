//
//  ViewController.swift
//  ECMagicBar
//
//  Created by Eduard Calero on 12/28/2021.
//  Copyright (c) 2021 Eduard Calero. All rights reserved.
//

import UIKit
import ECMagicBar

class ViewController: UIViewController {
    
    let viewModel = ViewModel()
    
    @IBOutlet var tableView: UITableView!
    
    lazy var inputAccessory: ECMagicBarView = {
       let rect = CGRect(origin: CGPoint(x: 0,
                                         y: 0),
                         size: CGSize(width: view.frame.width,
                                      height: 0 ))
                         
       let inputAccessory = ECMagicBarView(frame: rect,
                                            barColor: .white,
                                            cursorColor: UIColor.systemBlue,
                                            textColor: nil,
                                            backGroundTextColor: UIColor.lightGray,
                                            buttonsTintColor: nil,
                                            buttonsColor: UIColor.systemBlue,
                                            placeholder: "Write sth here...",
                                            delegate: self)
       return inputAccessory
     }()
    
    override var inputAccessoryView: UIView? {
        get {
            return inputAccessory
        }
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
            configureTableView()
            addListeners()
      
    }
    
    
    deinit {
        removeListeners()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            self.becomeFirstResponder()
     }
    
    
    fileprivate func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.backgroundColor = .lightGray
    }
}
    


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.conversation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = viewModel.conversation[indexPath.row]
        let cell =  UITableViewCell()
        
        cell.textLabel?.text = message.message
        cell.imageView?.image = message.image
        return cell
    }
}


extension ViewController: ECMagicBarViewDelegate {
    func didSendMessage(_ text: String) {
        viewModel.sendMessage(text) { [weak self] result in
            switch result {
            case .success(_):
                self?.inputAccessory.textView.text = ""
                self?.inputAccessory.refreshSendButtonStatus()
                self?.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func didGetImage(_ image: UIImage) {
        viewModel.sendImage(image) { [weak self] result in
            switch result {
            case .success(_):
                self?.inputAccessory.refreshSendButtonStatus()
                self?.tableView.reloadData()
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func didGetViedeo(_ privateUrl: URL) {
        viewModel.sendVideo(privateUrl) { [weak self] result in
            switch result {
            case .success(_):
                self?.inputAccessory.refreshSendButtonStatus()
                self?.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    

}

//MARK: Keyboard management
extension ViewController {
    
     func addListeners() {
         
         let tapView = UITapGestureRecognizer()
                 tapView.addTarget(self, action: #selector(tapOnViewcontroller(gesture:)))
                 self.tableView.addGestureRecognizer(tapView)

      
         NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: nil) { [weak self] notification in
                    self?.keyboardNotification(notification:notification)
              }
         NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil) { [weak self] notification in
                    self?.keyboardNotification(notification:notification)
              }

    }
    

     func removeListeners() {
         NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
         NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    /// Magic fix for keyboard
     func keyboardNotification(notification: Notification) {
        if let userInfo = notification.userInfo {
            guard let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
            let duration: TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)

            if notification.name == .UIKeyboardWillHide {
                    self.additionalSafeAreaInsets.bottom = -view.safeAreaInsets.bottom
            } else {
                
                

                let totalHeight = keyboardFrame.height - view.safeAreaInsets.bottom

                self.additionalSafeAreaInsets.bottom = totalHeight
                        
            }

            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() }) { [weak self] _ in
                self?.view.layoutIfNeeded()
            }
            
        }
    }
    
    
    @objc func tapOnViewcontroller(gesture: UITapGestureRecognizer) {
        if let chatToolbarView =  self.inputAccessoryView as? ECMagicBarView {
            chatToolbarView.textView.resignFirstResponder()
        }
    }
}

