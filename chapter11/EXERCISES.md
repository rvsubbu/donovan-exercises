# Chapter 11: Testing - Exercises

## Exercise 11.1: Advanced Testing Patterns [HARD]
**Difficulty**: Hard  
**Topic**: Test organization, table-driven tests, test helpers

Build a comprehensive testing framework for a complex system:
1. **Test suite architecture** with setup/teardown and shared fixtures
2. **Advanced table-driven tests** with parameterized test generation
3. **Test helpers** and utilities for common testing patterns
4. **Test data management** with factories and builders
5. **Test isolation** and parallel execution strategies

```go
type TestSuite struct {
    name        string
    setup       func(*TestContext) error
    teardown    func(*TestContext) error
    setupOnce   func(*TestContext) error
    teardownOnce func(*TestContext) error
    tests       []Test
    parallel    bool
}

type Test struct {
    name     string
    skip     func() bool
    timeout  time.Duration
    run      func(*TestContext)
    subtests []Test
}

type TestContext struct {
    *testing.T
    fixtures map[string]interface{}
    cleanup  []func()
    logger   Logger
}

// Advanced table-driven testing
type TableTest[T, R any] struct {
    name      string
    generator func() []TestCase[T, R]
    runner    func(*TestContext, TestCase[T, R])
    validator func(R, R) error
}

type TestCase[T, R any] struct {
    name     string
    input    T
    expected R
    setup    func(*TestContext) error
    cleanup  func(*TestContext)
}

func (tt *TableTest[T, R]) Run(t *testing.T) {
    cases := tt.generator()
    for _, tc := range cases {
        tc := tc // capture loop variable
        t.Run(tc.name, func(t *testing.T) {
            if tt.parallel {
                t.Parallel()
            }
            ctx := NewTestContext(t)
            if tc.setup != nil {
                if err := tc.setup(ctx); err != nil {
                    t.Fatalf("setup failed: %v", err)
                }
            }
            if tc.cleanup != nil {
                defer tc.cleanup(ctx)
            }
            tt.runner(ctx, tc)
        })
    }
}
```

**FAANG Interview Aspect**: How would you design a testing strategy for a microservices architecture with complex interdependencies?

---

## Exercise 11.2: Mock and Stub Generation Framework [HARD]
**Difficulty**: Hard  
**Topic**: Code generation, mocking, dependency injection

Create an advanced mocking framework:
1. **Automatic mock generation** from interfaces using code generation
2. **Behavior verification** with call counting, argument matching, and ordering
3. **Stub configuration** with conditional responses and state machines
4. **Integration with dependency injection** for automatic test doubles
5. **Performance optimized mocks** for high-throughput testing

```go
//go:generate mockgen -source=database.go -destination=mocks/database_mock.go

type DatabaseInterface interface {
    GetUser(ctx context.Context, id string) (*User, error)
    CreateUser(ctx context.Context, user *User) error
    UpdateUser(ctx context.Context, user *User) error
    DeleteUser(ctx context.Context, id string) error
    ListUsers(ctx context.Context, filters UserFilters) ([]*User, error)
}

// Generated mock should provide:
type MockDatabase struct {
    expectations []Expectation
    calls        []Call
    stubs        map[string]func([]interface{}) []interface{}
}

type Expectation struct {
    Method    string
    Args      []ArgMatcher
    Returns   []interface{}
    Times     TimeMatcher
    Order     int
    Called    int
}

type ArgMatcher interface {
    Matches(interface{}) bool
    String() string
}

func (m *MockDatabase) EXPECT() *MockDatabaseExpectation {
    return &MockDatabaseExpectation{mock: m}
}

type MockDatabaseExpectation struct {
    mock *MockDatabase
}

func (e *MockDatabaseExpectation) GetUser(ctx interface{}, id interface{}) *GetUserCall {
    // Set up expectation for GetUser method
}

// Usage:
func TestUserService(t *testing.T) {
    mockDB := NewMockDatabase(t)
    mockDB.EXPECT().GetUser(gomock.Any(), "user123").Return(&User{ID: "user123"}, nil).Times(1)
    
    service := NewUserService(mockDB)
    user, err := service.GetUser(context.Background(), "user123")
    
    assert.NoError(t, err)
    assert.Equal(t, "user123", user.ID)
}
```

**FAANG Interview Aspect**: How would you design mocks that are both easy to use and provide good error messages when expectations fail?

---

