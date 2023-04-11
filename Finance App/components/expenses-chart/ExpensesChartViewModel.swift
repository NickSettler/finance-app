//
//  ExpensesChartViewModel.swift
//  Finance App
//
//  Created by Никита Моисеев on 11.04.2023.
//

import Foundation
import SwiftUI
import Charts
import FirebaseAuth
import FirebaseFirestore

@MainActor class ExpensesChartViewModel : ObservableObject {
    @Published var transactions: [Transaction] = []
    
    @Published var selectedIndex: Int?
    
    func handleAppear() {
        Task {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            do {
//                let empty: [Date: Double] = [:]
                self.transactions = try await TransactionService.getTransactions(for: uid).get()
                    .map {
                        return .init(id: $0.id!, amount: abs($0.amount), timestamp: $0.timestamp)
                    }
                    .sorted { $0.timestamp.dateValue() > $1.timestamp.dateValue() }
//                    .reduce(into: empty) { acc, cur in
//                        let components = Calendar.current.dateComponents([.year, .month, .day, .hour], from: cur.timestamp.dateValue())
//                        let date = Calendar.current.date(from: components)!
//                        let existing = acc[date] ?? 0
//                        acc[date] = existing + cur.amount
//                    }
            }
            catch {
                print(error)
            }
        }
    }
    
    func handleDragChange(chart: ChartProxy, geometry: GeometryProxy, value: DragGesture.Value) {
        let currentX = value.location.x - geometry[chart.plotAreaFrame].origin.x
        guard currentX >= 0, currentX < chart.plotAreaSize.width else {
            return
        }
        
        guard let index = chart.value(atX: currentX, as: Int.self) else {
            return
        }
        
        selectedIndex = index
        
        print(index)
    }
    
    func handleDragEnd() {
        selectedIndex = nil
    }
}
