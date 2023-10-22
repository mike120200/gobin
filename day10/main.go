package main

import (
	"fmt"
	"io"
	"net/http"
	"os"
)

func boys(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "boy")
	io.Copy(os.Stdout, r.Body)
	for k, v := range r.Header {
		fmt.Printf("key=%s,value=%v\n", k, v)
	}
}
func main() {
	http.HandleFunc("/boy", boys)
	http.ListenAndServe(":5656", nil)
}
