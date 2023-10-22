package main

import (
	"fmt"
	"io"
	"net/http"
	"os"

	"github.com/julienschmidt/httprouter"
)

func handle(method string, w http.ResponseWriter, r *http.Request, params httprouter.Params) {
	fmt.Fprintf(w, "the methon is %s", method)
}

func get(w http.ResponseWriter, r *http.Request, params httprouter.Params) {
	a := 0
	b := 3 / a
	fmt.Fprintf(w, "%v", b)
	handle("Get", w, r, params)
}

func post(w http.ResponseWriter, r *http.Request, params httprouter.Params) {
	io.Copy(os.Stdout, r.Body)
	handle("Post", w, r, params)
}

func post2(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	fmt.Printf("name:%s, type:%s, addr:%s\n", p.ByName("name"), p.ByName("type"), p.ByName("addr"))
}

func main() {
	router := httprouter.New()
	router.GET("/", get)
	router.POST("/", post)
	router.POST("/user/:name/:type/*addr", post2)
	router.ServeFiles("/file/*filepath", http.Dir("C:/Users/86137/Desktop/vscode/广州大学官网部分功能"))
	router.PanicHandler = func(w http.ResponseWriter, r *http.Request, i interface{}) {
		w.WriteHeader(http.StatusInternalServerError)
		fmt.Fprintf(w, "error%s\n", i)
	}
	http.ListenAndServe(":5656", router)
}
