package main

import (
  "fmt"
  "net/http"
)

func HomeHandler(w http.ResponseWriter, r *http.Request) {
  fmt.Fprintln(w, "<h1>Welcome to Eric Manny Industries</h1><p>Best online store for exclusive products!</p>")
}

func ProductsHandler(w http.ResponseWriter, r *http.Request) {
  fmt.Fprintln(w, "<h1>Our Products</h1><p>Explore the wide range of products we offer!</p>")
}

func AboutHandler(w http.ResponseWriter, r *http.Request) {
  fmt.Fprintln(w, "<h1>About Us</h1><p>Eric Manny Industries, leading the way in e-commerce innovation!</p>")
}

