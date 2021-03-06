//
//  ImageCaptureController.swift
//  AnyImageKit
//
//  Created by 刘栋 on 2019/12/3.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit
import SnapKit

public protocol ImageCaptureControllerDelegate: class {
    
    func imageCaptureDidCancel(_ capture: ImageCaptureController)
    func imageCapture(_ capture: ImageCaptureController, didFinishCapturing mediaURL: URL, type: MediaType)
}

extension ImageCaptureControllerDelegate {
    
    public func imageCaptureDidCancel(_ capture: ImageCaptureController) {
        capture.dismiss(animated: true, completion: nil)
    }
}

open class ImageCaptureController: AnyImageNavigationController {
    
    open private(set) weak var captureDelegate: ImageCaptureControllerDelegate?
    
    public required init(options: CaptureOptionsInfo, delegate: ImageCaptureControllerDelegate) {
        enableDebugLog = options.enableDebugLog
        super.init(nibName: nil, bundle: nil)
        self.captureDelegate = delegate
        
        let rootViewController = CaptureViewController(options: options)
        rootViewController.delegate = self
        self.viewControllers = [rootViewController]
    }
    
    @available(*, deprecated, message: "init(coder:) has not been implemented")
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    #if ANYIMAGEKIT_ENABLE_EDITOR
    open override func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        if let _ = presentedViewController as? ImageEditorController {
            presentingViewController?.dismiss(animated: flag, completion: completion)
        } else {
            super.dismiss(animated: flag, completion: completion)
        }
    }
    #endif
    
    open override var prefersStatusBarHidden: Bool {
        return true
    }
}
 
// MARK: - CaptureViewControllerDelegate
extension ImageCaptureController: CaptureViewControllerDelegate {
    
    func captureDidCancel(_ capture: CaptureViewController) {
        captureDelegate?.imageCaptureDidCancel(self)
    }
    
    func capture(_ capture: CaptureViewController, didOutput mediaURL: URL, type: MediaType) {
        captureDelegate?.imageCapture(self, didFinishCapturing: mediaURL, type: type)
    }
}
