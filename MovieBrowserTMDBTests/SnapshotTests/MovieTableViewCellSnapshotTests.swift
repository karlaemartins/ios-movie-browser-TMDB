//
//  MovieTableViewCellSnapshotTests.swift
//  MovieBrowserTMDBTests
//
//  Created by Karla E. Martins Fernandes on 28/09/26.
//

import UIKit
import FBSnapshotTestCase
@testable import NetworkLayer

final class MovieTableViewCellSnapshotTests: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func testMovieTableViewCell() {
        let cell = MovieTableViewCell(
            style: .default,
            reuseIdentifier: MovieTableViewCell.reuseIdentifier
        )

        cell.frame = CGRect(x: 0, y: 0, width: 375, height: 136)

        let image = UIImage(systemName: "photo")
        let imageLoader = MockImageLoader(image: image)

        let movie = MovieFixture.makeMovie()

        cell.configure(
            with: movie,
            genreNames: "Fantasia | Aventura",
            imageLoader: imageLoader
        )

        cell.setNeedsLayout()
        cell.layoutIfNeeded()

        FBSnapshotVerifyView(cell)
    }
}
