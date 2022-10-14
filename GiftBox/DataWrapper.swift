//
//  DataWrapper.swift
//  GiftBox
//
//  Created by Lisa on 12.10.2022.
//

import Foundation
import FMDB


let type1 = GiftType(title: "FIRST")
let type2 = GiftType(title: "SECOND")
let gift1 = Gift(title: "Подарок FIRST.1", isActive: true, giftType: type1.id)
let gift2 = Gift(title: "Подарок SECOND.1", isActive: true, giftType: type2.id)

final class DataWrapper: ObservableObject {
    private let db: FMDatabase
    
    init(fileName: String = "giftboxdb") {
        // 1 - Get filePath of the SQLite file
        let fileURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("\(fileName).sqlite")
        
        // 2 - Create FMDatabase from filePath
        let db = FMDatabase(url: fileURL)
        
        // 3 - Open connection to database
        guard db.open() else {
            fatalError("Unable to open database")
        }
        
        // 4 - Initial table creation
        do {
            try db.executeStatements("drop table if exists gift_type")
            try db.executeStatements("drop table if exists gift")
            try db.executeStatements("create table if not exists gift_type(id uuid not null primary key, title varchar(255) unique)")
            try db.executeStatements("create table if not exists gift(title varchar(255) primary key, isActive bool, gift_type uuid)")
        } catch {
            fatalError("cannot execute query")
        }
        
        self.db = db
        loadTypes()
    }
    
    private func loadTypes() {
        print("ЗАГРУЗКА")
        deleteGiftType()
        deleteGift()
        print("РАЗМЕР ТАБЛИЦЫ ТИП ПОДАРКА: " + getAllTypes().count.description)
        print("РАЗМЕР ТАБЛИЦЫ ПОДАРКА: " + getAllGifts().count.description)
        if (getAllTypes().count == 0) {
            insertGiftType(type1)
            insertGiftType(type2)
            insertGift(gift1)
            insertGift(gift2)

        }
        print("РАЗМЕР ТАБЛИЦЫ ТИП ПОДАРКА: " + getAllTypes().count.description)
        print("РАЗМЕР ТАБЛИЦЫ ПОДАРКА: " + getAllGifts().count.description)
        
    }
    
    func insertGiftType(_ giftType: GiftType) {
        print("СОХРАНЕНИЕ ТИПА ПОДАРКА: " + giftType.title)
        do {
            try db.executeUpdate(
                    """
                    insert into gift_type (id, title)
                    values (?, ?)
                    """,
                    values: [giftType.id, giftType.title]
            )
        } catch {
            fatalError("cannot insert giftType: \(error)")
        }
    }
    
    func insertGift(_ gift: Gift) {
        var count = 0
    
        do {
            try db.executeUpdate(
                    """
                    insert into gift (title, isActive, gift_type)
                    values (?, ?, ?)
                    """,
                    values: [gift.title, gift.isActive, gift.giftType]
            )
            count = count + 1
            print("Сохранение подарка: " + count.description)
        } catch {
            fatalError("cannot insert gift: \(error)")
        }
    }
    
    func deavtivateGift(_ gift: Gift) {
        
        do {
            try db.executeUpdate(
                    """
                    update gift
                    set isActive = false
                    where title = ?
                    """,
                    values: [gift.title]
            )
        
        } catch {
            fatalError("cannot deactivate gift: \(error)")
        }
    }
    
    
    func getAllTypes() -> [GiftType] {
            var types = [GiftType]()
            do {
                let result = try db.executeQuery("select * from gift_type", values: nil)
                while result.next() {
                    if let type = GiftType(from: result) {
                        types.append(type)
                    }
                }
                return types
            } catch {
                return types
            }
        }
    
    func getAllGifts() -> [Gift] {
            var gifts = [Gift]()
            do {
                let result = try db.executeQuery("select * from gift", values: nil)
                while result.next() {
                    if let gift = Gift(from: result) {
                        gifts.append(gift)
                    }
                }
                return gifts
            } catch {
                return gifts
            }
        }
    
    func getGiftsByType(giftType: UUID) -> [Gift] {
            var gifts = [Gift]()
            do {
                let result = try db.executeQuery("select * from gift where gift_type = ?",
                                                 values: [giftType])
                while result.next() {
                    if let gift = Gift(from: result) {
                        gifts.append(gift)
                    }
                }
                print(gifts)
                return gifts
            } catch {
                return gifts
            }
        }
    
    func deleteGiftType() {
        do {
        try db.executeQuery("delete from gift_type",
                            values: nil)
            
        } catch {
            print("error while deleteGiftType")
        }
    }
    
    func deleteGift() {
        do {
            try db.executeQuery("delete from gift",
                                values: nil)
        } catch {
            print("error while deleteGift")
        }
    }
}
