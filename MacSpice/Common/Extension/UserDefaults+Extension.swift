//
//  UserDefaults+Extension.swift
//  IosFreeRDP
//
//  Created by y2k on 2021/04/09.
//


public enum UserDefaultsKeyEnum: String {
    case menuLock = "MenuLock"
}

public enum UserDefaultsKeyEnumCustom: String {
    case folderSharing = "FolderSharing"
}

extension UserDefaults {
    
    //MARK: - public
    // del
    public class func removeForKey(keyEnum: UserDefaultsKeyEnum) {
        self.removeForKey(keyEnum.rawValue)
    }
    
    // get
    public class func objectForKey<T: Codable>(type: T.Type, keyEnum: UserDefaultsKeyEnum) -> T? {
        return self.objectForKey(type, keyEnum.rawValue)
    }
    
    // set
    public class func setObjectForKey<T: Codable>(object: T?, keyEnum: UserDefaultsKeyEnum) {
        self.setObjectForKey(object: object, keyEnum.rawValue)
    }
    
    public class func objectForKeyCustom<T: Codable>(type: T.Type, keyEnum: UserDefaultsKeyEnumCustom) -> T? {
        let key = keyEnum.rawValue
        guard let result = UserDefaults.standard.value(forKey: key) as? Data else {
            return nil
        }
        return try? PropertyListDecoder().decode(type, from: result)
    }
    
    public class func setObjectForKeyCustom<T: Codable>(object: T?, keyEnum: UserDefaultsKeyEnumCustom) {
        let key = keyEnum.rawValue
        do {
            let jsonData = try PropertyListEncoder().encode(object)
            UserDefaults.standard.set(jsonData, forKey: key)
        } catch (let error) {
            print("setObjectForKey fail, \(error.localizedDescription)")
        }
        UserDefaults.standard.synchronize()
    }
    
    //MARK: - private
    private class func removeForKey(_ key: String?) {
        guard let key = key else {
            return
        }
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    private class func objectForKey<T: Codable>(_ type: T.Type, _ key: String?) -> T? {
        guard let key = key else {
            return nil
        }
        
        do {
            return try UserDefaults.standard.get(type: type, forKey: key)
        } catch (let error) {
            print("objectForKey fail, \(error.localizedDescription)")
        }
        
        return nil
    }

    private class func setObjectForKey<T: Codable>(object: T?, _ key: String?) {
        guard let object = object, let key = key else {
            return
        }

        do {
            try UserDefaults.standard.set(object: object, forKey:key)
            UserDefaults.standard.synchronize()
        } catch (let error) {
            print("setObjectForKey fail, \(error.localizedDescription)")
        }
    }
    
    /// Set Codable object into UserDefaults
    ///
    /// - Parameters:
    ///   - object: Codable Object
    ///   - forKey: Key string
    /// - Throws: UserDefaults Error
    private func set<T: Codable>(object: T, forKey: String) throws {
        let jsonData = try JSONEncoder().encode(object)
        set(jsonData, forKey: forKey)
    }
    
    /// Get Codable object into UserDefaults
    ///
    /// - Parameters:
    ///   - object: Codable Object
    ///   - forKey: Key string
    /// - Throws: UserDefaults Error
    private func get<T: Codable>(type: T.Type, forKey: String) throws -> T? {
        guard let result = value(forKey: forKey) as? Data else {
            return nil
        }
        return try JSONDecoder().decode(type, from: result)
    }
}
