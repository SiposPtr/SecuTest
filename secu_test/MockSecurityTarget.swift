//
//  MockSecurityTarget.swift
//  secu_test
//
//  Created by Péter Sipos on 2025. 08. 02..
//

import Foundation

@objc class MockSecurityTarget: NSObject {
    @objc dynamic func testFunction() -> String {
        return "Original"
    }
}
