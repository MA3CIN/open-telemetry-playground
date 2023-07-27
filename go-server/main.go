package main

import (
	"fmt"
	"math/rand"
	"net/http"
	"time"

	networkC "go-server/networkController"

	"go.uber.org/zap"
)

type Server struct {
	rand *rand.Rand
}

func NewServer() *Server {
	rd := rand.New(rand.NewSource(time.Now().Unix()))
	return &Server{
		rand: rd,
	}
}

func (s *Server) getRandom(w http.ResponseWriter, _ *http.Request) {
	n := s.rand.Intn(10)
	sleepTime := n / 10
	time.Sleep(time.Duration(sleepTime))
	logger.Info("getRandom called", zap.Int("randomized number", n))
	fmt.Fprintf(w, "%v", n)
	address := "http://localhost:3000"
	networkC.GetFromAddress(address)
}

var logger *zap.Logger

func setupHandler(s *Server) *http.ServeMux {
	mux := http.NewServeMux()
	mux.HandleFunc("/getRandom", s.getRandom)
	return mux
}

func main() {
	var err error
	logger, err = zap.NewDevelopment()
	if err != nil {
		fmt.Printf("error creating zap logger, error:%v", err)
		return
	}
	port := fmt.Sprintf(":%d", 8080)
	logger.Info("starting http server", zap.String("port", port))

	s := NewServer()
	mux := setupHandler(s)
	if err := http.ListenAndServe(port, mux); err != nil {
		logger.Error("error running server", zap.Error(err))
	}
}
