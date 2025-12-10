# Chapter 6: Methods - Exercises

## Exercise 6.1: Advanced Method Design Patterns [HARD]
**Difficulty**: Hard  
**Topic**: Method receivers, method sets, design patterns

Design a flexible caching system with method chaining:
1. **Fluent interface** for cache configuration
2. **Different eviction policies** (LRU, LFU, TTL, Random)
3. **Metrics collection** with method-based instrumentation
4. **Serialization strategies** for different data types
5. **Multi-level caching** (L1 memory, L2 disk, L3 distributed)

```go
type Cache interface {
    Get(key string) (interface{}, bool)
    Put(key string, value interface{}) Cache
    Delete(key string) bool
    Clear() Cache
    Stats() CacheStats
}

type CacheBuilder struct {
    maxSize      int
    ttl          time.Duration
    evictionPolicy EvictionPolicy
}

func NewCacheBuilder() *CacheBuilder { /* implement */ }
func (cb *CacheBuilder) WithMaxSize(size int) *CacheBuilder { /* implement */ }
func (cb *CacheBuilder) WithTTL(ttl time.Duration) *CacheBuilder { /* implement */ }
func (cb *CacheBuilder) WithEvictionPolicy(policy EvictionPolicy) *CacheBuilder { /* implement */ }
func (cb *CacheBuilder) Build() Cache { /* implement */ }
```

**FAANG Interview Aspect**: How would you design a caching layer for a distributed system like Redis?

---

## Exercise 6.2: Pointer vs Value Receivers [HARD]
**Difficulty**: Hard  
**Topic**: Receiver types, performance implications, memory management

Create a comprehensive analysis of receiver patterns:
1. **Performance benchmarking** for different receiver types with various struct sizes
2. **Memory allocation analysis** showing when copies occur
3. **Method set implications** for interfaces and embedding
4. **Concurrent safety** considerations with pointer receivers
5. **Best practices documentation** with concrete examples

```go
// Different struct sizes for testing
type SmallStruct struct {
    ID   int64
    Name string
}

type LargeStruct struct {
    ID       int64
    Name     string
    Data     [1000]byte
    Metadata map[string]interface{}
    // ... many more fields
}

// Methods to test performance implications
func (s SmallStruct) ValueMethod() { /* implement */ }
func (s *SmallStruct) PointerMethod() { /* implement */ }

func (l LargeStruct) ValueMethod() { /* implement */ }
func (l *LargeStruct) PointerMethod() { /* implement */ }
```

**FAANG Interview Aspect**: When would you choose value receivers vs pointer receivers? What are the trade-offs?

---

## Exercise 6.3: Method Chaining and Builder Pattern [MEDIUM]
**Difficulty**: Medium  
**Topic**: Method chaining, builder pattern, API design

Implement a SQL query builder with advanced features:
1. **Complex query construction** with type safety
2. **Subquery support** with proper nesting
3. **Union and intersection** operations
4. **Window functions** and common table expressions
5. **Query optimization** hints and explain plan integration

```go
type QueryBuilder struct {
    // internal state
}

type SelectBuilder struct {
    *QueryBuilder
}

type WhereBuilder struct {
    *QueryBuilder
}

func Select(columns ...string) *SelectBuilder { /* implement */ }
func (sb *SelectBuilder) From(table string) *WhereBuilder { /* implement */ }
func (wb *WhereBuilder) Where(condition string, args ...interface{}) *WhereBuilder { /* implement */ }
func (wb *WhereBuilder) And(condition string, args ...interface{}) *WhereBuilder { /* implement */ }
func (wb *WhereBuilder) Or(condition string, args ...interface{}) *WhereBuilder { /* implement */ }
func (wb *WhereBuilder) Limit(limit int) *WhereBuilder { /* implement */ }
func (wb *WhereBuilder) ToSQL() (string, []interface{}) { /* implement */ }
```

**FAANG Interview Aspect**: How would you design an API that's both flexible and type-safe?

---

## Exercise 6.4: Interface Implementation Strategies [HARD]
**Difficulty**: Hard  
**Topic**: Interface satisfaction, method sets, composition

Design a plugin architecture using interfaces:
1. **Plugin discovery** and loading at runtime
2. **Interface compatibility** checking and versioning
3. **Method resolution** for embedded interfaces
4. **Performance optimization** for interface calls
5. **Mock generation** for testing

```go
type Plugin interface {
    Name() string
    Version() string
    Initialize(config Config) error
    Process(data Data) (Result, error)
    Cleanup() error
}

type ProcessorPlugin interface {
    Plugin
    ProcessBatch([]Data) ([]Result, error)
    GetMetrics() ProcessorMetrics
}

type StoragePlugin interface {
    Plugin
    Store(key string, value interface{}) error
    Retrieve(key string) (interface{}, error)
    Delete(key string) error
}

// Plugin manager
type PluginManager struct {
    plugins map[string]Plugin
}

func (pm *PluginManager) LoadPlugin(path string) error { /* implement */ }
func (pm *PluginManager) GetPlugin(name string) Plugin { /* implement */ }
func (pm *PluginManager) ListPlugins() []Plugin { /* implement */ }
```

**FAANG Interview Aspect**: How would you ensure plugin compatibility and security in a production system?

---

## Exercise 6.5: Method Embedding and Composition [HARD]
**Difficulty**: Hard  
**Topic**: Struct embedding, method promotion, composition patterns

Create a flexible HTTP client library:
1. **Base client** with common functionality
2. **Specialized clients** using embedding (REST, GraphQL, gRPC)
3. **Middleware composition** for cross-cutting concerns
4. **Configuration inheritance** and override mechanisms
5. **Request/response transformation** pipelines

