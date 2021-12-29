//
//  ECMagicBarView.swift
//  Acabapp
//
//  Created by Eduard Calero on 5/11/21.
//

import UIKit
import CoreServices


public protocol ECMagicBarViewDelegate: UIViewController {
    
    func didSendMessage(_ text: String)
    func didGetImage(_ image: UIImage)
    func didGetViedeo(_ privateUrl: URL)
}

public class ECMagicBarView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak public var textView: UITextView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    
    @IBOutlet weak var textViewTopLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var textviewHeightLayoutContraint: NSLayoutConstraint!
    @IBOutlet weak var textViewBottomLayoutContraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewBottomLayoutConstraint: NSLayoutConstraint!
    
    var barColor: UIColor = .systemGray5
    var cursorColor: UIColor = .systemBlue
    var textColor: UIColor = .black
    var textBackgroundColor: UIColor = .white
    var buttonsTintColor: UIColor = .white
    var buttonsColor: UIColor = .systemBlue
    var textfieldFont: UIFont  = UIFont.systemFont(ofSize: 18)
    var placeholder: String = ""
    var borderColor: UIColor = .black
    var borderWidth: CGFloat = 0.2
    
    var textfieldCurrentNumberOfLines: Int = 0 {
        didSet {
            calculateMaxHeight()
        }
    }
    var textfieldMaxNumberOflinesShown: Int = 3
    
    
    var delegate: ECMagicBarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
    }
    
    public convenience init(frame: CGRect,
                     barColor: UIColor? = nil,
                     cursorColor: UIColor? = nil,
                     textColor: UIColor? = nil,
                     backGroundTextColor: UIColor? = nil,
                     buttonsTintColor: UIColor? = nil,
                     buttonsColor: UIColor? = nil,
                     font: UIFont? = nil,
                     placeholder: String = "",
                     borderColor: UIColor? = nil,
                     borderWidth: CGFloat? = nil,
                     delegate: ECMagicBarViewDelegate? = nil
    ) {
        
        self.init(frame: frame)
        self.barColor = barColor ?? .gray
        self.cursorColor = cursorColor ?? .systemBlue
        self.textColor = textColor ?? .black
        self.textBackgroundColor = backGroundTextColor ?? .white
        self.buttonsTintColor = buttonsTintColor ?? .white
        self.buttonsColor = buttonsColor ?? .systemBlue
        self.textfieldFont = UIFont.systemFont(ofSize: 18)
        self.placeholder = placeholder
        self.delegate = delegate
        self.borderColor = borderColor ?? .black
        self.borderWidth = borderWidth ?? 0.2
        
        configUI()
        
        stackViewBottomLayoutConstraint.constant = 9 + (delegate?.view.safeAreaInsets.bottom ?? 0)
        textViewBottomLayoutContraint.constant = 4 + (delegate?.view.safeAreaInsets.bottom ?? 0)
    }
    
    public convenience init?(coder: NSCoder,
                     barColor: UIColor? = nil,
                     cursorColor: UIColor? = nil,
                     textColor: UIColor? = nil,
                     backGroundTextColor: UIColor? = nil,
                     buttonsTintColor: UIColor? = nil,
                     buttonsColor: UIColor? = nil,
                     font: UIFont? = nil,
                     placeholder: String = "",
                     borderColor: UIColor? = nil,
                     borderWidth: CGFloat? = nil,
                     delegate: ECMagicBarViewDelegate? = nil
    ) {
        
        self.init(coder: coder)
        self.barColor = barColor ?? .gray
        self.cursorColor = cursorColor ?? .systemBlue
        self.textColor = textColor ?? .black
        self.textBackgroundColor = backGroundTextColor ?? .white
        self.buttonsTintColor = buttonsTintColor ?? .white
        self.buttonsColor = buttonsColor ?? .systemBlue
        self.textfieldFont = UIFont.systemFont(ofSize: 18)
        self.placeholder = placeholder
        self.delegate = delegate
        self.borderColor = borderColor ?? .black
        self.borderWidth = borderWidth ?? 0.2
        
        configUI()
        
        stackViewBottomLayoutConstraint.constant = 9 + (delegate?.view.safeAreaInsets.bottom ?? 0)
        textViewBottomLayoutContraint.constant = 4 + (delegate?.view.safeAreaInsets.bottom ?? 0)
        
    }
    
    public override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    
    fileprivate func configUI() {
        
        _ = viewFromNIB(bundle: Bundle(for: type(of: self)),
                                  nameXib: "ECMagicBarView")
        
        self.autoresizingMask = [
                UIView.AutoresizingMask.flexibleHeight
                ]
        
        contentView.backgroundColor = barColor
        
        textView.text = placeholder
        textView.textColor = textColor
        textView.backgroundColor = textBackgroundColor
        textView.tintColor = cursorColor
        textView.font = textfieldFont
        textView.layer.borderColor = borderColor.cgColor
        textView.layer.borderWidth = borderWidth
        
        showCameraButton()
        
        
        textView.delegate = self
        textView.textContainerInset = UIEdgeInsets(top: 0,
                                                   left: 4,
                                                   bottom: 0,
                                                   right: 4)
        
        let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.paragraphSpacingBefore = 1
            paragraphStyle.lineSpacing = 1
            paragraphStyle.paragraphSpacing = 1
            paragraphStyle.alignment = .left

    }
    
}


