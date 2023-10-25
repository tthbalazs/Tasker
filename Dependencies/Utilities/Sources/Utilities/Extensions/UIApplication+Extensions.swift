//
//  UIApplication+Extensions.swift
//
//
//  Created by MaTooSens on 23/10/2023.
//

import UIKit

extension UIApplication {
    public static var rootViewController: UIViewController? {
        shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController
    }
}

