# Chapter 7: Interfaces - Exercises

## Exercise 7.1: Advanced Interface Design [HARD]
**Difficulty**: Hard  
**Topic**: Interface segregation, composition, design principles

Design a comprehensive logging system with clean interfaces:
1. **Interface segregation** (separate concerns: writing, formatting, filtering, etc.)
2. **Composable loggers** with different capabilities
3. **Structured logging** with typed fields and contexts
4. **Performance optimization** with lazy evaluation and batching
5. **Plugin architecture** for custom appenders and formatters

```go
// Segregated interfaces
type Writer interface {
    Write(entry LogEntry) error
    Close() error
}

type Formatter interface {
    Format(entry LogEntry) ([]byte, error)
}

type Filter interface {
    ShouldLog(entry LogEntry) bool
}

type Logger interface {
    Debug(msg string, fields ...Field)
    Info(msg string, fields ...Field)
    Warn(msg string, fields ...Field)
    Error(msg string, fields ...Field)
    With(fields ...Field) Logger
}

// Composable implementation
type CompositeLogger struct {
    writers   []Writer
    formatter Formatter
    filters   []Filter
    fields    []Field
}
```

**FAANG Interview Aspect**: How would you design interfaces for a system that needs to scale across thousands of services?

---

## Exercise 7.2: Interface Satisfaction and Type Assertions [HARD]
**Difficulty**: Hard  
**Topic**: Interface satisfaction, type assertions, type switches, reflection

Build a flexible serialization framework:
1. **Multiple serialization formats** (JSON, XML, Protobuf, MessagePack)
2. **Custom serializers** for complex types
3. **Type registration** and discovery
4. **Version compatibility** handling
5. **Performance optimization** with type-specific fast paths

```go
type Serializer interface {
    Serialize(v interface{}) ([]byte, error)
    Deserialize(data []byte, v interface{}) error
    ContentType() string
}

type CustomSerializer interface {
    SerializeCustom() ([]byte, error)
    DeserializeCustom([]byte) error
}

type VersionedSerializer interface {
    Serializer
    Version() int
    MigrateFrom(oldVersion int, data []byte) ([]byte, error)
}

type SerializerRegistry struct {
    serializers map[string]Serializer
    typeMap     map[reflect.Type]string
}

func (sr *SerializerRegistry) Register(name string, serializer Serializer) { /* implement */ }
func (sr *SerializerRegistry) SerializeWithType(v interface{}) ([]byte, error) { /* implement */ }
func (sr *SerializerRegistry) Deserialize(data []byte, contentType string, v interface{}) error { /* implement */ }
```

**FAANG Interview Aspect**: How would you handle backward compatibility in a distributed system with evolving data formats?

---

## Exercise 7.3: Empty Interface and Type Safety [HARD]
**Difficulty**: Hard  
**Topic**: interface{}, type safety, generics vs interfaces

Create a type-safe dynamic configuration system:
1. **Configuration schema** validation and type checking
2. **Dynamic type conversion** with safety guarantees
3. **Nested configuration** support with path-based access
4. **Configuration hot-reloading** with type stability
5. **Default values** and validation rules

```go
type ConfigValue interface {
    Type() reflect.Type
    Value() interface{}
    String() string
    Int() (int64, error)
    Float() (float64, error)
    Bool() (bool, error)
    Slice() ([]ConfigValue, error)
    Map() (map[string]ConfigValue, error)
}

type Config interface {
    Get(path string) (ConfigValue, error)
    Set(path string, value interface{}) error
    Has(path string) bool
    Delete(path string) error
    Validate() error
    Subscribe(path string, callback func(ConfigValue)) error
}

type TypedConfig[T any] interface {
    Config
    GetTyped(path string) (T, error)
    SetTyped(path string, value T) error
}
```

**FAANG Interview Aspect**: How would you design a configuration system that prevents runtime type errors while maintaining flexibility?

---

