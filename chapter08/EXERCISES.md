# Chapter 8: Goroutines and Channels - Exercises

## Exercise 8.1: Advanced Channel Patterns [HARD]
**Difficulty**: Hard  
**Topic**: Channel patterns, buffering strategies, flow control

Implement sophisticated channel-based patterns:
1. **Rate limiter** using channels with burst capacity and sustained rate
2. **Semaphore** for resource pool management with timeout support
3. **Pipeline stages** with dynamic worker scaling and backpressure
4. **Fan-out/Fan-in** with error aggregation and partial failure handling
5. **Broadcast** channel that delivers messages to multiple subscribers

```go
type RateLimiter struct {
    rate       float64
    burst      int
    tokens     chan struct{}
    ticker     *time.Ticker
    done       chan struct{}
}

func NewRateLimiter(rate float64, burst int) *RateLimiter { /* implement */ }
func (rl *RateLimiter) Allow() bool { /* implement */ }
func (rl *RateLimiter) Wait(ctx context.Context) error { /* implement */ }
func (rl *RateLimiter) Close() error { /* implement */ }

type Semaphore struct {
    permits chan struct{}
}

func NewSemaphore(capacity int) *Semaphore { /* implement */ }
func (s *Semaphore) Acquire(ctx context.Context) error { /* implement */ }
func (s *Semaphore) Release() { /* implement */ }
func (s *Semaphore) TryAcquire() bool { /* implement */ }
```

**FAANG Interview Aspect**: How would you implement rate limiting in a distributed system with multiple instances?

---

## Exercise 8.2: Advanced Worker Pool Patterns [HARD]
**Difficulty**: Hard  
**Topic**: Worker pools, dynamic scaling, load balancing

Build a sophisticated worker pool system:
1. **Dynamic scaling** based on queue depth and worker utilization
2. **Priority queues** with different processing guarantees
3. **Graceful shutdown** with job completion and timeout handling
4. **Worker health monitoring** with automatic recovery
5. **Load balancing** across workers with different capabilities

```go
type WorkerPool struct {
    minWorkers    int
    maxWorkers    int
    currentWorkers int
    jobQueue      chan Job
    workers       []Worker
    metrics       *PoolMetrics
    shutdownCh    chan struct{}
}

type Job interface {
    Priority() int
    Execute(ctx context.Context) error
    Timeout() time.Duration
    Retryable() bool
}

type Worker interface {
    ID() string
    Process(ctx context.Context, job Job) error
    Health() WorkerHealth
    Shutdown(ctx context.Context) error
}

func (wp *WorkerPool) Submit(job Job) error { /* implement */ }
func (wp *WorkerPool) Scale(targetWorkers int) error { /* implement */ }
func (wp *WorkerPool) Shutdown(ctx context.Context) error { /* implement */ }
func (wp *WorkerPool) Metrics() PoolMetrics { /* implement */ }
```

**FAANG Interview Aspect**: How would you design a worker pool that can handle millions of jobs per second?

---

## Exercise 8.3: Advanced Select Statement Patterns [HARD]
**Difficulty**: Hard  
**Topic**: Select statements, timeouts, channel coordination

Implement complex coordination patterns using select:
1. **Multi-channel coordinator** that aggregates results from multiple sources
2. **Circuit breaker** with different failure modes and recovery strategies
3. **Timeout ladder** with escalating timeout handling
4. **Channel multiplexer** that routes messages based on content
5. **Distributed consensus** using channels (simplified Raft-like algorithm)

```go
type CircuitBreaker struct {
    maxFailures  int
    resetTimeout time.Duration
    state        CircuitState
    failures     int
    lastFailure  time.Time
    mutex        sync.RWMutex
}

type CircuitState int

const (
    StateClosed CircuitState = iota
    StateOpen
    StateHalfOpen
)

func (cb *CircuitBreaker) Call(ctx context.Context, fn func() error) error { /* implement */ }
func (cb *CircuitBreaker) State() CircuitState { /* implement */ }

type TimeoutLadder struct {
    timeouts []time.Duration
    attempt  int
}

func (tl *TimeoutLadder) NextTimeout() time.Duration { /* implement */ }
func (tl *TimeoutLadder) Reset() { /* implement */ }
```

**FAANG Interview Aspect**: How would you handle cascading failures in a microservices architecture?

---

## Exercise 8.4: Channel-Based Data Structures [HARD]
**Difficulty**: Hard  
**Topic**: Concurrent data structures, channel-based coordination

