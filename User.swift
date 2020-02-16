
import Foundation
import FirebaseFirestore
import class Firebase.User
typealias FirebaseUser = Firebase.User

struct User: Codable
{
    var firstname: String
    var lastname: String
    var uid: String
    var email: String
    
    
    func getFullName() -> String{
        return firstname + " " + lastname
    }
    
}


struct Registerant: Encodable
{
    var firstname: String
    var lastname: String
    var email: String
    var phoneNumber: String
    var userType: String
    var password: String

}


struct SignInUser: Encodable
{
    var email: String
    var password: String 
}