## Exercise 11.3: Integration and End-to-End Testing [HARD]
**Difficulty**: Hard  
**Topic**: Integration testing, test containers, external services

Build a comprehensive integration testing framework:
1. **Test container management** with Docker integration and lifecycle management
2. **External service mocking** and stubbing (databases, APIs, message queues)
3. **Test environment isolation** with proper cleanup and resource management
4. **Data seeding** and test fixture management
5. **Contract testing** between services with schema validation

```go
type IntegrationTestSuite struct {
    containers map[string]TestContainer
    services   map[string]TestService
    fixtures   FixtureManager
}

type TestContainer interface {
    Start(ctx context.Context) error
    Stop(ctx context.Context) error
    Endpoint() string
    Logs() ([]string, error)
    Exec(cmd []string) (string, error)
}

type DatabaseContainer struct {
    image    string
    port     int
    database string
    username string
    password string
    container *docker.Container
}

func (dc *DatabaseContainer) Start(ctx context.Context) error {
    // Start PostgreSQL container with test database
}

type FixtureManager struct {
    fixtures map[string]Fixture
    cleanup  []func() error
}

type Fixture interface {
    Setup(ctx context.Context) error
    Teardown(ctx context.Context) error
    Data() interface{}
}

// Contract testing
type ContractTest struct {
    provider string
    consumer string
    schema   Schema
}

func (ct *ContractTest) VerifyContract(providerResponse interface{}) error {
    // Verify response matches schema
}

// Usage example:
func TestUserServiceIntegration(t *testing.T) {
    suite := &IntegrationTestSuite{
        containers: map[string]TestContainer{
            "database": &DatabaseContainer{
                image:    "postgres:13",
                database: "testdb",
                username: "testuser",
                password: "testpass",
            },
            "redis": &RedisContainer{
                image: "redis:6",
            },
        },
    }
    
    suite.Start(t)
    defer suite.Stop(t)
    
    // Run integration tests
}
```

**FAANG Interview Aspect**: How would you design integration tests that are fast, reliable, and can run in CI/CD pipelines?

---

## Exercise 11.4: Property-Based and Fuzzy Testing [HARD]
**Difficulty**: Hard  
**Topic**: Property-based testing, fuzzing, test case generation

Implement a sophisticated property-based testing framework:
1. **Property definition** with generators and invariants
2. **Test case shrinking** to find minimal failing examples
3. **Custom generators** for complex data types
4. **Stateful testing** with operation sequences and model checking
5. **Coverage-guided fuzzing** with feedback-driven input generation

```go
type Property struct {
    name        string
    generator   Generator
    predicate   func(interface{}) bool
    shrink      func(interface{}) []interface{}
    examples    []interface{}
    iterations  int
}

type Generator interface {
    Generate() interface{}
    Shrink(value interface{}) []interface{}
}

// Built-in generators
func IntGenerator(min, max int) Generator { /* implement */ }
func StringGenerator(minLen, maxLen int, charset string) Generator { /* implement */ }
func SliceGenerator(elementGen Generator, minLen, maxLen int) Generator { /* implement */ }
func StructGenerator(fieldGens map[string]Generator) Generator { /* implement */ }

// Stateful testing
type StatefulTest struct {
    initialState func() State
    commands     []Command
    invariants   []func(State) bool
}

type Command interface {
    Precondition(State) bool
    Execute(State) (State, interface{})
    Postcondition(State, interface{}) bool
}

// Example: Testing a concurrent map implementation
func TestConcurrentMapProperties(t *testing.T) {
    prop := &Property{
        name: "concurrent map operations maintain consistency",
        generator: ConcurrentMapCommandGenerator(),
        predicate: func(commands interface{}) bool {
            // Execute commands concurrently and check invariants
        },
        iterations: 1000,
    }
    
    prop.Check(t)
}

type ConcurrentMapCommand struct {
    operation string // "get", "set", "delete"
    key       string
    value     interface{}
}

func (cmd ConcurrentMapCommand) Execute(state State) (State, interface{}) {
    // Execute command and return new state and result
}
```

**FAANG Interview Aspect**: How would you use property-based testing to find edge cases in critical systems like distributed databases?

---

## Exercise 11.5: Performance and Benchmark Testing [HARD]
**Difficulty**: Hard  
**Topic**: Benchmarking, performance testing, regression detection

