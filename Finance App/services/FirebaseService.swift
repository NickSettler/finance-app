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

protocol FirebaseIdentifiable : Hashable, Codable {
    var id: String { get set }
}

enum FirestoreCollection : String {
    case USER_DATA = "user-data"
    case AUTH_HISTORY = "auth-history"
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
}
