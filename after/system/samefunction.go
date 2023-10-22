package system

import (
	"fmt"
	"net/http"

	"github.com/jackc/pgx/v5"
)

type Sameabilities interface {
	Login(conn *pgx.Conn) error
}

func Enter(conn *pgx.Conn, s Sameabilities, w http.ResponseWriter) {
	err := s.Login(conn)
	if err != nil {
		fmt.Fprintln(w, err.Error())
	} else {
		fmt.Fprintf(w, "登录成功")
	}
}