Build a comprehensive benchmarking and performance testing framework:
1. **Microbenchmarks** with statistical analysis and confidence intervals
2. **Load testing** with realistic traffic patterns and resource monitoring
3. **Performance regression** detection with historical comparison
4. **Memory allocation** tracking and optimization guidance
5. **Benchmark result** analysis and visualization

```go
type BenchmarkSuite struct {
    benchmarks []Benchmark
    baseline   BenchmarkResults
    config     BenchmarkConfig
}

type Benchmark struct {
    name     string
    setup    func(*BenchmarkContext) error
    teardown func(*BenchmarkContext) error
    run      func(*BenchmarkContext)
    warmup   time.Duration
    duration time.Duration
}

type BenchmarkContext struct {
    *testing.B
    metrics MetricsCollector
    profiler Profiler
}

type BenchmarkResults struct {
    Name         string
    Iterations   int64
    Duration     time.Duration
    NsPerOp      int64
    AllocsPerOp  int64
    BytesPerOp   int64
    CustomMetrics map[string]float64
}

type MetricsCollector interface {
    RecordLatency(operation string, duration time.Duration)
    RecordThroughput(operation string, count int64)
    RecordMemory(operation string, bytes int64)
    GetSummary() MetricsSummary
}

// Performance regression detection
type RegressionDetector struct {
    baseline   []BenchmarkResults
    threshold  float64 // percentage change threshold
}

func (rd *RegressionDetector) CheckRegression(current BenchmarkResults) *RegressionReport {
    // Statistical analysis to detect significant performance changes
}

type RegressionReport struct {
    HasRegression bool
    Confidence    float64
    PercentChange float64
    Metric        string
    Baseline      BenchmarkResults
    Current       BenchmarkResults
}

// Load testing framework
type LoadTest struct {
    name         string
    target       string
    scenarios    []LoadScenario
    duration     time.Duration
    rampUp       time.Duration
    rampDown     time.Duration
}

type LoadScenario struct {
    weight      float64
    rps         float64
    requestGen  func() *http.Request
    validator   func(*http.Response) error
}

func (lt *LoadTest) Run() (*LoadTestReport, error) {
    // Execute load test with realistic traffic patterns
}
```

**FAANG Interview Aspect**: How would you design performance tests for a system that needs to handle Black Friday traffic loads?

---

## Exercise 11.6: Test Coverage and Quality Metrics [MEDIUM]
**Difficulty**: Medium  
**Topic**: Code coverage, test quality, metrics collection

Create a comprehensive test quality analysis system:
1. **Coverage analysis** beyond line coverage (branch, condition, path coverage)
2. **Test quality metrics** (assertion density, test complexity, maintainability)
3. **Mutation testing** to evaluate test effectiveness
4. **Test smell detection** (long tests, unclear assertions, excessive mocking)
5. **Coverage gap analysis** with suggestions for improvement

```go
type CoverageAnalyzer struct {
    sourceFiles []string
    testFiles   []string
    options     CoverageOptions
}

type CoverageOptions struct {
    LineCoverage      bool
    BranchCoverage    bool
    ConditionCoverage bool
    PathCoverage      bool
    FunctionCoverage  bool
}

type CoverageReport struct {
    Overall     CoverageStats
    PerFile     map[string]CoverageStats
    PerFunction map[string]CoverageStats
    UncoveredLines []UncoveredLine
    Suggestions []CoverageSuggestion
}

type CoverageStats struct {
    LinesCovered     int
    LinesTotal       int
    BranchesCovered  int
    BranchesTotal    int
    FunctionsCovered int
    FunctionsTotal   int
    Percentage       float64
}

// Mutation testing
type MutationTester struct {
    mutators []Mutator
    testCmd  string
}

type Mutator interface {
    Name() string
    Mutate(source []byte) [][]byte // Return all possible mutations
}

type MutationResult struct {
    Mutant   string
    Killed   bool // Did tests detect the mutation?
    TestOutput string
}

func (mt *MutationTester) RunMutationTests(sourceFile string) (*MutationReport, error) {
    // Generate mutations and run tests
}

// Test quality analysis
type TestQualityAnalyzer struct {
    rules []QualityRule
}

type QualityRule interface {
    Name() string
    Check(testFile []byte) []QualityIssue
}

type QualityIssue struct {
    Rule        string
    Severity    Severity
    Line        int
    Column      int
    Description string
    Suggestion  string
}

// Built-in quality rules
type LongTestRule struct {
    maxLines int
}

func (ltr LongTestRule) Check(testFile []byte) []QualityIssue {
    // Check for tests that are too long
}
```

