//
//  ErrorHandler.swift
//  MatrixHomeTask
//
//  Created by hyperactive hi-tech ltd on 11/08/2021.
//  Copyright © 2021 hyperactive. All rights reserved.
//

import UIKit

protocol ErrorHandlerDelegate: class {
    func handleConnectionFix()
}

class ErrorHandler {
    
    private weak var delegate: ErrorHandlerDelegate?
    
    enum ErrorType: Error {
        case connection
        case json
        case parsing
        case service
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setDelegate(delegate: ErrorHandlerDelegate) {
        self.delegate = delegate
    }
    
    func handleError(type: ErrorType, error: Error? = nil) {
        displayError(type, error)
    }
    
    private func displayError(_ type: ErrorType,_ error: Error? = nil) {
        DispatchQueue.main.async { [weak self] in
            if self == nil { return }
//            if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
//                window.rootViewController?.present(self!.makeAlert(type, error), animated: true, completion: nil)
//            }
        }
    }
    
    private func makeAlert(_ type: ErrorType,_ error: Error? = nil) -> UIAlertController {
        var message = error == nil ? "" : error!.localizedDescription
        if message.count > 200 { message = "" } // not a user friendly desctiption, don't show it.
        
        let ac = UIAlertController(title: "\(type) Error", message: message, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Fix", style: .default, handler: { (aciton) in
            self.fix(for: type)
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel" , style: .cancel, handler: nil))
        
        return ac
    }
    
    private func fix(for type: ErrorType) {
        switch type {
            case .connection: fixConnection()
            case .json: fixJson()
            case .parsing: fixParsing()
            case .service: fixService()
        }
    }
    
    private func fixConnection() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL) { [weak self] (result) in
                self?.setObserverForConnectionChange()
            }
        }
    }
    
    private func setObserverForConnectionChange() {
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: UIApplication.shared, queue: nil) { [weak self] (notification) in
            self?.delegate?.handleConnectionFix()
        }
    }
    
    private func fixJson() {
        
    }
    
    private func fixParsing() {
        
    }
    
    private func fixService() {
        
    }
}
