//
//  TaskQueue.swift
//  BusinessNumberValidate
//
//  Created by 일하는석찬 on 12/5/24.
//

import Foundation

final class TaskQueue {
    private var tasks: [NetworkTask] = []
    private let lock = NSLock()

    func addTask(_ task: NetworkTask) {
        lock.lock()
        tasks.append(task)
        lock.unlock()
    }

    func fetchNextTask() -> NetworkTask? {
        lock.lock()
        defer { lock.unlock() }
        return tasks.isEmpty ? nil : tasks.removeFirst()
    }

    var isEmpty: Bool {
        lock.lock()
        defer { lock.unlock() }
        return tasks.isEmpty
    }
}
