//
//  MockAPI.swift
//  pam-demo
//
//  Created by narongrit kanhanoi on 4/3/2564 BE.
//

import Foundation

class MockAPI {
    
    static let main = MockAPI()
    
    func login(email:String) -> UserModel? {
        let user = userTable.filter{
            return $0["email"] == email
        }
        if user.count == 1{
            let u = user[0]
            let user = UserModel(name: u["name"] ?? "" ,
                                 custID: u["cust_id"] ?? "",
                                 email: u["email"] ?? "",
                                 profileImage: u["profile_image"] ?? "")
            return user
        }
        return nil
    }
    
    
    
}


