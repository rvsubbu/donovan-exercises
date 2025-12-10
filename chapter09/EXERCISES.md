# Chapter 9: Concurrency with Shared Variables - Exercises

## Exercise 9.1: Advanced Mutex Patterns [HARD]
**Difficulty**: Hard  
**Topic**: Mutex optimization, lock-free programming, performance

Implement sophisticated synchronization patterns:
1. **Reader-Writer Lock** with writer preference and fairness guarantees
2. **Recursive Mutex** with proper ownership tracking
3. **Try-lock operations** with timeout and non-blocking variants
4. **Lock-free data structures** using atomic operations (stack, queue, linked list)
5. **Lock hierarchy** to prevent deadlocks in complex systems

```go
type RWMutexWithFairness struct {
    readers      int32
    writers      int32
    writerWaiting int32
    readerSem    chan struct{}
    writerSem    chan struct{}
    mutex        sync.Mutex
}

func (rw *RWMutexWithFairness) RLock() { /* implement fair reader locking */ }
func (rw *RWMutexWithFairness) RUnlock() { /* implement */ }
func (rw *RWMutexWithFairness) Lock() { /* implement writer preference */ }
func (rw *RWMutexWithFairness) Unlock() { /* implement */ }

type LockFreeStack[T any] struct {
    head unsafe.Pointer
}

func (s *LockFreeStack[T]) Push(item T) { /* implement using CAS */ }
func (s *LockFreeStack[T]) Pop() (T, bool) { /* implement using CAS */ }
```

**FAANG Interview Aspect**: How would you design a lock-free system for high-frequency trading where every nanosecond matters?

---

## Exercise 9.2: Memory Model and Atomic Operations [HARD]
**Difficulty**: Hard  
**Topic**: Memory ordering, atomic operations, memory barriers

Build a comprehensive atomic operations library:
1. **Atomic reference counting** with weak references
2. **Compare-and-swap loops** with backoff strategies
3. **Memory ordering** operations with acquire/release semantics
4. **Lock-free counters** with overflow detection
5. **Atomic bit operations** for flag management

```go
type AtomicReference[T any] struct {
    ptr unsafe.Pointer
}

func (ar *AtomicReference[T]) Load() *T { /* implement with acquire semantics */ }
func (ar *AtomicReference[T]) Store(val *T) { /* implement with release semantics */ }
func (ar *AtomicReference[T]) CompareAndSwap(old, new *T) bool { /* implement */ }
func (ar *AtomicReference[T]) Swap(new *T) *T { /* implement */ }

type AtomicCounter struct {
    value    int64
    overflow int64
}

func (ac *AtomicCounter) Add(delta int64) (int64, bool) { /* detect overflow */ }
func (ac *AtomicCounter) CompareAndSwap(old, new int64) bool { /* implement */ }
func (ac *AtomicCounter) Load() int64 { /* implement */ }

type AtomicBitSet struct {
    bits []uint64
    size int
}

func (abs *AtomicBitSet) Set(bit int) bool { /* atomically set bit, return previous value */ }
func (abs *AtomicBitSet) Clear(bit int) bool { /* atomically clear bit */ }
func (abs *AtomicBitSet) Test(bit int) bool { /* atomically test bit */ }
```

**FAANG Interview Aspect**: Explain the memory model implications of different atomic operations and their performance characteristics.

---

## Exercise 9.3: Advanced Race Detection and Prevention [HARD]
**Difficulty**: Hard  
**Topic**: Race conditions, detection, prevention strategies

Create a race condition analysis and prevention system:
1. **Custom race detector** using happens-before analysis
2. **Lock ordering** enforcement to prevent deadlocks
3. **Data race prevention** patterns and best practices
4. **Concurrent data structure** correctness verification
5. **Performance impact analysis** of synchronization primitives

```go
type RaceDetector struct {
    accesses map[uintptr]*AccessHistory
    locks    map[uintptr]*LockHistory
    threads  map[int]*ThreadState
    mutex    sync.RWMutex
}

type AccessHistory struct {
    reads  []Access
    writes []Access
}

type Access struct {
    threadID  int
    timestamp int64
    stackTrace []uintptr
}

func (rd *RaceDetector) RecordRead(addr uintptr, size int) { /* implement */ }
func (rd *RaceDetector) RecordWrite(addr uintptr, size int) { /* implement */ }
func (rd *RaceDetector) RecordLock(lock uintptr) { /* implement */ }
func (rd *RaceDetector) RecordUnlock(lock uintptr) { /* implement */ }
func (rd *RaceDetector) CheckRaces() []RaceReport { /* implement happens-before analysis */ }

type DeadlockDetector struct {
    lockOrder map[uintptr][]uintptr // lock -> locks held before it
    mutex     sync.RWMutex
}

func (dd *DeadlockDetector) RecordLockAcquisition(thread int, lock uintptr) error { /* detect potential deadlocks */ }
```

