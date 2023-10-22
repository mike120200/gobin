package user

import (
	"context"
	"errors"

	"github.com/jackc/pgx/v5"
)

type My_user struct {
	Name     string
	Password string
	Email    string
	Phone    string
	Note     string
	State    string
}

// 查询数据库
func Userquery(u *My_user, conn *pgx.Conn) (string, string, error) {
	var password string
	var state string
	rows, err := conn.Query(context.Background(), "select password,mystates from my_user where name=$1", u.Name)
	if err != nil {
		panic(err)
	}
	//延迟关闭rows
	defer rows.Close()
	if rows.Next() {
		rows.Scan(&password, &state)
	}
	if password == "" {
		return "", "", errors.New("查无此人")
	} else {
		return password, state, nil
	}
}

// 登录
func (u My_user) Login(conn *pgx.Conn) error {
	var compare My_user
	var err error

	compare.Name = u.Name
	compare.Password, compare.State, err = Userquery(&compare, conn)
	if err != nil {
		return err
	}
	if u.Password == compare.Password && compare.State == "可登录" {
		return nil
	} else {
		return errors.New("密码错误或已被禁止登录，登录失败")
	}
}

// 注册
func (u My_user) Resgister(conn *pgx.Conn) error {
	rows, err1 := conn.Query(context.Background(), "select name from my_user where name=$1", u.Name)
	if err1 != nil {
		return err1
	}
	defer rows.Close()
	var result string
	for rows.Next() {
		rows.Scan(&result)
	}
	if u.Name == result {
		return errors.New("此用户已经存在")
	} else {
		_, err2 := conn.Exec(context.Background(), "insert into my_user(name,password,email,phone,note)  values($1,$2,$3,$4,$5)", u.Name, u.Password, u.Email, u.Phone, u.Note)
		if err2 != nil {
			return errors.New("修改出现bug")
		} else {
			return nil
		}
	}
}

// 查看自己信息
func (u *My_user) Checkmyself(conn *pgx.Conn) error {
	rows, err := conn.Query(context.Background(), "select *from my_user where name=$1", u.Name)
	if err != nil {
		return errors.New("查看失败，请重新操作")
	}
	defer rows.Close()
	if rows.Next() {
		rows.Scan(&u.Name, &u.Password, &u.Email, &u.Phone, &u.Note, &u.State)
	}
	return nil
}

// 修改自己的信息
func (u My_user) Changeone(selectone string, changeone string, conn *pgx.Conn) error {
	if selectone == "name" {
		_, err1 := conn.Exec(context.Background(), "update my_user set name=$1  where name=$2", changeone, u.Name)
		if err1 != nil {
			return errors.New("更改失败")
		}
		_, err2 := conn.Exec(context.Background(), "update file set name=$1 where name=$2", changeone, u.Name)
		if err2 != nil {
			return errors.New("更改失败")
		}
		return nil
	} else if selectone == "password" {
		_, err := conn.Exec(context.Background(), "update my_user set password=$1  where name=$2", changeone, u.Name)
		if err != nil {
			return errors.New("更改失败")
		}
		return nil
	} else if selectone == "email" {
		_, err := conn.Exec(context.Background(), "update my_user set email=$1  where name=$2", changeone, u.Name)
		if err != nil {
			return errors.New("更改失败")
		}
		return nil
	} else if selectone == "phone" {
		_, err := conn.Exec(context.Background(), "update my_user set phone=$1  where name=$2", changeone, u.Name)
		if err != nil {
			return errors.New("更改失败")
		}
		return nil
	} else {
		_, err := conn.Exec(context.Background(), "update my_user set note=$1  where name=$2", changeone, u.Name)
		if err != nil {
			return errors.New("更改失败")
		}
		return nil
	}
}
