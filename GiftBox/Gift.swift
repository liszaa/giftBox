//
//  Gift.swift
//  GiftBox
//
//  Created by Lisa on 12.10.2022.
//

import Foundation
import FMDB

struct Gift: Hashable, Decodable {
    let title: String
    let isActive: Bool
    let giftType: UUID
    
    init(title: String, isActive: Bool, giftType: UUID) {
        self.title = title
        self.isActive = isActive
        self.giftType = giftType
    }
    
    init?(from result: FMResultSet) {
        if let title = result.string(forColumn: "title") {
            self.title = title
            self.isActive = result.bool(forColumn: "isActive")
            self.giftType = UUID(uuidString: result.string(forColumn: "gift_type") ?? "")!
        } else {
            return nil
        }
    }
}