**FAANG Interview Aspect**: How would you implement race detection in a production system without significant performance overhead?

---

## Exercise 9.4: Cache-Coherent Data Structures [HARD]
**Difficulty**: Hard  
**Topic**: CPU cache optimization, NUMA awareness, false sharing

Design cache-aware concurrent data structures:
1. **Cache-line aligned** structures to prevent false sharing
2. **NUMA-aware** memory allocation and access patterns
3. **CPU cache optimization** for hot data paths
4. **Memory pool** with cache-conscious allocation strategies
5. **Scalable data structures** that perform well on many-core systems

```go
// Cache line size is typically 64 bytes
const CacheLineSize = 64

type alignas(CacheLineSize) CacheAlignedCounter struct {
    value int64
    _pad  [CacheLineSize - 8]byte
}

type NUMAMemoryPool struct {
    pools  []sync.Pool
    nodes  int
    affinity map[int]int // goroutine to NUMA node mapping
}

func (nmp *NUMAMemoryPool) Alloc(size int) unsafe.Pointer { /* NUMA-aware allocation */ }
func (nmp *NUMAMemoryPool) Free(ptr unsafe.Pointer) { /* return to appropriate pool */ }

type ScalableHashMap[K comparable, V any] struct {
    buckets []bucket[K, V]
    mask    uint64
}

type bucket[K comparable, V any] struct {
    mutex sync.RWMutex
    _pad1 [CacheLineSize - unsafe.Sizeof(sync.RWMutex{})]byte
    data  map[K]V
    _pad2 [CacheLineSize - unsafe.Sizeof(map[K]V{})]byte
}

func (shm *ScalableHashMap[K, V]) Get(key K) (V, bool) { /* minimize cache misses */ }
func (shm *ScalableHashMap[K, V]) Set(key K, value V) { /* distribute load across buckets */ }
```

**FAANG Interview Aspect**: How would you design data structures for systems with hundreds of CPU cores?

---

## Exercise 9.5: Advanced Synchronization Primitives [HARD]
**Difficulty**: Hard  
**Topic**: Custom synchronization, barriers, condition variables

Implement sophisticated synchronization mechanisms:
1. **Barrier synchronization** for parallel algorithms
2. **Condition variables** with broadcast and signal operations
3. **Semaphore** with fairness guarantees and resource limits
4. **Event system** with multiple waiters and complex conditions
5. **Phaser** for multi-phase parallel computations

```go
type Barrier struct {
    parties int
    count   int
    generation int
    mutex   sync.Mutex
    cond    *sync.Cond
}

func NewBarrier(parties int) *Barrier { /* implement */ }
func (b *Barrier) Wait() int { /* return arrival index */ }
func (b *Barrier) GetNumberWaiting() int { /* implement */ }
func (b *Barrier) Reset() { /* reset for reuse */ }

type ConditionVariable struct {
    waiters []chan struct{}
    mutex   sync.Mutex
}

func (cv *ConditionVariable) Wait(mu *sync.Mutex) { /* implement */ }
func (cv *ConditionVariable) Signal() { /* wake one waiter */ }
func (cv *ConditionVariable) Broadcast() { /* wake all waiters */ }

type Phaser struct {
    parties     []int  // parties in each phase
    arrived     []int  // arrived in each phase  
    phase       int
    terminated  bool
    mutex       sync.RWMutex
    conditions  []*sync.Cond
}

func (p *Phaser) Register() int { /* register new party */ }
func (p *Phaser) ArriveAndAwaitAdvance() int { /* arrive and wait for phase to complete */ }
func (p *Phaser) ArriveAndDeregister() int { /* arrive and deregister */ }
```

**FAANG Interview Aspect**: When would you implement custom synchronization primitives instead of using standard library ones?

---

## Exercise 9.6: Concurrent Algorithm Implementation [HARD]
**Difficulty**: Hard  
**Topic**: Parallel algorithms, work-stealing, load balancing

Implement parallel versions of classic algorithms:
1. **Parallel merge sort** with work-stealing and optimal granularity
2. **Parallel graph algorithms** (BFS, DFS, shortest path) with efficient load balancing
3. **Parallel matrix operations** with cache-aware tiling
4. **Parallel tree traversal** with dynamic work distribution
5. **MapReduce framework** with fault tolerance and intermediate result handling

```go
type WorkStealingPool struct {
    workers []Worker
    queues  []chan Task
    global  chan Task
}

type Worker struct {
    id       int
    queue    chan Task
    stealing bool
    pool     *WorkStealingPool
}

func (w *Worker) Run(ctx context.Context) {
    for {
        select {
        case task := <-w.queue:
            w.executeTask(task)
        case <-ctx.Done():
            return
        default:
            if task := w.steal(); task != nil {
                w.executeTask(task)
            } else {
                time.Sleep(time.Microsecond) // brief pause
            }
        }
    }
}

func ParallelMergeSort[T any](data []T, compare func(T, T) bool, maxGoroutines int) {
    threshold := len(data) / maxGoroutines
    if threshold < 1000 {
        threshold = 1000
    }
    
    parallelMergeSortInternal(data, compare, threshold)
}

func parallelMergeSortInternal[T any](data []T, compare func(T, T) bool, threshold int) {
    // Implement parallel divide-and-conquer with optimal cutoff
}
```

