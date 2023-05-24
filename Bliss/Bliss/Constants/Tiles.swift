//
//  Tiles.swift
//  Bliss
//
//  Created by Angela Christabel on 21/05/23.
//

import Foundation

extension TileNode {
    static let width = 45.7
    static let height = 45.7
}

enum CollisionType: UInt32 {
    case inventory = 1
    case tile = 2
}
