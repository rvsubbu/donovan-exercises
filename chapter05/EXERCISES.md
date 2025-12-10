# Chapter 5: Functions - Exercises

## Exercise 5.1: Advanced Function Design Patterns [HARD]
**Difficulty**: Hard  
**Topic**: Higher-order functions, closures, functional programming

Implement a functional programming library with:
1. **Function composition** and pipelining
2. **Currying and partial application**
3. **Memoization** for expensive functions with LRU eviction
4. **Retry mechanisms** with exponential backoff and jitter
5. **Circuit breaker pattern** implementation

```go
type Func[T any, U any] func(T) U

func Compose[T, U, V any](f Func[U, V], g Func[T, U]) Func[T, V] { /* implement */ }
func Memoize[T comparable, U any](f func(T) U, maxSize int) func(T) U { /* implement */ }
func WithRetry[T any](f func() (T, error), maxRetries int, backoff time.Duration) func() (T, error) { /* implement */ }
```

**FAANG Interview Aspect**: How would you implement a distributed circuit breaker across microservices?

---

## Exercise 5.2: Variadic Functions and Reflection [HARD]
**Difficulty**: Hard  
**Topic**: Variadic functions, reflection, type safety

Create a type-safe query builder:
1. **Dynamic SQL generation** with parameter binding
2. **Type checking** at runtime for query parameters
3. **Support for complex joins** and subqueries
4. **Query optimization** hints and index suggestions
5. **Connection pooling** integration

```go
type QueryBuilder struct { /* implement */ }

func (qb *QueryBuilder) Select(columns ...string) *QueryBuilder { /* implement */ }
func (qb *QueryBuilder) Where(condition string, args ...interface{}) *QueryBuilder { /* implement */ }
func (qb *QueryBuilder) Join(table, on string) *QueryBuilder { /* implement */ }
func (qb *QueryBuilder) Build() (query string, args []interface{}) { /* implement */ }
```

**FAANG Interview Aspect**: How would you prevent SQL injection while maintaining performance?

---

## Exercise 5.3: Advanced Error Handling Strategies [HARD]
**Difficulty**: Hard  
**Topic**: Error handling, context propagation, observability

Design a comprehensive error handling system:
1. **Error wrapping** with stack traces and context
2. **Error classification** (retriable, permanent, timeout, etc.)
3. **Error aggregation** for batch operations
4. **Error rate limiting** and alerting
5. **Error recovery** with fallback mechanisms

```go
type ErrorType int

const (
    ErrorTypeTemporary ErrorType = iota
    ErrorTypePermanent
    ErrorTypeTimeout
    ErrorTypeRateLimit
)

type EnhancedError interface {
    error
    Type() ErrorType
    Unwrap() error
    StackTrace() []uintptr
    Context() map[string]interface{}
}

func NewError(err error, errorType ErrorType, context map[string]interface{}) EnhancedError { /* implement */ }
```

**FAANG Interview Aspect**: How would you design error handling for a distributed system with multiple failure modes?

---

## Exercise 5.4: Function Middleware and Decorators [HARD]
**Difficulty**: Hard  
**Topic**: Function decoration, aspect-oriented programming

Implement a middleware system for functions:
1. **Logging middleware** with configurable levels and formats
2. **Authentication and authorization** decorators
3. **Rate limiting** per function or per user
4. **Metrics collection** (latency, throughput, error rates)
5. **Caching middleware** with different strategies

```go
type Middleware func(http.HandlerFunc) http.HandlerFunc

func WithLogging(logger Logger) Middleware { /* implement */ }
func WithAuth(authProvider AuthProvider) Middleware { /* implement */ }
func WithRateLimit(rps float64) Middleware { /* implement */ }
func WithMetrics(registry MetricsRegistry) Middleware { /* implement */ }
func WithCache(cache Cache, ttl time.Duration) Middleware { /* implement */ }

// Chain multiple middleware together
func Chain(middlewares ...Middleware) Middleware { /* implement */ }
```

**FAANG Interview Aspect**: How would you implement cross-cutting concerns in a microservices architecture?

---

## Exercise 5.5: Anonymous Functions and Goroutine Patterns [HARD]
**Difficulty**: Hard  
**Topic**: Anonymous functions, goroutines, concurrency patterns

Implement advanced concurrency patterns:
1. **Worker pool** with dynamic sizing and backpressure
2. **Fan-out/Fan-in** pattern with error aggregation
3. **Pipeline processing** with stages and buffering
4. **Scatter-gather** pattern for parallel processing
5. **Timeout and cancellation** handling

```go
type WorkerPool struct {
    minWorkers  int
    maxWorkers  int
    queue       chan func()
    results     chan interface{}
    errors      chan error
}

func (wp *WorkerPool) Submit(task func() (interface{}, error)) <-chan interface{} { /* implement */ }
func (wp *WorkerPool) Close() error { /* implement */ }

// Fan-out/Fan-in pattern
func FanOut[T any](input <-chan T, workers int, processor func(T) (interface{}, error)) <-chan interface{} { /* implement */ }
```

