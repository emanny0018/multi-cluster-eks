package main

import (
  "fmt"
  "log"
  "net/http"
  "os"
)

func main() {
  http.HandleFunc("/", HomeHandler)
  http.HandleFunc("/products", ProductsHandler)
  http.HandleFunc("/about", AboutHandler)

  port := getPort()
  fmt.Printf("Starting server on port %s...\n", port)
  if err := http.ListenAndServe(port, nil); err != nil {
    log.Fatal(err)
  }
}

func getPort() string {
  port := os.Getenv("PORT")
  if port == "" {
    port = "8080"
  }
  return ":" + port
}