**FAANG Interview Aspect**: How would you ensure high test quality across a large engineering organization with hundreds of developers?

---

## Challenge Problems

### Challenge 11.A: AI-Assisted Test Generation [EXPERT]
**Difficulty**: Expert  
**Topic**: AI/ML, automatic test generation, code analysis

Build an AI-powered system for automatic test generation:
1. **Code analysis** to understand function behavior and edge cases
2. **Test case generation** using machine learning models
3. **Test oracle generation** with expected behavior prediction
4. **Test maintenance** with automatic updates when code changes
5. **Quality assessment** of generated tests

**Technical Challenges**:
- How do you train models on codebases?
- How do you ensure generated tests are meaningful?
- How do you handle complex business logic?

### Challenge 11.B: Distributed Test Execution System [EXPERT]
**Difficulty**: Expert  
**Topic**: Distributed systems, test parallelization, resource management

Design a distributed test execution system:
1. **Test distribution** across multiple machines with optimal scheduling
2. **Resource management** for different test types (CPU, memory, I/O intensive)
3. **Failure handling** with automatic retry and result aggregation
4. **Test isolation** in shared environments
5. **Result collection** and reporting across distributed executions

**System Design Challenges**:
- How do you handle test dependencies in distributed execution?
- How do you ensure test isolation across different machines?
- How do you optimize test scheduling for minimal total execution time?

---

## Knowledge Validation Questions

1. **Test Design**: What makes a good unit test? How do you balance thoroughness with maintainability?

2. **Mock Strategy**: When should you use mocks vs real implementations? What are the trade-offs?

3. **Test Flakiness**: What causes flaky tests and how do you prevent them?

4. **Coverage Metrics**: Is 100% code coverage a good goal? What are more meaningful quality metrics?

5. **Integration Testing**: How do you test integration points without making tests slow and brittle?

---

## Testing Strategy Challenges

### Challenge 11.C: Testing Strategy for Complex System
Design a testing strategy for an e-commerce platform with:
- Microservices architecture
- Real-time inventory management
- Payment processing
- Recommendation engine
- Mobile and web clients

### Challenge 11.D: Legacy System Testing
Create a testing strategy for adding tests to a large legacy codebase:
- No existing tests
- Tightly coupled code
- External dependencies
- Business critical functionality

---

## Code Review Scenarios

### Scenario 11.A: Test Structure
```go
func TestUserService_CreateUser(t *testing.T) {
    // Setup
    db := &MockDatabase{}
    validator := &MockValidator{}
    service := NewUserService(db, validator)
    
    user := &User{
        Name:  "John Doe",
        Email: "john@example.com",
        Age:   30,
    }
    
    db.On("CreateUser", mock.Anything).Return(nil)
    validator.On("Validate", mock.Anything).Return(nil)
    
    // Execute
    err := service.CreateUser(user)
    
    // Assert
    assert.NoError(t, err)
    db.AssertExpectations(t)
    validator.AssertExpectations(t)
}
```

### Scenario 11.B: Table-Driven Test
```go
func TestCalculator_Add(t *testing.T) {
    tests := []struct {
        name     string
        a, b     int
        expected int
    }{
        {"positive numbers", 2, 3, 5},
        {"negative numbers", -2, -3, -5},
        {"zero", 0, 5, 5},
        {"large numbers", 1000000, 2000000, 3000000},
    }
    
    calc := NewCalculator()
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result := calc.Add(tt.a, tt.b)
            if result != tt.expected {
                t.Errorf("Add(%d, %d) = %d, want %d", tt.a, tt.b, result, tt.expected)
            }
        })
    }
}
```

### Scenario 11.C: Integration Test
```go
func TestUserAPI_Integration(t *testing.T) {
    if testing.Short() {
        t.Skip("skipping integration test")
    }
    
    // Start test database
    db := startTestDatabase(t)
    defer db.Close()
    
    // Start test server
    server := startTestServer(t, db)
    defer server.Close()
    
    // Test user creation
    user := User{Name: "Test User", Email: "test@example.com"}
    resp, err := http.Post(server.URL+"/users", "application/json", 
        strings.NewReader(`{"name":"Test User","email":"test@example.com"}`))
    
    require.NoError(t, err)
    assert.Equal(t, http.StatusCreated, resp.StatusCode)
    
    // Test user retrieval
    // ... more test steps
}
```

Evaluate each scenario for test quality, maintainability, and effectiveness.