**FAANG Interview Aspect**: How would you handle backpressure in a high-throughput data processing pipeline?

---

## Exercise 5.6: Function Performance Optimization [HARD]
**Difficulty**: Hard  
**Topic**: Performance profiling, optimization techniques

Create a function optimization framework:
1. **Automatic benchmarking** with statistical analysis
2. **Memory allocation tracking** per function
3. **CPU profiling** with hotspot identification
4. **Function call graph** generation
5. **Optimization suggestions** based on patterns

```go
type FunctionProfiler struct {
    profiles map[string]*Profile
}

type Profile struct {
    CallCount     int64
    TotalDuration time.Duration
    Allocations   int64
    AllocBytes    int64
    Hotspots      []Hotspot
}

func (fp *FunctionProfiler) Profile(name string, fn func()) interface{} { /* implement */ }
func (fp *FunctionProfiler) Report() ProfileReport { /* implement */ }
```

**FAANG Interview Aspect**: How would you optimize function performance in a latency-critical system?

---

## Challenge Problems

### Challenge 5.A: Functional Reactive Programming [EXPERT]
**Difficulty**: Expert  
**Topic**: Functional programming, reactive streams, event processing

Implement a reactive programming framework:
1. **Observable streams** with operators (map, filter, reduce)
2. **Event-driven architecture** with backpressure handling
3. **Time-based operations** (throttle, debounce, window)
4. **Error handling** and stream recovery
5. **Hot and cold observables** with subscription management

```go
type Observable[T any] interface {
    Subscribe(observer Observer[T]) Subscription
    Map[U any](mapper func(T) U) Observable[U]
    Filter(predicate func(T) bool) Observable[T]
    Reduce(accumulator func(T, T) T) Observable[T]
}
```

### Challenge 5.B: Distributed Function Execution [EXPERT]
**Difficulty**: Expert  
**Topic**: Distributed computing, serialization, fault tolerance

Build a distributed function execution system:
1. **Function serialization** across network boundaries
2. **Load balancing** across multiple execution nodes
3. **Fault tolerance** with automatic failover
4. **Result caching** and deduplication
5. **Resource management** and quotas

**System Design Challenges**:
- How to serialize function closures?
- How to handle node failures during execution?
- How to implement distributed locks for function coordination?

---

## Knowledge Validation Questions

1. **Function Values**: Explain the memory implications of storing function values. How do closures affect garbage collection?

2. **Stack vs Heap**: When do function parameters and local variables escape to the heap? How can you minimize heap allocations?

3. **Function Types**: How does Go's function type system enable higher-order programming? What are the limitations?

4. **Error Propagation**: Design an error handling strategy that provides good debugging information while maintaining performance.

5. **Concurrency Patterns**: When would you choose different concurrency patterns (worker pools vs fan-out/fan-in vs pipelines)?

---

## Performance Benchmarking Challenges

### Challenge 5.C: Function Call Overhead
Benchmark the overhead of:
- Direct function calls
- Interface method calls
- Function pointer calls
- Reflection-based calls

For different scenarios (hot path vs cold path).

### Challenge 5.D: Closure Performance
Compare performance of:
- Functions with no captures
- Functions capturing by value
- Functions capturing by reference
- Functions with multiple captures

---

## Code Review Scenarios

### Scenario 5.A: Error Handling
```go
func processData(data []byte) (Result, error) {
    if len(data) == 0 {
        return Result{}, errors.New("empty data")
    }
    
    result, err := parseData(data)
    if err != nil {
        return Result{}, fmt.Errorf("parse error: %v", err)
    }
    
    if err := validateResult(result); err != nil {
        return Result{}, fmt.Errorf("validation error: %v", err)
    }
    
    return result, nil
}
```

### Scenario 5.B: Function Design
```go
func calculateMetrics(data []float64, operations ...string) map[string]float64 {
    results := make(map[string]float64)
    
    for _, op := range operations {
        switch op {
        case "mean":
            results[op] = calculateMean(data)
        case "median":
            results[op] = calculateMedian(data)
        case "stddev":
            results[op] = calculateStdDev(data)
        }
    }
    
    return results
}
```

### Scenario 5.C: Concurrency
```go
func processItems(items []Item) []Result {
    var wg sync.WaitGroup
    results := make([]Result, len(items))
    
    for i, item := range items {
        wg.Add(1)
        go func(index int, item Item) {
            defer wg.Done()
            results[index] = processItem(item)
        }(i, item)
    }
    
    wg.Wait()
    return results
}
```

Analyze each scenario for design patterns, error handling, performance, and potential issues.