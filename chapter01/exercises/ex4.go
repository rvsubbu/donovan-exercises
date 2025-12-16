/**
	Exercise 1.4: HTTP Server with Rate Limiting [HARD]
	Difficulty: Hard  **Topic**: HTTP servers, concurrency, rate limiting

	Create an HTTP server that:
		1. Serves a simple counter that increments on each request
		2. Implements rate limiting (max 10 requests per minute per IP)
		3. Provides different endpoints: `/`, `/counter`, `/health`
		4. Logs all requests with timestamps
		5. Handles graceful shutdown on SIGTERM

	FAANG Interview Aspect: How would you implement distributed rate limiting across multiple server instances?
		Implement this in "frontware" like istio or haproxy
		Use a simplistic config approach - rate per ip is multi-ip rate divided by num of ips
		Use a key store like redis
**/

package exercises

import (
	"context"
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"sync/atomic"
	"time"

    "github.com/go-chi/chi/v5"
    "github.com/go-chi/chi/v5/middleware"
    "github.com/go-chi/httprate"
)

var counter atomic.Int64

func NewChiRouter() {
		r := chi.NewRouter()
		r.Use(middleware.RequestID)
		r.Use(middleware.Logger)
		r.Use(middleware.Recoverer)
		r.Use(httprate.LimitByIP(10, time.Minute))

		r.Get("/", func(w http.ResponseWriter, r *http.Request) {
			w.Header().Set("Content-Type", "text/plain")
			w.Write([]byte("hello world\n"))
		})

		r.Get("/counter", func(w http.ResponseWriter, r *http.Request) {
			val := counter.Add(1)
			w.Header().Set("Content-Type", "application/json")
			w.Write([]byte(fmt.Sprintf(`{"count": %d}`, val)))
		})

		r.Get("/health", func(w http.ResponseWriter, r *http.Request) {
			w.Header().Set("Content-Type", "text/plain")
			w.Write([]byte("OK\n"))
		})

		done := make(chan bool)
		quit := make(chan os.Signal, 1)
		signal.Notify(quit, os.Interrupt, syscall.SIGTERM, syscall.SIGINT)

		go func() {
			sig := <-quit
			fmt.Printf("Caught a kill signal %+v, exiting\n", sig)
			done <- true
		}()

		server := http.Server{Addr: ":3333", Handler: r}
		go func() {
			fmt.Println("Starting server on port 3333")
			if err := server.ListenAndServe(); err != nil {
				fmt.Printf("ListenAndServe error %s, exiting\n", err.Error())
				done <- true
			}
		}()

		<-done

		ctx, cancel := context.WithTimeout(context.Background(), 30 * time.Second)
		defer cancel()

		server.SetKeepAlivesEnabled(false)
		if err := server.Shutdown(ctx); err != nil {
			fmt.Printf("Could not shut down server with error %s\n", err.Error())
		}
		fmt.Println("Server shutdown")
}
