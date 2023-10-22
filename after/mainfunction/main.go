package main

import (
	"after/general"
	"after/manage"
	"after/system"
	"after/user"
	"context"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"net/http"
	"os"

	"github.com/jackc/pgx/v5"
)

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Println("有东西来")
	ctx := context.Background()
	connstr := "postgres://postgres:cst4Ever@192.168.2.104:5432/postgres"
	conn, err := pgx.Connect(ctx, connstr)
	if err != nil {
		fmt.Fprintf(w, err.Error())
		return
	}
	defer conn.Close(ctx)
	jungle := r.URL.Query().Get("jungle")
	switch jungle {
	//渲染图片
	case "0":
		name := r.URL.Query().Get("name")
		filepath, err1 := general.Getfile(conn, name)
		if err1 != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		imgFile, err2 := os.ReadFile(filepath)
		if err2 != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		imgBase64 := base64.StdEncoding.EncodeToString(imgFile)
		w.Write([]byte(imgBase64))
	case "1":
		name := r.URL.Query().Get("name")
		password := r.URL.Query().Get("password")
		if name == "manage" {
			var m manage.Managing_user
			m.Name = name
			m.Password = password
			system.Enter(conn, m, w)
		} else {
			var u user.My_user
			u.Name = name
			u.Password = password
			system.Enter(conn, u, w)
		}
	case "2":
		name := r.URL.Query().Get("name")
		password := r.URL.Query().Get("password")
		email := r.URL.Query().Get("email")
		phone := r.URL.Query().Get("phone")
		note := r.URL.Query().Get("note")
		var u user.My_user
		u.Name = name
		u.Password = password
		u.Email = email
		u.Phone = phone
		u.Note = note
		err := u.Resgister(conn)
		if err != nil {
			fmt.Fprintf(w, err.Error())
			return
		}
		general.Recivefile(conn, w, r, name, jungle)
		fmt.Fprintf(w, "注册成功")
	case "3":
		var m manage.Managing_user
		list, err1 := m.Listallusers(conn)
		if err1 != nil {
			return
		}
		jsonreponse, err := json.Marshal(list)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		w.Header().Set("Content-Type", "application/json")
		w.Write(jsonreponse)
	case "4":
		name := r.URL.Query().Get("name")
		var m manage.Managing_user
		u, err1 := m.Finduser(name, conn)
		if err1 != nil {
			http.Error(w, err1.Error(), http.StatusCreated)
			return
		}
		jsonu, err2 := json.Marshal(u)
		if err2 != nil {
			http.Error(w, err2.Error(), http.StatusInternalServerError)
			return
		}
		w.Header().Set("Content-Type", "application/json")
		w.Write(jsonu)
	case "5":
		name := r.URL.Query().Get("name")
		howdo := r.URL.Query().Get("howdo")
		var m manage.Managing_user
		if howdo == "forbid" {
			err := m.Forbiduser(name, conn)
			if err != nil {
				fmt.Fprintf(w, err.Error())
				return
			}
			fmt.Fprintf(w, "操作成功，已禁止")
			return
		} else if howdo == "allow" {
			err := m.Allowuser(name, conn)
			if err != nil {
				fmt.Fprintf(w, err.Error())
				return
			}
			fmt.Fprintf(w, "操作成功，已运行")
			return
		}
	case "6":
		name := r.URL.Query().Get("name")
		err := general.Deletes(name, conn)
		if err != nil {
			fmt.Fprintf(w, err.Error())
			return
		}
		fmt.Fprintf(w, "删除成功")
	case "7":
		var u *user.My_user = &user.My_user{}
		var err1 error
		u.Name = r.URL.Query().Get("name")
		err1 = u.Checkmyself(conn)
		if err1 != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		jsonu, err2 := json.Marshal(*u)
		if err2 != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		w.Header().Set("Content-Type", "application/json")
		w.Write(jsonu)
	case "8":
		selectone := r.URL.Query().Get("selectone")
		changeone := r.URL.Query().Get("changeone")
		name := r.URL.Query().Get("name")
		var u user.My_user
		u.Name = name
		err := u.Changeone(selectone, changeone, conn)
		if err != nil {
			fmt.Fprintf(w, err.Error())
			return
		}
		fmt.Fprintf(w, "修改成功")
	case "9":
		name := r.URL.Query().Get("name")
		general.Recivefile(conn, w, r, name, jungle)
		fmt.Fprintf(w, "更改成功，请刷新查看结果")
	}
	return
}

func main() {
	fmt.Println("hello world")
	http.HandleFunc("/", handler)
	http.ListenAndServe(":6160", nil)
}
