//
//  addTaskDelegate.swift
//  Session1
//
//  Created by Yuen, Teresa on 12/05/2025.
//

import Foundation

public protocol AddTaskDelegate {
    func addTask(title: String, dueDate: Date?)
}