**FAANG Interview Aspect**: How would you optimize parallel algorithms for different hardware architectures (multi-core vs many-core)?

---

## Challenge Problems

### Challenge 9.A: Lock-Free Memory Allocator [EXPERT]
**Difficulty**: Expert  
**Topic**: Memory management, lock-free programming, performance

Implement a high-performance, lock-free memory allocator:
1. **Size classes** with different allocation strategies
2. **Thread-local caches** to minimize contention
3. **Lock-free free list** management
4. **Memory coalescing** without global synchronization
5. **NUMA awareness** for large-scale systems

**Performance Goals**:
- Zero allocation overhead in steady state
- Scales linearly with number of cores
- Sub-microsecond allocation/deallocation

### Challenge 9.B: Distributed Consensus Algorithm [EXPERT]
**Difficulty**: Expert  
**Topic**: Distributed systems, consensus, fault tolerance

Implement a production-grade distributed consensus algorithm:
1. **Raft consensus** with log replication and leader election
2. **Byzantine fault tolerance** for adversarial environments
3. **Dynamic membership** with configuration changes
4. **Snapshot and log compaction** for efficiency
5. **Multi-group consensus** for horizontal scaling

**System Design Challenges**:
- Handle network partitions and message reordering
- Ensure linearizability of operations
- Optimize for both latency and throughput

---

## Knowledge Validation Questions

1. **Memory Model**: Explain Go's memory model and how it relates to CPU memory models. What guarantees does Go provide?

2. **Atomic Operations**: What's the difference between atomic operations and mutex-based synchronization? When would you use each?

3. **False Sharing**: What is false sharing and how does it affect performance? How can you detect and prevent it?

4. **Lock-Free Programming**: What are the challenges of lock-free programming? What patterns help make it correct?

5. **Scalability**: How do different synchronization mechanisms scale with the number of cores? What are the bottlenecks?

---

## Performance Analysis Challenges

### Challenge 9.C: Synchronization Overhead Analysis
Benchmark different synchronization primitives:
- Mutex vs RWMutex vs atomic operations
- Channel-based vs mutex-based coordination
- Lock-free vs lock-based data structures

Analyze performance across different contention levels and core counts.

### Challenge 9.D: Memory Access Pattern Optimization
Optimize data structure access patterns:
- Sequential vs random access patterns
- Cache-friendly vs cache-hostile layouts
- NUMA-local vs cross-socket access

---

## Code Review Scenarios

### Scenario 9.A: Atomic Operations
```go
type Counter struct {
    value int64
}

func (c *Counter) Increment() {
    atomic.AddInt64(&c.value, 1)
}

func (c *Counter) Get() int64 {
    return c.value // Is this correct?
}

func (c *Counter) Reset() {
    c.value = 0 // Is this correct?
}
```

### Scenario 9.B: Lock Contention
```go
type Cache struct {
    mutex sync.RWMutex
    data  map[string]interface{}
}

func (c *Cache) Get(key string) interface{} {
    c.mutex.RLock()
    defer c.mutex.RUnlock()
    return c.data[key]
}

func (c *Cache) Set(key string, value interface{}) {
    c.mutex.Lock()
    defer c.mutex.Unlock()
    c.data[key] = value
}

func (c *Cache) GetAll() map[string]interface{} {
    c.mutex.RLock()
    defer c.mutex.RUnlock()
    result := make(map[string]interface{})
    for k, v := range c.data {
        result[k] = v
    }
    return result
}
```

### Scenario 9.C: Complex Synchronization
```go
type WorkQueue struct {
    queue   []Task
    mutex   sync.Mutex
    notEmpty *sync.Cond
    notFull  *sync.Cond
    capacity int
}

func (wq *WorkQueue) Put(task Task) {
    wq.mutex.Lock()
    defer wq.mutex.Unlock()
    
    for len(wq.queue) == wq.capacity {
        wq.notFull.Wait()
    }
    
    wq.queue = append(wq.queue, task)
    wq.notEmpty.Signal()
}

func (wq *WorkQueue) Take() Task {
    wq.mutex.Lock()
    defer wq.mutex.Unlock()
    
    for len(wq.queue) == 0 {
        wq.notEmpty.Wait()
    }
    
    task := wq.queue[0]
    wq.queue = wq.queue[1:]
    wq.notFull.Signal()
    return task
}
```

Analyze each scenario for correctness, performance, and potential improvements.