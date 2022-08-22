//
//  Account.swift
//  VoucherTicket
//
//  Created by Narek Ghukasyan on 21.08.22.
//

import Foundation

struct Account {
    var vouchers: [Voucher] = []
    var amountToPaid = Constants.TOTAL_AMOUNT
    var haveToPaid = true
    static var availableVoucherTickets: [Voucher] = [
        Voucher(code: "E8051FB25E", lang: "hy", amountToDecrease: 70_000),
        Voucher(code: "6112c274b3", lang: "hy", amountToDecrease: 70_000),
        Voucher(code: "218C710925", lang: "hy", amountToDecrease: 140_000),
        Voucher(code: "973AC72FDF", lang: "hy", amountToDecrease: 210_000)
    ]
    
    static var voucherTickets = [
        "E8051FB25E": 70_000,
        "6112c274b3": 70_000,
        "218C710925": 140_000,
        "973AC72FDF": 210_000
    ]
}

struct VoucherResponse: Decodable {
    let orderNumber: String
    let lang: String
    let peopleCount: Int
    let pricePerPerson: Int
    
    enum CodingKeys: String, CodingKey {
      case orderNumber = "OrderNumber"
      case lang = "Lang"
      case peopleCount = "PeopleCount"
      case pricePerPerson = "PricePerPerson"
    }
}


/*
 struct Starships: Decodable {
   var count: Int
   var all: [Starship]
   
   enum CodingKeys: String, CodingKey {
     case count
     case all = "results"
   }
 }
 */
