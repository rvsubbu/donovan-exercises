# Chapter 10: Packages and the Go Tool - Exercises

## Exercise 10.1: Advanced Package Design [HARD]
**Difficulty**: Hard  
**Topic**: Package architecture, API design, modularity

Design a comprehensive logging framework as a package ecosystem:
1. **Core logging package** with minimal dependencies and clean interfaces
2. **Handler packages** for different outputs (file, syslog, network, cloud)
3. **Formatter packages** with pluggable serialization (JSON, logfmt, binary)
4. **Integration packages** for popular frameworks and libraries
5. **Configuration package** with environment-specific settings

```
mycompany/logging/
├── logger/          # Core logging interfaces and implementation
├── handlers/        # Output handlers
│   ├── file/
│   ├── syslog/
│   ├── network/
│   └── cloud/
├── formatters/      # Message formatters
│   ├── json/
│   ├── logfmt/
│   └── binary/
├── integrations/    # Framework integrations
│   ├── http/
│   ├── grpc/
│   └── database/
└── config/          # Configuration utilities
```

**Package Design Principles**:
- Minimize inter-package dependencies
- Clear separation of concerns
- Backward compatibility guarantees
- Performance-optimized hot paths

**FAANG Interview Aspect**: How would you design a package ecosystem that can evolve over time without breaking existing users?

---

## Exercise 10.2: Advanced Go Modules and Versioning [HARD]
**Difficulty**: Hard  
**Topic**: Go modules, semantic versioning, dependency management

Build a complex multi-module project with sophisticated versioning:
1. **Multi-module workspace** with shared internal packages
2. **Semantic versioning** strategy with breaking change management
3. **Module replacement** for development and testing
4. **Private module hosting** with authentication and access control
5. **Dependency vulnerability** scanning and automated updates

```go
// Example go.mod structure for complex project
module github.com/company/platform

go 1.21

require (
    github.com/company/platform/auth v2.1.0
    github.com/company/platform/database v1.5.2
    github.com/company/platform/messaging v3.0.0-alpha.1
    github.com/company/common v1.2.3
    // external dependencies
)

replace (
    github.com/company/platform/auth => ./auth
    github.com/company/platform/database => ./database
    github.com/company/platform/messaging => ./messaging
)

retract (
    v1.0.0 // published accidentally
    v1.0.1 // contains security vulnerability
)
```

Create tooling for:
- **Automated dependency updates** with compatibility testing
- **Breaking change detection** across module boundaries
- **Release automation** with changelog generation
- **Module health monitoring** and deprecation warnings

**FAANG Interview Aspect**: How would you manage dependencies in a microservices architecture with hundreds of services?

---

## Exercise 10.3: Custom Build Tools and Code Generation [HARD]
**Difficulty**: Hard  
**Topic**: Go toolchain, code generation, build automation

Develop sophisticated build and code generation tools:
1. **Custom build tool** that extends `go build` with additional features
2. **Code generator** for boilerplate reduction (structs, interfaces, tests)
3. **Static analysis tool** for custom linting rules and code quality
4. **Documentation generator** with cross-references and examples
5. **Deployment tool** with environment-specific optimizations

```go
//go:generate mycodegenTool -type=User -output=user_generated.go

type User struct {
    ID       int64     `json:"id" db:"id" validate:"required"`
    Name     string    `json:"name" db:"name" validate:"required,min=1,max=100"`
    Email    string    `json:"email" db:"email" validate:"required,email"`
    Settings UserSettings `json:"settings" db:"settings"`
}

// Generator should create:
// - JSON marshal/unmarshal methods
// - Database CRUD operations  
// - Validation functions
// - Builder pattern methods
// - Test helper functions
```

**Build Tool Features**:
- **Multi-target builds** with cross-compilation
- **Asset embedding** and optimization
- **Plugin system** for extensibility
- **Build caching** and incremental compilation
- **Performance profiling** integration

**FAANG Interview Aspect**: How would you design build tools for a monorepo with thousands of packages?

---

## Exercise 10.4: Testing and Benchmark Framework [HARD]
**Difficulty**: Hard  
**Topic**: Testing infrastructure, benchmarking, test organization

