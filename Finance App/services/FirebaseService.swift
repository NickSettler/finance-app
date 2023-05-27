//
//  FirebaseService.swift
//  Finance App
//
//  Created by Никита Моисеев on 25.03.2023.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol FirebaseIdentifiable : Hashable, Codable, Decodable {
    var id: String? { get set }
}

extension FirebaseIdentifiable {
    func post(to collection: String) async -> Result<Self, Error> {
        return await FirebaseService.shared.post(self, to: collection)
    }
    
    func put(to collection: String) async -> Result<Self, Error> {
        return await FirebaseService.shared.put(self, to: collection)
    }
}

enum FirestoreCollection : String {
    case USER_DATA = "user-data"
    case AUTH_HISTORY = "auth-history"
    case CATEGORIES = "categories"
    case TRANSACTIONS = "transactions"
}

enum FirestoreError : Error {
    case notFound
}

class FirebaseService {
    static let shared = FirebaseService()
    let database = Firestore.firestore()
    
    init() {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
        database.settings = settings
    }
}

extension FirebaseService {
    func getOne<T: Decodable>(of type: T.Type, with query: Query) async -> Result<T, Error> {
        do {
            let querySnapshot = try await query.getDocuments()
            if let document = querySnapshot.documents.first {
                let data = try document.data(as: T.self)
                return .success(data)
            } else {
                print("Warning: \(#function) document not found")
                return .failure(FirestoreError.notFound)
            }
        } catch let error {
            print("Error: \(#function) couldn't access snapshot, \(error)")
            return .failure(error)
        }
    }
    
    func getOne<T: Decodable>(of type: T.Type, with collection: CollectionReference, by id: String) async -> Result<T, Error> {
        do {
            let document = try await collection.document(id).getDocument()
            
            let data = try document.data(as: T.self)
            return .success(data)
        } catch let error {
            print("Error: \(#function) couldn't access snapshot, \(error)")
            return .failure(error)
        }
    }
    
    func getMany<T: Decodable>(of type: T.Type, with query: Query) async -> Result<[T], Error> {
        do {
            var response: [T] = []
            let querySnapshot = try await query.getDocuments()
            
            for document in querySnapshot.documents {
                do {
                    let data = try document.data(as: T.self)
                    response.append(data)
                } catch let error {
                    print("Error: \(#function) document(s) not decoded from data, \(error)")
                    return .failure(error)
                }
            }
            return .success(response)
        } catch let error {
            print("Error: couldn't access snapshot, \(error)")
            return .failure(error)
        }
    }
    
    func post<T: FirebaseIdentifiable>(_ value: T, to collection: String) async -> Result<T, Error> {
        let ref = database.collection(collection).document()
        var toWrite: T = value
        toWrite.id = ref.documentID
        
        do {
            try ref.setData(from: toWrite)
            return .success(toWrite)
        } catch {
            print("Error: \(#function) in collection: \(collection), \(error)")
            return .failure(error)
        }
    }
    
    func put<T: FirebaseIdentifiable>(_ value: T, to collection: String) async -> Result<T, Error> {
        guard let uid = value.id else {
            return .failure("No id value in \(value)")
        }
        
        let ref = database.collection(collection).document(uid)
        
        do {
            try ref.setData(from: value)
            return .success(value)
        } catch {
            print("Error: \(#function) in \(collection) for id: \(uid), \(error)")
            return .failure(error)
        }
    }
}
