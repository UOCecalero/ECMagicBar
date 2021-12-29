# ECMagicBar

[![CI Status](https://img.shields.io/travis/Eduard Calero/ECMagicBar.svg?style=flat)](https://travis-ci.org/Eduard Calero/ECMagicBar)
[![Version](https://img.shields.io/cocoapods/v/ECMagicBar.svg?style=flat)](https://cocoapods.org/pods/ECMagicBar)
[![License](https://img.shields.io/cocoapods/l/ECMagicBar.svg?style=flat)](https://cocoapods.org/pods/ECMagicBar)
[![Platform](https://img.shields.io/cocoapods/p/ECMagicBar.svg?style=flat)](https://cocoapods.org/pods/ECMagicBar)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## HowTo

1. Add the library to your repo

2. Add the following lines to your viewController

<code>

    lazy var inputAccessory: ECMagicBarView = {
       let rect = CGRect(origin: CGPoint(x: 0,
                                         y: 0),
                         size: CGSize(width: view.frame.width,
                                      height: 0 ))
                         
       let inputAccessory = ECMagicBarView(frame: rect,
                                           barColor: UIColor.systemGray6,
                                            cursorColor: UIColor.systemBlue,
                                            textColor: nil,
                                            backGroundTextColor: UIColor.white,
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
</code>

3. Implement the ECMagicBarViewDelegate. Notice that if you want to update the button status, you must call refreshSendButtonStatus() method. Example

<code>

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

</code>

4. Thatst's it:



## Installation

ECMagicBar is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ECMagicBar'
```

## Author

Eduard Calero, educalero@icloud.com

## License

ECMagicBar is available under the GNU GPLv2.1 license. See the LICENSE file for more info.