Implement concurrent data structures using channels:
1. **Concurrent queue** with multiple producers/consumers and ordering guarantees
2. **Channel-based map** with concurrent reads/writes and consistent snapshots
3. **Distributed cache** using channels for coordination across nodes
4. **Event sourcing** system with channel-based event delivery
5. **Message router** with topic-based routing and subscriber management

```go
type ConcurrentQueue[T any] struct {
    items    chan T
    capacity int
    closed   int32
}

func NewConcurrentQueue[T any](capacity int) *ConcurrentQueue[T] { /* implement */ }
func (cq *ConcurrentQueue[T]) Enqueue(item T) error { /* implement */ }
func (cq *ConcurrentQueue[T]) Dequeue(ctx context.Context) (T, error) { /* implement */ }
func (cq *ConcurrentQueue[T]) Close() error { /* implement */ }
func (cq *ConcurrentQueue[T]) Len() int { /* implement */ }

type ChannelMap[K comparable, V any] struct {
    ops chan mapOp[K, V]
    done chan struct{}
}

type mapOp[K comparable, V any] struct {
    operation OpType
    key       K
    value     V
    result    chan mapResult[V]
}

func NewChannelMap[K comparable, V any]() *ChannelMap[K, V] { /* implement */ }
func (cm *ChannelMap[K, V]) Get(key K) (V, bool) { /* implement */ }
func (cm *ChannelMap[K, V]) Set(key K, value V) { /* implement */ }
func (cm *ChannelMap[K, V]) Delete(key K) bool { /* implement */ }
```

**FAANG Interview Aspect**: When would you choose channel-based data structures over traditional mutex-based approaches?

---

## Exercise 8.5: Goroutine Lifecycle Management [HARD]
**Difficulty**: Hard  
**Topic**: Goroutine coordination, cancellation, resource cleanup

Build a comprehensive goroutine management system:
1. **Goroutine pool** with lifecycle tracking and resource limits
2. **Cancellation propagation** with graceful shutdown sequences
3. **Error aggregation** from multiple goroutines with context
4. **Resource cleanup** coordination across goroutine hierarchies
5. **Deadlock detection** and prevention mechanisms

```go
type GoroutineManager struct {
    active    sync.WaitGroup
    ctx       context.Context
    cancel    context.CancelFunc
    errors    chan error
    maxGoroutines int
    semaphore chan struct{}
}

func NewGoroutineManager(ctx context.Context, maxGoroutines int) *GoroutineManager { /* implement */ }

func (gm *GoroutineManager) Go(fn func(ctx context.Context) error) error { /* implement */ }
func (gm *GoroutineManager) Wait() error { /* implement */ }
func (gm *GoroutineManager) Cancel() { /* implement */ }
func (gm *GoroutineManager) Errors() <-chan error { /* implement */ }

type SupervisorTree struct {
    name     string
    children map[string]*SupervisorTree
    restart  RestartStrategy
    workers  []Worker
}

type RestartStrategy int

const (
    RestartNever RestartStrategy = iota
    RestartAlways
    RestartOnFailure
)

func (st *SupervisorTree) Start(ctx context.Context) error { /* implement */ }
func (st *SupervisorTree) Supervise(worker Worker, strategy RestartStrategy) { /* implement */ }
```

**FAANG Interview Aspect**: How would you design a fault-tolerant system that can recover from individual component failures?

---

## Exercise 8.6: High-Performance Channel Operations [HARD]
**Difficulty**: Hard  
**Topic**: Channel performance, memory optimization, batch processing

Optimize channel operations for high-throughput scenarios:
1. **Batch channel operations** to reduce synchronization overhead
2. **Lock-free ring buffers** as channel alternatives for specific use cases
3. **Channel pooling** to reduce allocation overhead
4. **Memory-mapped channels** for inter-process communication
5. **NUMA-aware channel** placement and access patterns

```go
type BatchChannel[T any] struct {
    ch       chan []T
    batchSize int
    buffer   []T
    mutex    sync.Mutex
}

func NewBatchChannel[T any](capacity, batchSize int) *BatchChannel[T] { /* implement */ }
func (bc *BatchChannel[T]) Send(item T) error { /* implement */ }
func (bc *BatchChannel[T]) Receive() ([]T, error) { /* implement */ }
func (bc *BatchChannel[T]) Flush() error { /* implement */ }

type RingBuffer[T any] struct {
    data     []T
    head     uint64
    tail     uint64
    mask     uint64
    size     int
}

func NewRingBuffer[T any](size int) *RingBuffer[T] { /* size must be power of 2 */ }
func (rb *RingBuffer[T]) Push(item T) bool { /* lock-free */ }
func (rb *RingBuffer[T]) Pop() (T, bool) { /* lock-free */ }
```

