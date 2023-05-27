//
//  CategoryService.swift
//  Finance App
//
//  Created by Никита Моисеев on 29.03.2023.
//

import Foundation
import Firebase

struct CategoryService {
    static func getCategories(for id: String) async -> Result<[Category], Error> {
        do {
            let query = FirebaseService.shared.database
                .collection(FirestoreCollection.USER_DATA.rawValue)
                .document(id)
                .collection(FirestoreCollection.CATEGORIES.rawValue)
            
            let data = try await FirebaseService.shared.getMany(of: Category.self, with: query).get()
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
    
    static func getCategory(for id: String, categoryId cat_id: String) async -> Result<Category, Error> {
        do {
            let query = FirebaseService.shared.database
                .collection(FirestoreCollection.USER_DATA.rawValue)
                .document(id)
                .collection(FirestoreCollection.CATEGORIES.rawValue)
            
            let data = try await FirebaseService.shared.getOne(of: Category.self, with: query, by: cat_id).get()
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
    
    static func getPopularCategories(for id: String) async -> Result<Array<(key: Category, value: Int)>, Error> {
        do {
            let transactions = try await TransactionService.getTransactions(for: id).get()
            let categories = try await CategoryService.getCategories(for: id).get()
            
            let data: [Category: Int] = transactions.reduce(into: [:]) { result, transaction in
                guard let category = categories.first(where: { $0.id == transaction.category.documentID }) else { return }
                
                result[category, default: 0] += 1
            }
            
            return .success(
                data.sorted { $0.value > $1.value }
            )
        } catch {
            return .failure(error)
        }
    }
}
