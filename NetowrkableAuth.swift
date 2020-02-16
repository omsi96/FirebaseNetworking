
import Foundation
import Firebase
import CodableFirebase
import FirebaseFirestore
import FirebaseFirestore

// Auth networking
extension Networking//: NetworkableAuth
{
    
    static func getUserFromUid(uid: String, completion: @escaping (User?)->())
    {
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, error) in
            guard let snapshot = snapshot,
                  let snpashotData = snapshot.data() else {return}
            
            
            let decodedUser = try? FirebaseDecoder().decode(User.self, from: snpashotData)
            
            
//            guard let uid = snpashotData["uid"] as? String else {return}
//            guard let firstname = snpashotData["firstname"] as? String else {return}
//            guard let lastname = snpashotData["lastname"] as? String else {return}
//            guard let email = snpashotData["email"] as? String else {return}
//            let imageurl = snpashotData["imageURL"] as? String
//
//            let user = User(firstname: firstname,
//                            lastname: lastname,
//                            uid: uid,
//                            imageURL: imageurl,
//                            email: email)
            DispatchQueue.main.async {
                completion(decodedUser)
            }
        }
    }
    
    static func registerUserInDataBase(user: Registerant, uid: String, fail: (()->Void)?) -> User
    {
        // user was created successfully, now store the first name and last name
        let db = Firestore.firestore()
        
        let userData = ["firstname": user.firstname,
                        "lastname": user.lastname,
                        "uid": uid,
                        "email": user.email,
            ] 
        
        
        db.collection("users").document(uid).setData(userData, merge: true)
        return User(firstname: user.firstname, lastname: user.lastname, uid: uid, email: user.email)
        
    }
    
    static func setUserImage(uid: String)
    {
        // user was created successfully, now store the first name and last name
        let db = Firestore.firestore()
        
        let userData = ["imgeURL" : "usersImages/\(uid).jpg"
            ]
        db.collection("users").document(uid).updateData(["imageURL" : userData] )
    }
    static func signUp(user: Registerant, success: ((String)->Void)? = nil, fail: (()->Void)? = nil)
    {
        Auth.auth().createUser(withEmail: user.email, password: user.password) { (result, error) in
            guard (error == nil) else {
                fail?()
                return
            }
            guard let result = result else {return}
            let uid = result.user.uid
            success?(uid)
            
            let user = registerUserInDataBase(user: user, uid: result.user.uid) {
                print("THERE WAS AN ERROR WITH WRITING USER TO DATABASE")
            }
            UserCacher.saveUser(user: user)
        }
    }
    
    static func signIn(user: SignInUser, success: (()->Void)? = nil, fail: (()->Void)? = nil)
    {
        Auth.auth().signIn(withEmail: user.email, password: user.password) { (result, error) in
            if error != nil {
                fail?()
                return
            }
            guard let result = result else {return}
            getUserFromUid(uid: result.user.uid) { (user) in
                guard let user = user else {
                    fail?()
                    return
                }
                UserCacher.saveUser(user: user)
            }
            success?()
        }
    }
    
    static func signOut(success: (()->Void)? = nil, fail: (()->Void)? = nil)
    {
        guard let currentUserUid = Auth.auth().currentUser?.uid else{
            success?()
            print("User is already signed out")
            return
        }
        do{
            try Auth.auth().signOut()
            success?()
            print("User has been signed out, current user = ")
            print(Auth.auth().currentUser.debugDescription)
            UserCacher.deleteUser(uid: currentUserUid)
        }
        catch{
            fail?()
        }
    }
    
    
    static func forgetPassword(email: String,success: (()->Void)? = nil, fail: (()->Void)? = nil)
    {
        Auth.auth().sendPasswordReset(withEmail: email) {error in
            
            if error == nil
            {
                success?()
            }
            else {
                fail?()
            }
        }
    }
    
}