extension ECMagicBarView {
    
    fileprivate func countNumberOFLines(){
        
        let layoutManager:NSLayoutManager = textView.layoutManager
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var numberOfLines = 0
        var index = 0
        var lineRange:NSRange = NSRange(location: NSNotFound, length: 0)
        
        while (index < numberOfGlyphs) {
            layoutManager.lineFragmentRect(forGlyphAt: index,
                                           effectiveRange: &lineRange)
            index = NSMaxRange(lineRange);
            numberOfLines += 1
        }

        textfieldCurrentNumberOfLines = numberOfLines
    }
    
    
    fileprivate func calculateMaxHeight() {
        
        var linesToShow = min(textfieldCurrentNumberOfLines, textfieldMaxNumberOflinesShown)
        
            linesToShow = max(1, linesToShow)

        
        let textBoxContentHeight = (textfieldFont.lineHeight + 2) * CGFloat(linesToShow)
        
        textviewHeightLayoutContraint.constant = textBoxContentHeight

    }
    
}

extension ECMagicBarView: UITextViewDelegate {
    
    public func refreshSendButtonStatus(){
        textViewDidChange(self.textView)
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        recalculateDimensions()
        
        textView.text.isEmpty ? showCameraButton() : showSendButton()
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder {
            textView.text = ""
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
        }
    }
    
    fileprivate func recalculateDimensions() {
        countNumberOFLines()
    }
    
}

//MARK: Buttons management
extension ECMagicBarView {
    
    fileprivate func showCameraButton() {
        
        let buttonRect = CGRect(x: 0, y: 0, width: 33, height: 33)
        let cameraButton = UIButton(frame: buttonRect)
            cameraButton.setTitleColor(buttonsTintColor, for: .normal)
            cameraButton.tintColor = buttonsColor
            cameraButton.setTitle("", for: .normal)
            cameraButton.setImage(UIImage(systemName: "camera"), for: .normal)
            cameraButton.layer.masksToBounds = true
            cameraButton.layer.cornerRadius = cameraButton.frame.width/2
            cameraButton.addTarget(self, action: #selector(onGetPicture), for: .touchUpInside)
        
        buttonsStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
            buttonsStackView.removeArrangedSubview($0)
        }
            buttonsStackView.addArrangedSubview(cameraButton)
        
        
    }
    
    fileprivate func showSendButton() {
        
        let buttonRect = CGRect(x: 0, y: 0, width: 33, height: 33)
        let sendButton = UIButton(frame: buttonRect)
            sendButton.setTitleColor(buttonsTintColor, for: .normal)
            sendButton.tintColor = buttonsColor
            sendButton.setTitle("", for: .normal)
            sendButton.setImage(UIImage(systemName: "paperplane"), for: .normal)
            sendButton.layer.masksToBounds = true
            sendButton.layer.cornerRadius = sendButton.frame.width/2
            sendButton.addTarget(self, action: #selector(onSendMessage), for: .touchUpInside)
        
        buttonsStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
            buttonsStackView.removeArrangedSubview($0)
        }
            buttonsStackView.addArrangedSubview(sendButton)
    }
    
    @objc
    fileprivate func onSendMessage(){
        delegate?.didSendMessage(textView.text)
        textViewDidChange(self.textView)
    }
    
    @objc
    fileprivate func onGetPicture(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        let availableMediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)
        let mediaTypes = availableMediaTypes?.filter{ $0 == kUTTypeMovie as String || $0 == kUTTypeImage as String } ?? []
//        vc.videoQuality = .typeMedium
        vc.mediaTypes = mediaTypes
        vc.allowsEditing = true
        vc.delegate = self
        delegate?.present(vc, animated: true)
    }

}

extension ECMagicBarView: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        

        if let image = info[UIImagePickerController.InfoKey.init(rawValue: "EditedImage")] as? UIImage {
            
            // Save the new image (original or edited) to the Camera Roll
            UIImageWriteToSavedPhotosAlbum (image, nil, nil , nil)
            picker.dismiss(animated: true)
            delegate?.didGetImage(image)
            
        } else if let videoUrl = info[UIImagePickerController.InfoKey.init(rawValue: "MediaURL")] as? URL {
            
            // Save the new image (original or edited) to the Camera Roll
            UISaveVideoAtPathToSavedPhotosAlbum (videoUrl.path, nil, nil , nil);
            picker.dismiss(animated: true)
            delegate?.didGetViedeo(videoUrl)
            
        }
        else {
            picker.dismiss(animated: true)
        }
    }
    
}
