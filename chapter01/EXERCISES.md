# Chapter 1: Tutorial - Exercises

## Exercise 1.1: Command-Line Arguments Enhancement [ELEMENTARY]
**Difficulty**: Easy  
**Topic**: os.Args, string manipulation

Modify the echo program to print the index and value of each argument, one per line.

---

## Exercise 1.2: Argument Separator [MEDIUM]
**Difficulty**: Medium  
**Topic**: Command-line processing, string handling

Write a program that prints all command-line arguments separated by a single space, but implements three different approaches:
1. Using `strings.Join()`
2. Using a loop with `+=` concatenation
3. Using `fmt.Sprint()` family of functions

Compare performance using benchmarks. Which approach would you choose for production code and why?

---

## Exercise 1.3: Duplicate Line Counter with Line Numbers [HARD]
**Difficulty**: Hard  
**Topic**: File I/O, maps, complex data structures

Extend the duplicate line finder to:
1. Show the line numbers where each duplicate occurs
2. Support reading from multiple files simultaneously
3. Handle very large files (>1GB) efficiently
4. Provide a flag to show only duplicates that appear more than N times

**FAANG Interview Aspect**: How would you optimize memory usage for extremely large files? What if the file doesn't fit in memory?

---

## Exercise 1.4: HTTP Server with Rate Limiting [HARD]
**Difficulty**: Hard  
**Topic**: HTTP servers, concurrency, rate limiting

Create an HTTP server that:
1. Serves a simple counter that increments on each request
2. Implements rate limiting (max 10 requests per minute per IP)
3. Provides different endpoints: `/`, `/counter`, `/health`
4. Logs all requests with timestamps
5. Handles graceful shutdown on SIGTERM

**FAANG Interview Aspect**: How would you implement distributed rate limiting across multiple server instances?

---

## Exercise 1.5: Concurrent Web Fetcher [HARD]
**Difficulty**: Hard  
**Topic**: Concurrency, HTTP clients, error handling

Build a program that:
1. Fetches multiple URLs concurrently
2. Implements timeout and retry logic
3. Tracks and reports download speeds
4. Handles various HTTP response codes appropriately
5. Provides progress reporting for long-running downloads

Requirements:
- Use worker pools to limit concurrent connections
- Implement exponential backoff for retries
- Handle context cancellation properly

**FAANG Interview Aspect**: How would you handle rate limiting from the server side? How would you optimize for both bandwidth and latency?

---

## Exercise 1.6: Lissajous Animation with Customization [MEDIUM]
**Difficulty**: Medium  
**Topic**: Mathematical computation, web serving, parameter handling

Enhance the Lissajous program to:
1. Accept query parameters for frequency, phase, colors
2. Generate animations with different mathematical functions
3. Support multiple output formats (SVG, PNG, GIF)
4. Implement animation caching for identical parameters

**FAANG Interview Aspect**: How would you optimize the mathematical calculations for better performance?

---

## Challenge Problems

### Challenge 1.A: Distributed Log Analyzer [EXPERT]
**Difficulty**: Expert  
**Topic**: System design, large-scale data processing

Design and implement a system that:
1. Processes log files from multiple servers in real-time
2. Identifies patterns and anomalies
3. Provides real-time dashboards
4. Scales horizontally

**System Design Questions**:
- How would you handle log files that are several terabytes?
- How would you ensure no log entries are lost?
- How would you handle schema evolution in log formats?

### Challenge 1.B: High-Performance HTTP Load Balancer [EXPERT]
**Difficulty**: Expert  
**Topic**: Network programming, load balancing algorithms

Implement a Layer 7 HTTP load balancer with:
1. Multiple load balancing algorithms (round-robin, least connections, weighted)
2. Health checks for backend servers
3. SSL termination
4. Request routing based on URL patterns
5. Circuit breaker pattern implementation

**Performance Requirements**:
- Handle 100K+ requests per second
- Sub-millisecond routing decisions
- Minimal memory allocation per request

---

## Knowledge Validation Questions

1. **Memory Management**: In the duplicate line finder, why might using a `map[string][]int` be better than `map[string]int` for storing line numbers? What are the memory implications?

2. **Concurrency Patterns**: When would you use buffered vs unbuffered channels in the web fetcher? How does buffer size affect performance?

3. **Error Handling**: Design an error handling strategy for the HTTP server that distinguishes between recoverable and non-recoverable errors.

4. **Performance**: What are the performance implications of using `fmt.Sprintf()` vs `strings.Builder` vs `bytes.Buffer` for string construction?

5. **Testing**: How would you write integration tests for the rate-limited HTTP server? What edge cases would you test?