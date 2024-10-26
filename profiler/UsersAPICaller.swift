import Foundation

struct UsersResponseModel: Codable {
    let results: [User]
}

struct UserProfile {
    let username: String
    let email: String
    let location: String
    let imageUrl: String
}

struct User: Codable {
    let gender: String
    let name: Name
    let email: String
    let location: Location
    let login: Login
    let dob: DOB
    let registered: Registered
    let phone: String
    let cell: String
    let id: ID
    let picture: Picture
    let nat: String

    var userProfile: UserProfile {
        return UserProfile(
            username: "\(name.first) \(name.last)",
            email: email,
            location: "\(location.city), \(location.state)", // Customize as needed
            imageUrl: picture.large
        )
    }
}

struct Name: Codable {
    let title: String
    let first: String
    let last: String

    var fullName: String {
        return "\(title) \(first) \(last)"
    }
}

struct Location: Codable {
    let street: Street
    let city: String
    let state: String
    let country: String
    let postcode: String // Changed to String
    let coordinates: Coordinates
    let timezone: Timezone

    // Custom initializer for flexible postcode decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        street = try container.decode(Street.self, forKey: .street)
        city = try container.decode(String.self, forKey: .city)
        state = try container.decode(String.self, forKey: .state)
        country = try container.decode(String.self, forKey: .country)
        
        // Flexible postcode decoding
        if let postcodeInt = try? container.decode(Int.self, forKey: .postcode) {
            postcode = String(postcodeInt) // Convert to String if decoded as Int
        } else {
            postcode = try container.decode(String.self, forKey: .postcode) // Decode as String
        }

        coordinates = try container.decode(Coordinates.self, forKey: .coordinates)
        timezone = try container.decode(Timezone.self, forKey: .timezone)
    }
}

struct Street: Codable {
    let number: Int
    let name: String
}

struct Coordinates: Codable {
    let latitude: String
    let longitude: String
}

struct Timezone: Codable {
    let offset: String
    let description: String
}

struct Login: Codable {
    let uuid: String
    let username: String
    let password: String
    let salt: String
    let md5: String
    let sha1: String
    let sha256: String
}

struct DOB: Codable {
    let date: String // ISO8601 date string
    let age: Int
}

struct Registered: Codable {
    let date: String
    let age: Int
}

struct ID: Codable {
    let name: String
    let value: String?
}

struct Picture: Codable {
    let large: String
    let medium: String
    let thumbnail: String
}

class UsersAPICaller {
    
    var isPaginating = false
    
    func fetchApiUserData(paginaiton : Bool = false, completion : @escaping (Result<[User], Error>) -> Void) {
        if paginaiton {
            self.isPaginating = true
        }
        
        // URL for the Random User API.
        let urlString = "https://randomuser.me/api/?results=\(paginaiton ? 10 : 15)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) {data, response, error in
            if let error = error {
                completion(.failure(error))
                self.isPaginating = false
                return
            }
            
            guard let data = data else {
                self.isPaginating = false
                return
            }
            
            do {
                let userResponseData = try JSONDecoder().decode(UsersResponseModel.self, from: data)
                
                completion(.success(userResponseData.results))
                
            } catch {
                print(error)
                completion(.failure(error))
            }
            
            self.isPaginating = false
            
        }.resume()
    }
    
}
