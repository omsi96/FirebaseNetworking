import Foundation


class NetworkingTests
{
    // Testing sign up with random email 
    static func SignUp()
    {
        Networking.signUp(user: Registerant(firstname: "Someonenew", lastname: "HEOEHoflsk", email: "\(Int.random(in: 0...99999))@test.com", phoneNumber: "392481", userType: "Admin", password: "password1234"), success: { uid in
            print("✅ User has been created successffully")
        }) {
            print("❌ There was an error while creating this user")
        }
    }
    
    static func SignIn()
    {
        Networking.signIn(user: SignInUser(email: "test@test.test", password: "password1234"), success: {
            print("✅ User has been signed in successffully")
        }) {
            print("❌ There was an error while signing in this user")
        }
    }
    
    static func SignOut()
    {
        Networking.signOut()
        
    }
    
    static func resetPassword()
    {
        Networking.forgetPassword(email: "test@test.test", success: {
            print("✅ Password reset has been sent")
        })
    }
    
    static func RetreiveAllUsers()
    {
        var users: [User] = []
        Networking.getListOfUsers { users in
            users.forEach { user in
                print("🥳 \(user)")
            }
        }
        print("-------------------------")
    }
}