Create a comprehensive testing framework:
1. **Test suite organization** with setup/teardown and fixtures
2. **Table-driven testing** framework with data generation
3. **Integration testing** with external service mocking
4. **Property-based testing** (fuzzing) with automatic test case generation
5. **Performance regression** testing with historical comparison

```go
type TestSuite struct {
    name     string
    setup    func(*TestContext) error
    teardown func(*TestContext) error
    tests    []TestCase
}

type TestCase struct {
    name     string
    input    interface{}
    expected interface{}
    setup    func(*TestContext) error
    test     func(*TestContext, interface{}) (interface{}, error)
}

func (ts *TestSuite) Run(t *testing.T) {
    // Run all tests with proper setup/teardown
}

// Property-based testing framework
type Property struct {
    name      string
    generator func() interface{}
    predicate func(interface{}) bool
    examples  []interface{}
}

func (p *Property) Check(t *testing.T, iterations int) {
    // Generate test cases and verify predicate
}

// Performance regression testing
type BenchmarkHistory struct {
    results map[string][]BenchmarkResult
}

func (bh *BenchmarkHistory) Compare(current BenchmarkResult) RegressionReport {
    // Compare with historical results and detect regressions
}
```

**FAANG Interview Aspect**: How would you ensure test reliability and prevent flaky tests in a large codebase?

---

## Exercise 10.5: Package Documentation and API Design [MEDIUM]
**Difficulty**: Medium  
**Topic**: API design, documentation, usability

Design exemplary package documentation and API:
1. **Comprehensive godoc** with examples, links, and best practices
2. **API design guidelines** with consistency checks
3. **Usage examples** covering common and advanced scenarios
4. **Migration guides** for version upgrades
5. **Interactive documentation** with runnable examples

```go
// Package mathutils provides mathematical utilities optimized for performance.
//
// This package focuses on numerical computations that are commonly needed
// but not available in the standard math package. All functions are designed
// to be safe for concurrent use.
//
// Basic usage:
//
//	result, err := mathutils.SafeDivide(10, 3)
//	if err != nil {
//		log.Fatal(err)
//	}
//	fmt.Printf("Result: %.2f\n", result)
//
// For more advanced usage, see the examples below.
package mathutils

// SafeDivide performs division with overflow and divide-by-zero protection.
//
// It returns an error if the divisor is zero or if the result would overflow.
// The function uses arbitrary precision arithmetic internally to ensure accuracy.
//
// Example:
//
//	result, err := SafeDivide(math.MaxFloat64, 2)
//	if err != nil {
//		// handle error
//	}
//
// See also: SafeMultiply, SafeAdd for related safe arithmetic operations.
func SafeDivide(dividend, divisor float64) (float64, error) {
    // implementation
}
```

**Documentation Standards**:
- **Clear purpose** statements for all public APIs
- **Usage examples** for all non-trivial functions
- **Error conditions** explicitly documented
- **Performance characteristics** where relevant
- **Thread safety** guarantees clearly stated

**FAANG Interview Aspect**: How do you design APIs that are both powerful and easy to use correctly?

---

## Exercise 10.6: Performance Profiling and Optimization [HARD]
**Difficulty**: Hard  
**Topic**: Performance profiling, optimization, tooling integration

Build advanced profiling and optimization tools:
1. **Custom profiler** that extends go tool pprof with domain-specific insights
2. **Performance regression** detection with automated alerts
3. **Memory allocation** tracking and optimization suggestions
4. **Hot path identification** with call graph analysis
5. **Benchmark comparison** tools with statistical significance testing

```go
type Profiler struct {
    cpu    *CPUProfiler
    memory *MemoryProfiler
    mutex  *MutexProfiler
    custom map[string]CustomProfiler
}

func (p *Profiler) StartProfiling() error {
    // Start all profilers
}

func (p *Profiler) GenerateReport() (*ProfilingReport, error) {
    // Aggregate and analyze profiling data
}

type ProfilingReport struct {
    Duration     time.Duration
    CPUUsage     CPUProfile
    MemoryUsage  MemoryProfile
    Hotspots     []Hotspot
    Suggestions  []OptimizationSuggestion
}

type OptimizationSuggestion struct {
    Type        SuggestionType
    Location    SourceLocation
    Description string
    Impact      ImpactEstimate
    Example     string
}

// Benchmark comparison with statistical analysis
type BenchmarkComparator struct {
    baseline []BenchmarkResult
    current  []BenchmarkResult
}

func (bc *BenchmarkComparator) Compare() ComparisonReport {
    // Statistical analysis of performance differences
}
```