## Exercise 7.4: Interface Embedding and Composition [HARD]
**Difficulty**: Hard  
**Topic**: Interface embedding, composition patterns, method promotion

Design a comprehensive HTTP middleware system:
1. **Middleware interface** with request/response handling
2. **Middleware chaining** with proper error propagation
3. **Context passing** and modification
4. **Conditional middleware** execution
5. **Middleware metrics** and observability

```go
type Middleware interface {
    Process(ctx Context, req Request, next Handler) (Response, error)
}

type Handler interface {
    Handle(ctx Context, req Request) (Response, error)
}

type AuthMiddleware interface {
    Middleware
    Authenticate(ctx Context, req Request) (User, error)
    Authorize(ctx Context, user User, req Request) error
}

type MetricsMiddleware interface {
    Middleware
    RecordMetric(name string, value float64, tags map[string]string)
    GetMetrics() MetricsSnapshot
}

type MiddlewareChain struct {
    middlewares []Middleware
    handler     Handler
}

func (mc *MiddlewareChain) Add(middleware Middleware) *MiddlewareChain { /* implement */ }
func (mc *MiddlewareChain) Process(ctx Context, req Request) (Response, error) { /* implement */ }
```

**FAANG Interview Aspect**: How would you design middleware that's both performant and easy to test?

---

## Exercise 7.5: Interface Performance Optimization [HARD]
**Difficulty**: Hard  
**Topic**: Interface performance, virtual method tables, inlining

Optimize interface performance for high-throughput scenarios:
1. **Interface call benchmarking** across different patterns
2. **Method inlining** opportunities and limitations
3. **Interface allocation** minimization strategies
4. **Type assertion optimization** with type switches
5. **Code generation** for performance-critical paths

```go
// Performance testing framework
type BenchmarkSuite struct {
    iterations int
    warmup     int
}

func (bs *BenchmarkSuite) BenchmarkDirectCall(fn func()) time.Duration { /* implement */ }
func (bs *BenchmarkSuite) BenchmarkInterfaceCall(iface interface{}, method string) time.Duration { /* implement */ }
func (bs *BenchmarkSuite) BenchmarkTypeAssertion(iface interface{}, targetType reflect.Type) time.Duration { /* implement */ }
func (bs *BenchmarkSuite) BenchmarkTypeSwitch(iface interface{}) time.Duration { /* implement */ }

// Optimization strategies
type FastProcessor interface {
    ProcessBatch([]Item) []Result // Batch processing to amortize interface call overhead
}

type OptimizedProcessor struct {
    // Pre-computed function pointers
    processFn func(Item) Result
}
```

**FAANG Interview Aspect**: When would interface call overhead become a bottleneck, and how would you optimize it?

---

## Exercise 7.6: Interface Testing and Mocking [MEDIUM]
**Difficulty**: Medium  
**Topic**: Interface testing, mocking, dependency injection

Build a comprehensive testing framework for interfaces:
1. **Automatic mock generation** from interface definitions
2. **Behavior verification** with call counting and argument matching
3. **Stub creation** with configurable responses
4. **Integration testing** helpers for interface implementations
5. **Contract testing** to ensure interface compliance

```go
type MockGenerator struct {
    interfaces map[string]reflect.Type
}

type Mock interface {
    On(method string, args ...interface{}) *Call
    AssertExpectations(t *testing.T)
    AssertNumberOfCalls(t *testing.T, method string, expected int)
}

type Call struct {
    method string
    args   []interface{}
    returnValues []interface{}
    runFn  func(args []interface{})
}

func (c *Call) Return(values ...interface{}) *Call { /* implement */ }
func (c *Call) Run(fn func(args []interface{})) *Call { /* implement */ }
func (c *Call) Times(times int) *Call { /* implement */ }

// Usage example:
// mock := NewMock[DatabaseInterface]()
// mock.On("Get", "key1").Return("value1", nil)
// mock.On("Set", "key1", "newvalue").Return(nil).Times(1)
```