```go
type HTTPClient struct {
    client     *http.Client
    baseURL    string
    headers    http.Header
    middleware []Middleware
}

func (hc *HTTPClient) Get(path string) (*Response, error) { /* implement */ }
func (hc *HTTPClient) Post(path string, body interface{}) (*Response, error) { /* implement */ }
func (hc *HTTPClient) WithTimeout(timeout time.Duration) *HTTPClient { /* implement */ }

type RESTClient struct {
    *HTTPClient
    apiVersion string
}

func (rc *RESTClient) GetResource(resource, id string) (*Response, error) { /* implement */ }
func (rc *RESTClient) CreateResource(resource string, data interface{}) (*Response, error) { /* implement */ }

type GraphQLClient struct {
    *HTTPClient
    schema Schema
}

func (gc *GraphQLClient) Query(query string, variables map[string]interface{}) (*Response, error) { /* implement */ }
func (gc *GraphQLClient) Mutation(mutation string, variables map[string]interface{}) (*Response, error) { /* implement */ }
```

**FAANG Interview Aspect**: How does composition compare to inheritance? When would you choose each approach?

---

## Exercise 6.6: Advanced Method Reflection [HARD]
**Difficulty**: Hard  
**Topic**: Reflection, method discovery, dynamic invocation

Build a method introspection and invocation framework:
1. **Method discovery** with filtering and sorting
2. **Dynamic method invocation** with type safety
3. **Method signature analysis** and validation
4. **Performance optimization** for repeated calls
5. **Code generation** for optimized dispatching

```go
type MethodInvoker struct {
    methods map[string]reflect.Method
    cache   map[string]func([]reflect.Value) []reflect.Value
}

func NewMethodInvoker(target interface{}) *MethodInvoker { /* implement */ }
func (mi *MethodInvoker) Invoke(methodName string, args ...interface{}) ([]interface{}, error) { /* implement */ }
func (mi *MethodInvoker) HasMethod(name string) bool { /* implement */ }
func (mi *MethodInvoker) GetMethodSignature(name string) MethodSignature { /* implement */ }
func (mi *MethodInvoker) ListMethods() []string { /* implement */ }

type MethodSignature struct {
    Name       string
    ParamTypes []reflect.Type
    ReturnTypes []reflect.Type
    IsVariadic bool
}
```

**FAANG Interview Aspect**: When is reflection appropriate in Go? What are the performance implications?

---

## Challenge Problems

### Challenge 6.A: High-Performance Method Dispatch [EXPERT]
**Difficulty**: Expert  
**Topic**: Performance optimization, method dispatch, code generation

Optimize method dispatch for high-performance scenarios:
1. **Interface method caching** to avoid runtime lookups
2. **Virtual method table** implementation
3. **Method inlining** heuristics and implementation
4. **Branch prediction** optimization for method calls
5. **SIMD optimization** for batch method calls

**Performance Goals**:
- 10x faster than reflection-based dispatch
- Sub-nanosecond method resolution
- Zero allocation method calls

### Challenge 6.B: Distributed Method Invocation [EXPERT]
**Difficulty**: Expert  
**Topic**: Distributed systems, RPC, serialization

Build a distributed method invocation system:
1. **Transparent remote method calls** with local interface
2. **Load balancing** across multiple service instances
3. **Circuit breaker** and failover mechanisms
4. **Method result caching** and invalidation
5. **Distributed tracing** and monitoring

**System Design Challenges**:
- How to handle network partitions?
- How to maintain method call semantics across the network?
- How to handle different service versions?

---

## Knowledge Validation Questions

1. **Method Sets**: Explain the difference between the method set of `T` and `*T`. How does this affect interface satisfaction?

2. **Method Values vs Expressions**: What's the difference between `obj.Method` and `Type.Method`? When would you use each?

3. **Embedding vs Composition**: When should you use struct embedding vs explicit composition? What are the trade-offs?

4. **Interface Performance**: How does interface method dispatch work internally? What are the performance implications?

5. **Method Receivers**: How do you decide between value and pointer receivers? What happens when you mix them?

---

## Design Pattern Implementations

### Challenge 6.C: Decorator Pattern
Implement the decorator pattern using methods:
```go
type Component interface {
    Operation() string
}

type ConcreteComponent struct{}
func (cc ConcreteComponent) Operation() string { return "base operation" }

// Implement decorators that add functionality
```

### Challenge 6.D: Strategy Pattern
Implement different algorithms using method interfaces:
```go
type SortingStrategy interface {
    Sort([]int) []int
}

// Implement QuickSort, MergeSort, HeapSort strategies
```

---

## Code Review Scenarios

### Scenario 6.A: Method Receiver Choice
```go
type User struct {
    ID       int64
    Name     string
    Email    string
    Settings map[string]interface{}
}

func (u User) GetDisplayName() string {
    if u.Name != "" {
        return u.Name
    }
    return u.Email
}

func (u *User) UpdateSettings(key string, value interface{}) {
    u.Settings[key] = value
}
```

### Scenario 6.B: Interface Design
```go
type DataProcessor interface {
    Process(data []byte) ([]byte, error)
    GetStats() ProcessingStats
    Reset()
}

type JSONProcessor struct {
    processedCount int
    errorCount     int
}

func (jp JSONProcessor) Process(data []byte) ([]byte, error) {
    // processing logic
    jp.processedCount++
    return processedData, nil
}
```

### Scenario 6.C: Method Chaining
```go
type RequestBuilder struct {
    url     string
    headers map[string]string
    body    []byte
}

func (rb RequestBuilder) WithHeader(key, value string) RequestBuilder {
    rb.headers[key] = value
    return rb
}

func (rb RequestBuilder) WithBody(body []byte) RequestBuilder {
    rb.body = body
    return rb
}
```

Analyze each scenario for correctness, performance, and design quality.