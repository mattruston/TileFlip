//
//  PriorityQueue.swift
//  SlidePuzzle
//
//  Created by Matthew Ruston on 2/24/17.
//  Copyright © 2017 Matt. All rights reserved.
//
//  Some code modified from: https://github.com/davecom/SwiftPriorityQueue

/// Priority Queue that orders items from highest cost to lowest
class PriorityQueue<T: Any> {
    fileprivate var heap: [(T, Double)] = []
    
    
    //MARK: - Public
    
    init() {
        //empty implementation
    }
    
    var count: Int {
        return heap.count
    }
    
    func push(item: T, priority: Double) {
        let entry = (item, priority)
        heap.append(entry)
        swim(count - 1)
    }
    
    func pop() -> T? {
        if count == 0 { return nil }
        if count == 1 { return heap.removeFirst().0 }
        
        heapSwap(a: 0, b: heap.count - 1)
//        swap(&heap[0], &heap[heap.count - 1])
        
        let item = heap.removeLast().0
        sink(0)
        
        return item
    }
    
    
    //MARK: - Private methods
    
    fileprivate func sink(_ index: Int) {
        var index = index
        while 2 * index + 1 < count {
            
            var j = 2 * index + 1
            
            if j < (heap.count - 1) && (heap[j].1 > heap[j + 1].1) {
                j += 1
            }
            
            if !(heap[index].1 > heap[j].1) {
                break
            }
            
//            swap(&heap[index], &heap[j])
            heapSwap(a: index, b: j)
            index = j
        }
    }
    
    fileprivate func swim(_ index: Int) {
        var index = index
        while index > 0 && (heap[(index - 1) / 2].1 > heap[index].1) {
//            swap(&heap[(index - 1) / 2], &heap[index])
            heapSwap(a: (index - 1) / 2, b: index)
            index = (index - 1) / 2
        }
    }
    
    //Started getting simultaneous access error when using actual swap, this is quick fix
    fileprivate func heapSwap(a: Int, b: Int) {
        let temp = heap[a]
        heap[a] = heap[b]
        heap[b] = temp
    }
}


//MARK: - Update function available if T is equatable
extension PriorityQueue where T: Equatable {
    func update(item: T, cost: Double) {
        for x in 0..<count {
            let i = heap[x].0
            if i == item {
                heap.remove(at: x)
                push(item: item, priority: cost)
                return
            }
        }
    }
}



