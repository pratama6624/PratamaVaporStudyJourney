//
//  Order.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 15/03/25.
//

import Vapor
import Fluent

// Case Study
/*
    Order -> User
        Many -> One ( Banyak order bisa dimiliki oleh 1 user )
        One <- Many ( 1 user bisa memiliki banyak order )
        Parent on Many Side
        Children on One Side
 
    Order -> Payment
        One -> One ( 1 order hanya memiliki 1 payment )
        One <- One ( 1 payment hanya untuk 1 order )
        Parent on One Side
        OptionalChild on One Side
            Note :
                - One to One hanya berlaku jika 1 order memiliki 1 pembayaran penuh (tanpa split)
                - Many to One berlaku jika ada metode split payment (1 order bisa dibayar dengan banyak payment)
                - Many to Many bisa terjadi jika jik banyak order dengan split payment (for big app)
 
    Order -> Shipping
        Many -> One ( Banyak order bisa mengarah ke 1 shipping )
        Many <- One ( 1 shipping membawa / memiliki banyak order )
        Parent on Many Side
        Children on One Side
            Note :
                - One to One hanya berlaku untuk aplikasi kecil yang tidak memiliki banyak order
                - One to Many berlaku jika dalam 1 shipping bisa membawa banyak order
                - Many to Many berlaku jika barang terpisah dalam beberapa paket sehingga jika order terpisah maka shipping juga terpisah
 
    Order -> Product
        Many -> Many ( Banyak order bisa memiliki banyak produk )
        many <- Many ( Banyak produk bisa muncul di banyak order / order yang berbeda )
        Sibling ( Pivot Relations )
 */

final class OrderRelation: Model, Content, @unchecked Sendable {
    static let schema: String = "order_multi_relations"
    
    @ID(key: .id)
    var id: UUID?
    
    // Many to One
    @Parent(key: "user_id")
    var user: UserRelation
    
    // One to One
    @OptionalParent(key: "payment_id")
    var payment: PaymentRelation?
    
    // Many to One
    @OptionalParent(key: "shipping_id")
    var shipping: ShippingRelation?
    
    // Many to Many
    @Siblings(through: OrderProductPivot.self, from: \.$order, to: \.$product)
    var properties: [ProductRelation]
    
    init() { }
    
    init(id: UUID? = nil, userID: UUID, paymentID: UUID? = nil, shippingID: UUID? = nil) {
        self.id = id
        self.$user.id = userID
        self.$payment.id = paymentID
        self.$shipping.id = shippingID
    }
}
