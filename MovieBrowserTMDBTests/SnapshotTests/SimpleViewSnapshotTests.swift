//
//  SimpleViewSnapshotTests.swift
//  MovieBrowserTMDBTests
//
//  Created by Karla E. Martins Fernandes on 25/09/26.
//

import UIKit
import FBSnapshotTestCase

final class SimpleViewSnapshotTests: FBSnapshotTestCase {
    
    override func setUp() {
            super.setUp()
        recordMode = false
        }
    
    func testSimpleView() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        view.backgroundColor = .systemBlue
        
        FBSnapshotVerifyView(view)

    }

}
