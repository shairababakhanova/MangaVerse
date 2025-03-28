//
//  User.swift

//
//  Created by Бабаханова Шаира on 16.03.2025.
//

import Foundation

struct User: Identifiable {
    let id = UUID()
    var name: String = ""
    var email: String  = ""
    var password: String = ""
    var avatar: String = ""
    
}