**FAANG Interview Aspect**: How would you optimize communication patterns in a high-frequency trading system?

---

## Challenge Problems

### Challenge 8.A: Distributed Channel System [EXPERT]
**Difficulty**: Expert  
**Topic**: Distributed systems, network communication, consistency

Build a distributed channel system:
1. **Network-transparent channels** that work across process boundaries
2. **Consistency guarantees** for message ordering and delivery
3. **Partition tolerance** with automatic reconnection and recovery
4. **Load balancing** across multiple channel brokers
5. **Monitoring and observability** for distributed channel operations

**System Design Challenges**:
- How do you maintain channel semantics across network boundaries?
- How do you handle node failures and network partitions?
- How do you implement backpressure in a distributed setting?

### Challenge 8.B: Real-time Event Processing Engine [EXPERT]
**Difficulty**: Expert  
**Topic**: Stream processing, event handling, low latency

Implement a low-latency event processing engine:
1. **Stream processing pipelines** with microsecond latencies
2. **Event correlation** across multiple streams with time windows
3. **Complex event patterns** detection and alerting
4. **Hot/cold event paths** with different processing guarantees
5. **Exactly-once processing** semantics with failure recovery

**Performance Requirements**:
- Process millions of events per second
- Sub-millisecond end-to-end latency
- 99.99% availability with graceful degradation

---

## Knowledge Validation Questions

1. **Channel Semantics**: Explain the difference between buffered and unbuffered channels. How does buffer size affect program behavior?

2. **Goroutine Scheduling**: How does the Go scheduler work? What factors affect goroutine scheduling decisions?

3. **Memory Model**: Explain Go's memory model in the context of channels and goroutines. When are memory operations ordered?

4. **Deadlock Prevention**: What patterns can lead to deadlocks in concurrent Go programs? How do you prevent them?

5. **Performance Trade-offs**: When would you choose channels vs mutexes for synchronization? What are the performance implications?

---

## Concurrency Pattern Implementations

### Challenge 8.C: Producer-Consumer Variations
Implement different producer-consumer patterns:
- Multiple producers, single consumer
- Single producer, multiple consumers  
- Multiple producers, multiple consumers with work stealing
- Priority-based consumption

### Challenge 8.D: Synchronization Primitives
Implement synchronization primitives using channels:
- Mutex using channels
- Condition variables using channels
- Reader-writer locks using channels
- Barriers using channels

---

## Code Review Scenarios

### Scenario 8.A: Worker Pool
```go
func processJobs(jobs <-chan Job, results chan<- Result) {
    for job := range jobs {
        result := processJob(job)
        results <- result
    }
}

func main() {
    jobs := make(chan Job, 100)
    results := make(chan Result, 100)
    
    // Start workers
    for i := 0; i < 10; i++ {
        go processJobs(jobs, results)
    }
    
    // Send jobs
    for _, job := range allJobs {
        jobs <- job
    }
    close(jobs)
    
    // Collect results
    for i := 0; i < len(allJobs); i++ {
        result := <-results
        handleResult(result)
    }
}
```

### Scenario 8.B: Select with Timeout
```go
func fetchWithTimeout(url string, timeout time.Duration) ([]byte, error) {
    resultCh := make(chan []byte)
    errorCh := make(chan error)
    
    go func() {
        resp, err := http.Get(url)
        if err != nil {
            errorCh <- err
            return
        }
        defer resp.Body.Close()
        
        data, err := ioutil.ReadAll(resp.Body)
        if err != nil {
            errorCh <- err
            return
        }
        
        resultCh <- data
    }()
    
    select {
    case data := <-resultCh:
        return data, nil
    case err := <-errorCh:
        return nil, err
    case <-time.After(timeout):
        return nil, fmt.Errorf("timeout")
    }
}
```

### Scenario 8.C: Channel Coordination
```go
type Coordinator struct {
    workers []chan<- Work
    results <-chan Result
    done    chan struct{}
}

func (c *Coordinator) Start() {
    go func() {
        for {
            select {
            case result := <-c.results:
                c.handleResult(result)
            case <-c.done:
                return
            }
        }
    }()
}

func (c *Coordinator) Stop() {
    close(c.done)
}
```

Analyze each scenario for correctness, potential races, resource leaks, and performance issues.