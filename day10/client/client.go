package main

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"strings"
)

func get() {

	res, err := http.Get("http://localhost:5656/boy")
	if err != nil {
		panic(err)
	}
	io.Copy(os.Stdout, res.Body)
	res.Body.Close()
}

func post() {
	reader := strings.NewReader("Love xin")
	res, err := http.Post("http://localhost:5656/user/binbin/vip/guangdong/dongguan", "text/plain", reader)
	if err != nil {
		panic(err)
	}
	io.Copy(os.Stdout, res.Body)
	for k, v := range res.Header {
		fmt.Printf("key=%s,value=%v\n", k, v)
	}
	defer res.Body.Close()
}

func main() {
	post()
}
