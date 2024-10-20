package main

import (
  "net/http"
  "testing"
)

func TestMainRoutes(t *testing.T) {
  resp, err := http.Get("http://localhost:8080/")
  if err != nil || resp.StatusCode != http.StatusOK {
    t.Fatalf("Failed to get Home page: %v", err)
  }

  resp, err = http.Get("http://localhost:8080/products")
  if err != nil || resp.StatusCode != http.StatusOK {
    t.Fatalf("Failed to get Products page: %v", err)
  }
}