**FAANG Interview Aspect**: How would you build performance monitoring for a system processing billions of requests per day?

---

## Challenge Problems

### Challenge 10.A: Package Ecosystem Migration Tool [EXPERT]
**Difficulty**: Expert  
**Topic**: Static analysis, code transformation, large-scale refactoring

Build a tool for migrating large codebases between package versions:
1. **Dependency analysis** to understand migration impact
2. **Automated code transformation** for API changes
3. **Compatibility shim** generation for gradual migration
4. **Migration verification** with comprehensive testing
5. **Rollback mechanism** for failed migrations

**Migration Scenarios**:
- Major version upgrades with breaking changes
- Package restructuring and renaming  
- API consolidation and deprecation
- Performance optimization requiring API changes

### Challenge 10.B: Distributed Build System [EXPERT]
**Difficulty**: Expert  
**Topic**: Distributed systems, build optimization, caching

Implement a distributed build system for Go:
1. **Remote execution** of build steps across multiple machines
2. **Intelligent caching** with content-based addressing
3. **Dynamic scheduling** based on resource availability
4. **Build artifact** distribution and replication
5. **Failure recovery** and partial rebuild optimization

**System Design Challenges**:
- How do you ensure build reproducibility across different machines?
- How do you handle network partitions during distributed builds?
- How do you optimize cache hit rates across a large organization?

---

## Knowledge Validation Questions

1. **Package Design**: What principles guide good package design? How do you balance functionality with simplicity?

2. **Import Cycles**: Why does Go prohibit import cycles? How would you refactor code with circular dependencies?

3. **Internal Packages**: When should you use internal packages? What are the trade-offs?

4. **Module Versioning**: Explain semantic versioning in the context of Go modules. How do you handle breaking changes?

5. **Build Tags**: How do build tags work? When would you use them for conditional compilation?

---

## Tooling Development Challenges

### Challenge 10.C: Static Analysis Tool
Build a static analysis tool that detects:
- Potential memory leaks in goroutines
- Inefficient string concatenation patterns
- Missing error handling
- Performance anti-patterns

### Challenge 10.D: Code Quality Dashboard
Create a dashboard that tracks:
- Test coverage trends over time
- Code complexity metrics
- Dependency freshness
- Performance regression detection

---

## Code Review Scenarios

### Scenario 10.A: Package Structure
```
myapp/
├── main.go
├── config/
│   └── config.go
├── handlers/
│   ├── user.go
│   └── order.go
├── models/
│   ├── user.go
│   └── order.go
├── utils/
│   ├── strings.go
│   ├── time.go
│   └── math.go
└── database/
    └── db.go
```

### Scenario 10.B: API Design
```go
// Package api provides REST API handlers.
package api

import (
    "encoding/json"
    "net/http"
)

type UserAPI struct {
    db *database.DB
}

func (api *UserAPI) GetUser(w http.ResponseWriter, r *http.Request) {
    id := r.URL.Query().Get("id")
    user, err := api.db.GetUser(id)
    if err != nil {
        http.Error(w, err.Error(), 500)
        return
    }
    json.NewEncoder(w).Encode(user)
}

func (api *UserAPI) CreateUser(w http.ResponseWriter, r *http.Request) {
    var user User
    json.NewDecoder(r.Body).Decode(&user)
    err := api.db.CreateUser(&user)
    if err != nil {
        http.Error(w, err.Error(), 500)
        return
    }
    w.WriteHeader(201)
}
```

### Scenario 10.C: Module Dependencies
```go
module myapp

go 1.21

require (
    github.com/gorilla/mux v1.8.0
    github.com/lib/pq v1.10.0
    golang.org/x/crypto v0.5.0
    github.com/stretchr/testify v1.8.0
)

require (
    // many transitive dependencies...
)
```

Analyze each scenario for package design quality, API usability, security concerns, and maintainability.