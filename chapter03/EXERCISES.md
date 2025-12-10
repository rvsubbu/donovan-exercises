# Chapter 3: Basic Data Types - Exercises

## Exercise 3.1: Advanced Numeric Computing [HARD]
**Difficulty**: Hard  
**Topic**: Numeric precision, overflow handling, performance

Implement a financial calculator that:
1. Handles decimal precision correctly (no floating-point errors)
2. Detects and handles integer overflow/underflow
3. Implements arbitrary precision arithmetic for large numbers
4. Provides rounding modes (banker's rounding, truncation, etc.)
5. Supports different number bases (binary, octal, hex, custom)

```go
type Decimal struct {
    value *big.Int
    scale int
}

func (d Decimal) Add(other Decimal) Decimal { /* implement */ }
func (d Decimal) String() string { /* implement */ }
```

**FAANG Interview Aspect**: How would you optimize for both memory usage and computational speed?

---

## Exercise 3.2: Advanced String Processing [HARD]
**Difficulty**: Hard  
**Topic**: Unicode, string internals, performance optimization

Create a text processing library that:
1. Correctly handles Unicode normalization and comparison
2. Implements efficient string matching algorithms (KMP, Boyer-Moore)
3. Provides case-insensitive operations for international text
4. Handles different encodings (UTF-8, UTF-16, Latin-1)
5. Implements memory-efficient string interning

Performance requirements:
- Process 1GB+ text files efficiently
- Minimize string allocations
- Support streaming processing

**FAANG Interview Aspect**: How would you handle string matching in a search engine context?

---

## Exercise 3.3: Complex Number Mathematics [MEDIUM]
**Difficulty**: Medium  
**Topic**: Complex numbers, mathematical operations

Implement a comprehensive complex number library:
1. Support all basic arithmetic operations
2. Implement trigonometric and logarithmic functions
3. Provide conversion between rectangular and polar forms
4. Handle edge cases (infinity, NaN)
5. Include visualization capabilities (ASCII art plots)

```go
type Complex struct {
    Real, Imag float64
}

func (c Complex) Magnitude() float64 { /* implement */ }
func (c Complex) Phase() float64 { /* implement */ }
func (c Complex) Power(n int) Complex { /* implement */ }
```

**FAANG Interview Aspect**: How would you handle numerical stability in complex calculations?

---

## Exercise 3.4: Advanced Boolean Logic System [HARD]
**Difficulty**: Hard  
**Topic**: Boolean algebra, logic circuits, optimization

Design a boolean expression evaluator and optimizer:
1. Parse complex boolean expressions with variables
2. Optimize expressions using boolean algebra rules
3. Generate truth tables and Karnaugh maps
4. Convert between different normal forms (CNF, DNF)
5. Implement circuit simulation capabilities

```go
type BoolExpr interface {
    Evaluate(vars map[string]bool) bool
    Optimize() BoolExpr
    String() string
    TruthTable() [][]bool
}
```

**FAANG Interview Aspect**: How would you optimize boolean expressions for database query planning?

---

## Exercise 3.5: Efficient Bit Manipulation Library [HARD]
**Difficulty**: Hard  
**Topic**: Bit operations, data structures, algorithms

Create a high-performance bit manipulation library:
1. Implement bit sets with operations (union, intersection, complement)
2. Create space-efficient bloom filters
3. Implement bit-level compression algorithms
4. Provide fast bit counting and searching functions
5. Support arbitrary-precision bit operations

Features to implement:
- Sparse bit sets for large, mostly-empty sets
- Compressed bit vectors (RLE encoding)
- Parallel bit operations using SIMD when possible

**FAANG Interview Aspect**: How are bit manipulation techniques used in database indexing?

---

## Exercise 3.6: Advanced Constant and Iota Usage [MEDIUM]
**Difficulty**: Medium  
**Topic**: Constants, iota, type safety

Design a sophisticated enumeration system:
1. Create type-safe enumerations with string representations
2. Implement automatic flag combinations using bit operations
3. Provide JSON marshaling/unmarshaling for enums
4. Support enum ranges and validation
5. Generate code documentation automatically

```go
type Permission uint64

const (
    PermissionNone Permission = 0
    PermissionRead Permission = 1 << iota
    PermissionWrite
    PermissionExecute
    PermissionDelete
    PermissionAdmin = PermissionRead | PermissionWrite | PermissionExecute | PermissionDelete
)
```

**FAANG Interview Aspect**: How would you design a permission system for a distributed system?

---

## Challenge Problems

### Challenge 3.A: High-Performance Numeric Parser [EXPERT]
**Difficulty**: Expert  
**Topic**: Parsing, performance optimization, memory management

Implement a numeric parser that:
1. Parses numbers 10x faster than `strconv.ParseFloat`
2. Handles all standard numeric formats (scientific, hex, binary)
3. Uses minimal memory allocations
4. Supports streaming parsing for large datasets
5. Provides detailed error reporting with position information

**Optimization Techniques**:
- Custom parsing state machines
- SIMD vector operations
- Branch prediction optimization
- Memory pool management

### Challenge 3.B: Unicode Text Processing Engine [EXPERT]
**Difficulty**: Expert  
**Topic**: Unicode, internationalization, text algorithms

Build a production-grade text processing engine:
1. Full Unicode support with proper normalization
2. Language-aware text segmentation (words, sentences)
3. Advanced collation and sorting algorithms
4. Text similarity and fuzzy matching
5. Support for 50+ languages with different writing systems

**Advanced Features**:
- Bidirectional text support (Arabic, Hebrew)
- Complex script handling (Thai, Devanagari)
- Linguistic rule-based transformations

---

## Knowledge Validation Questions

1. **Floating Point Precision**: Why does `0.1 + 0.2 != 0.3` in Go? How would you handle currency calculations?

2. **String Internals**: Explain the memory layout of Go strings. How does this affect performance?

3. **Rune vs Byte**: When should you iterate over bytes vs runes in string processing? What are the performance implications?

4. **Constant Evaluation**: At what point during compilation are constants evaluated? How does this affect program behavior?

5. **Type Conversions**: What are the rules for numeric type conversions in Go? When might you lose precision?

---

## Performance Challenges

### Challenge 3.C: String Builder Benchmark
Write benchmarks comparing:
- String concatenation with `+`
- `fmt.Sprintf()` 
- `strings.Builder`
- `bytes.Buffer`
- Pre-allocated slices

For inputs of varying sizes (10 bytes to 10MB).

### Challenge 3.D: Numeric Conversion Optimization
Implement and benchmark custom functions for:
- Integer to string conversion
- String to integer parsing
- Floating point formatting

Compare against standard library implementations.

---

## Code Review Scenarios

### Scenario 3.A: Number Validation
```go
func isValidPrice(price string) bool {
    f, err := strconv.ParseFloat(price, 64)
    return err == nil && f > 0
}
```

### Scenario 3.B: String Processing
```go
func processText(text string) string {
    var result string
    for i := 0; i < len(text); i++ {
        if text[i] >= 'A' && text[i] <= 'Z' {
            result += string(text[i] + 32)
        } else {
            result += string(text[i])
        }
    }
    return result
}
```

### Scenario 3.C: Bit Manipulation
```go
func hasPermission(userPerms, requiredPerm uint64) bool {
    return userPerms&requiredPerm > 0
}
```

Identify issues and suggest improvements for each scenario.