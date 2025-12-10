# Chapter 2: Program Structure - Exercises

## Exercise 2.1: Package Design and Visibility [MEDIUM]
**Difficulty**: Medium  
**Topic**: Package structure, exported/unexported identifiers

Design a package `calculator` with the following requirements:
1. Support basic arithmetic operations (+, -, *, /, %)
2. Maintain operation history (unexported)
3. Provide functions to retrieve history and statistics
4. Implement proper error handling for division by zero
5. Include a `Clear()` function to reset history

**FAANG Interview Aspect**: How would you design the API to be both usable and maintainable? What would you export vs keep private?

---

## Exercise 2.2: Variable Lifecycle and Scope Analysis [HARD]
**Difficulty**: Hard  
**Topic**: Variable scoping, memory allocation, escape analysis

Analyze and explain the memory allocation behavior of this code:
```go
func complexFunction() *int {
    var x int = 42
    var y *int = &x
    
    if true {
        var z int = 100
        y = &z
    }
    
    return y
}
```

1. Which variables escape to the heap and why?
2. Rewrite the function to minimize heap allocations
3. Create a benchmark to measure allocation differences
4. Explain when the compiler chooses stack vs heap allocation

**FAANG Interview Aspect**: Understanding escape analysis is crucial for writing high-performance Go code.

---

## Exercise 2.3: Global State Management [HARD]
**Difficulty**: Hard  
**Topic**: Package initialization, global state, thread safety

Design a configuration management system that:
1. Loads configuration from multiple sources (files, env vars, command line)
2. Supports hot reloading of configuration
3. Provides type-safe access to configuration values
4. Handles concurrent access safely
5. Maintains configuration history and rollback capability

Requirements:
- Use `init()` functions appropriately
- Implement proper synchronization
- Provide a clean API for accessing nested configuration values

**FAANG Interview Aspect**: How would you handle configuration in a microservices environment?

---

## Exercise 2.4: Advanced Command-Line Flag Processing [HARD]
**Difficulty**: Hard  
**Topic**: flag package, custom types, validation

Implement a sophisticated CLI tool that:
1. Supports nested subcommands (like `git add`, `git commit`)
2. Validates flag combinations and dependencies
3. Provides auto-completion suggestions
4. Supports configuration files and environment variables
5. Implements custom flag types (duration, size units, etc.)

Example usage:
```bash
./tool database migrate --dry-run --timeout=5m
./tool server start --port=8080 --workers=4 --config=app.yaml
```

**FAANG Interview Aspect**: How would you make the CLI extensible for plugins?

---

## Exercise 2.5: Type System Mastery [MEDIUM]
**Difficulty**: Medium  
**Topic**: Type definitions, type embedding, method sets

Create a flexible units system:
1. Define types for different units (Distance, Weight, Time, etc.)
2. Implement conversion between compatible units
3. Support arithmetic operations between same-type units
4. Prevent compilation errors for incompatible operations
5. Include String() methods for human-readable output

```go
type Distance float64
type Weight float64

const (
    Meter Distance = 1.0
    Kilometer = 1000 * Meter
    Mile = 1609.34 * Meter
    
    Gram Weight = 1.0
    Kilogram = 1000 * Gram
    Pound = 453.592 * Gram
)
```

**FAANG Interview Aspect**: How does Go's type system help prevent common programming errors?

---

## Exercise 2.6: Import Management and Dependency Injection [HARD]
**Difficulty**: Hard  
**Topic**: Package imports, dependency injection, interfaces

Design a plugin system that:
1. Dynamically loads plugins at runtime
2. Provides a clean interface for plugin registration
3. Manages plugin dependencies and initialization order
4. Supports plugin versioning and compatibility checks
5. Implements graceful degradation when plugins fail

Create example plugins:
- Logger plugin (file, console, syslog)
- Cache plugin (memory, redis, memcached)
- Database plugin (postgres, mysql, sqlite)

**FAANG Interview Aspect**: How would you handle plugin security and sandboxing?

---

## Challenge Problems

### Challenge 2.A: Go Module Dependency Analyzer [EXPERT]
**Difficulty**: Expert  
**Topic**: Module system, dependency analysis, graph algorithms

Build a tool that:
1. Analyzes Go module dependencies recursively
2. Detects circular dependencies
3. Identifies outdated dependencies
4. Suggests minimal version upgrades
5. Generates dependency graphs and reports

**Advanced Features**:
- License compliance checking
- Security vulnerability scanning
- Build time impact analysis

### Challenge 2.B: Hot Code Reloading System [EXPERT]
**Difficulty**: Expert  
**Topic**: Reflection, plugin system, code generation

Implement a development server that:
1. Watches Go source files for changes
2. Recompiles and hot-swaps code without restarting
3. Maintains application state across reloads
4. Provides a web interface for monitoring
5. Handles compilation errors gracefully

**Technical Challenges**:
- State serialization/deserialization
- Interface compatibility checking
- Memory leak prevention during reloads

---

## Knowledge Validation Questions

1. **Package Design**: What are the trade-offs between fine-grained packages vs monolithic packages? When would you choose each approach?

2. **Initialization Order**: Explain the exact order of initialization in Go programs. How does this affect package design?

3. **Name Collision**: How would you handle naming conflicts between imported packages? Provide three different strategies.

4. **Type System**: Explain the difference between type definition and type alias. When would you use each?

5. **Import Cycles**: Why does Go prohibit import cycles? How would you refactor code that has circular dependencies?

6. **Memory Layout**: How do different variable declarations affect memory layout and performance?

---

## Code Review Scenarios

Review these code snippets and identify issues:

### Scenario 2.A: Global State
```go
var config Config
var db *sql.DB

func init() {
    config = loadConfig()
    db = connectDB(config.DBUrl)
}
```

### Scenario 2.B: Package Interface
```go
package calculator

func Add(a, b int) int { return a + b }
func subtract(a, b int) int { return a - b }
func History() []string { return history }

var history []string
```

### Scenario 2.C: Error Handling
```go
func ProcessFile(filename string) error {
    file, err := os.Open(filename)
    if err != nil {
        log.Fatal(err)
    }
    defer file.Close()
    
    // processing logic
    return nil
}
```

What problems do you see in each scenario? How would you improve them?