**FAANG Interview Aspect**: How do you ensure that your tests accurately reflect the behavior of production implementations?

---

## Challenge Problems

### Challenge 7.A: Dynamic Interface Implementation [EXPERT]
**Difficulty**: Expert  
**Topic**: Dynamic programming, code generation, reflection

Build a system that creates interface implementations at runtime:
1. **Dynamic proxy generation** for interfaces
2. **Method interception** and modification
3. **Hot-swapping** of interface implementations
4. **Performance monitoring** of dynamic implementations
5. **Code generation** for optimal performance

```go
type ProxyGenerator struct {
    interceptors map[string][]Interceptor
}

type Interceptor interface {
    Before(method string, args []interface{}) []interface{}
    After(method string, args []interface{}, results []interface{}) []interface{}
    OnError(method string, args []interface{}, err error) error
}

func (pg *ProxyGenerator) CreateProxy(target interface{}, interceptors ...Interceptor) interface{} { /* implement */ }
```

### Challenge 7.B: Interface-based Microservices Framework [EXPERT]
**Difficulty**: Expert  
**Topic**: Distributed systems, service discovery, interface contracts

Design a framework where services are defined as interfaces:
1. **Service registration** and discovery via interfaces
2. **Automatic RPC generation** from interface definitions
3. **Load balancing** and failover for interface calls
4. **Version compatibility** checking across service boundaries
5. **Circuit breaker** pattern for interface calls

**System Design Challenges**:
- How do you handle interface evolution in a distributed system?
- How do you maintain type safety across network boundaries?
- How do you implement distributed tracing for interface calls?

---

## Knowledge Validation Questions

1. **Interface Satisfaction**: Explain how Go determines if a type satisfies an interface. What happens at compile time vs runtime?

2. **Interface Values**: Describe the internal representation of interface values. How do nil interfaces behave?

3. **Performance**: When do interface calls have performance overhead? How can you minimize it?

4. **Design Principles**: How does the "accept interfaces, return structs" principle affect API design?

5. **Testing**: What are the advantages of using interfaces for dependency injection in tests?

---

## Interface Design Patterns

### Challenge 7.C: Visitor Pattern
```go
type Visitor interface {
    VisitDocument(doc *Document) error
    VisitParagraph(p *Paragraph) error
    VisitText(t *Text) error
}

type Visitable interface {
    Accept(visitor Visitor) error
}
```

### Challenge 7.D: Strategy Pattern
```go
type CompressionStrategy interface {
    Compress(data []byte) ([]byte, error)
    Decompress(data []byte) ([]byte, error)
    Ratio(data []byte) float64
}

// Implement GZIP, LZ4, Snappy strategies
```

---

## Code Review Scenarios

### Scenario 7.A: Interface Design
```go
type DataService interface {
    GetUser(id string) (*User, error)
    SaveUser(user *User) error
    DeleteUser(id string) error
    GetAllUsers() ([]*User, error)
    SearchUsers(query string) ([]*User, error)
}
```

### Scenario 7.B: Type Assertions
```go
func processValue(v interface{}) error {
    switch val := v.(type) {
    case string:
        return processString(val)
    case int:
        return processInt(val)
    case []interface{}:
        for _, item := range val {
            if err := processValue(item); err != nil {
                return err
            }
        }
    default:
        return fmt.Errorf("unsupported type: %T", v)
    }
    return nil
}
```

### Scenario 7.C: Interface Embedding
```go
type ReadWriter interface {
    io.Reader
    io.Writer
}

type BufferedReadWriter struct {
    ReadWriter
    buffer []byte
}

func (brw *BufferedReadWriter) Read(p []byte) (n int, err error) {
    // Should this delegate to embedded ReadWriter or implement custom logic?
    return brw.ReadWriter.Read(p)
}
```

Evaluate each scenario for interface design quality, potential issues, and improvement opportunities.