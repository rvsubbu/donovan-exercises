# Chapter 4: Composite Types - Exercises

## Exercise 4.1: Advanced Array Algorithms [HARD]
**Difficulty**: Hard  
**Topic**: Arrays, algorithm optimization, memory efficiency

Implement a collection of high-performance array algorithms:
1. **In-place array rotation** (rotate array by k positions with O(1) extra space)
2. **Dutch National Flag problem** (partition array with 3-way comparison)
3. **Maximum subarray sum** (Kadane's algorithm with position tracking)
4. **Array intersection/union** for sorted and unsorted arrays
5. **Sliding window maximum** with O(n) time complexity

```go
func rotateArray(arr []int, k int) { /* O(1) extra space */ }
func maxSubarraySum(arr []int) (sum, start, end int) { /* return sum and indices */ }
func slidingWindowMax(arr []int, k int) []int { /* O(n) time */ }
```

**FAANG Interview Aspect**: These are classic FAANG interview questions. Focus on optimal time/space complexity.

---

## Exercise 4.2: High-Performance Slice Operations [HARD]
**Difficulty**: Hard  
**Topic**: Slice internals, memory management, performance

Create an optimized slice library:
1. **Custom append** that minimizes allocations using growth strategies
2. **Slice deduplication** preserving order with O(n) time complexity  
3. **Multi-dimensional slice operations** (transpose, rotate, flatten)
4. **Memory pool** for slice reuse to avoid GC pressure
5. **Copy-on-write slices** for efficient immutable operations

Performance requirements:
- Handle slices with millions of elements
- Minimize garbage collection impact
- Provide memory usage statistics

**FAANG Interview Aspect**: How would you design slice operations for a high-throughput data processing system?

---

## Exercise 4.3: Advanced Map Implementations [HARD]
**Difficulty**: Hard  
**Topic**: Hash maps, data structures, concurrent access

Design and implement specialized map types:
1. **LRU Cache** with O(1) get/put operations and size limits
2. **Concurrent map** with fine-grained locking (better than sync.Map for specific use cases)
3. **Ordered map** that maintains insertion order
4. **Multimap** supporting multiple values per key
5. **Trie-based map** for prefix-based string operations

```go
type LRUCache struct {
    capacity int
    items    map[string]*Node
    head     *Node
    tail     *Node
}

func (c *LRUCache) Get(key string) (interface{}, bool) { /* O(1) */ }
func (c *LRUCache) Put(key string, value interface{}) { /* O(1) */ }
```

**FAANG Interview Aspect**: LRU Cache is a very common interview question. Focus on the double-linked list + hashmap approach.

---

## Exercise 4.4: Complex Struct Hierarchies [HARD]
**Difficulty**: Hard  
**Topic**: Struct embedding, composition, design patterns

Build a flexible document processing system:
1. **Document hierarchy** using struct embedding (Document -> TextDocument -> MarkdownDocument)
2. **Plugin system** using interface composition
3. **Serialization framework** with custom marshal/unmarshal logic
4. **Version management** for backward compatibility
5. **Memory-efficient storage** for large documents

Requirements:
- Support multiple document formats (JSON, XML, Binary)
- Implement visitor pattern for document processing
- Handle circular references in document graphs
- Provide diff/merge capabilities for documents

**FAANG Interview Aspect**: How would you design a system like Google Docs for collaborative editing?

---

## Exercise 4.5: Advanced JSON Processing [HARD]
**Difficulty**: Hard  
**Topic**: JSON manipulation, reflection, performance

Create a sophisticated JSON processing library:
1. **Streaming JSON parser** for large files (>1GB)
2. **JSONPath implementation** for complex queries
3. **Schema validation** with detailed error reporting
4. **JSON transformation** (map fields, apply functions, filter)
5. **Custom marshaling** for complex data types

Features:
- Handle deeply nested JSON (1000+ levels)
- Support JSON streaming with backpressure
- Implement JSON-to-struct code generation
- Provide JSON diffing and patching

**FAANG Interview Aspect**: How would you process JSON data in a high-throughput API gateway?

---

## Exercise 4.6: Graph Data Structures [HARD]
**Difficulty**: Hard  
**Topic**: Graphs, algorithms, optimization

Implement a comprehensive graph library:
1. **Multiple representations** (adjacency list, adjacency matrix, edge list)
2. **Graph algorithms** (DFS, BFS, Dijkstra, topological sort, cycle detection)
3. **Graph properties** (connectivity, planarity, bipartiteness)
4. **Serialization** for persistent storage
5. **Visualization** (DOT format generation)

```go
type Graph interface {
    AddVertex(id string) Vertex
    AddEdge(from, to string, weight float64) Edge
    ShortestPath(from, to string) ([]string, float64)
    HasCycle() bool
    TopologicalSort() ([]string, error)
}
```

**FAANG Interview Aspect**: Graph problems are extremely common in interviews. Focus on clean implementations and optimal algorithms.

---

## Challenge Problems

### Challenge 4.A: Memory-Efficient Data Structures [EXPERT]
**Difficulty**: Expert  
**Topic**: Memory optimization, custom allocators

Design ultra-memory-efficient data structures:
1. **Packed arrays** for boolean/small integer data
2. **Rope data structure** for efficient string concatenation
3. **B+ tree** implementation for disk-based storage
4. **Compressed sparse matrices** for scientific computing
5. **Memory pools** with different allocation strategies

**Optimization Goals**:
- 10x memory reduction compared to standard structures
- Cache-friendly memory layouts
- NUMA-aware allocation for large systems

### Challenge 4.B: Distributed Data Structures [EXPERT]
**Difficulty**: Expert  
**Topic**: Distributed systems, consistency, partitioning

Implement distributed versions of common data structures:
1. **Distributed hash table** with consistent hashing
2. **Distributed queue** with exactly-once delivery guarantees
3. **Conflict-free replicated data types (CRDTs)**
4. **Distributed locking** using consensus algorithms
5. **Sharded data structures** with automatic rebalancing

**System Design Challenges**:
- Handle network partitions gracefully
- Implement strong vs eventual consistency models
- Design for horizontal scaling

---

## Knowledge Validation Questions

1. **Slice vs Array**: When would you choose arrays over slices? What are the performance implications?

2. **Map Implementation**: How does Go's map implementation handle hash collisions? What are the performance characteristics?

3. **Memory Layout**: Explain the memory layout of structs with different field types and alignment requirements.

4. **Garbage Collection**: How do different composite types affect GC performance? Which patterns should you avoid?

5. **Interface Design**: How would you design interfaces for a data structure library that needs to be both flexible and performant?

---

## Algorithm Implementation Challenges

### Challenge 4.C: Advanced Sorting
Implement and benchmark:
- **Timsort** (Python's sorting algorithm)
- **Introsort** (C++ std::sort)
- **Radix sort** for integers
- **External sorting** for data larger than memory

### Challenge 4.D: Advanced Searching
Implement:
- **Ternary search trees** for string searching
- **Suffix arrays** with LCP (Longest Common Prefix) arrays
- **Bloom filters** with optimal hash function count
- **Cuckoo hashing** with configurable load factors

---

## Code Review Scenarios

### Scenario 4.A: Slice Growth
```go
func processItems(items []string) []string {
    var result []string
    for _, item := range items {
        if isValid(item) {
            result = append(result, item)
        }
    }
    return result
}
```

### Scenario 4.B: Map Access
```go
func getUserPreferences(userID string) map[string]interface{} {
    if prefs, ok := userPrefsMap[userID]; ok {
        return prefs
    }
    return make(map[string]interface{})
}
```

### Scenario 4.C: Struct Design
```go
type User struct {
    ID       string
    Name     string
    Email    string
    Password string
    Settings map[string]interface{}
    Created  time.Time
    Updated  time.Time
}
```

### Scenario 4.D: JSON Handling
```go
func parseConfig(data []byte) (*Config, error) {
    var config Config
    if err := json.Unmarshal(data, &config); err != nil {
        return nil, err
    }
    return &config, nil
}
```

Analyze each scenario for potential issues: performance, memory usage, correctness, and design patterns.