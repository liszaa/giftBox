//
//  GiftType.swift
//  GiftBox
//
//  Created by Lisa on 12.10.2022.
//

import Foundation
import FMDB

struct GiftType: Hashable, Decodable {
    let id: UUID
    let title: String
    
    init(title: String) {
        self.id = UUID()
        self.title = title
    }
    
    init?(from result: FMResultSet) {
        if let title = result.string(forColumn: "title") {
            self.title = title
            self.id = UUID(uuidString: result.string(forColumn: "id") ?? "")!
        } else {
            return nil
        }
    }
}
