package manage

import (
	"after/user"
	"context"
	"errors"

	"github.com/jackc/pgx/v5"
)

type Managing_user struct {
	Name     string
	Password string
	State    string
}

// 查询匹配
func Managequery(m *Managing_user, conn *pgx.Conn) (string, error) {
	var result string
	rows, err := conn.Query(context.Background(), "select password from my_user where name=$1", m.Name)
	if err != nil {
		panic(err)
	}
	//延迟关闭rows
	defer rows.Close()
	if rows.Next() {
		rows.Scan(&result)
	}
	if result == "" {
		return "", errors.New("查无此人")
	} else {
		m.Password = result
	}
	return m.Password, nil
}

// 登录
func (m Managing_user) Login(conn *pgx.Conn) error {
	var compare Managing_user
	var err error
	compare.Name = m.Name
	compare.Password, err = Managequery(&compare, conn)
	if err != nil {
		return err
	}
	if m.Password == compare.Password {
		return nil
	} else {
		return errors.New("密码错误，登录失败")
	}
}

// 列出所有人
func (m Managing_user) Listallusers(conn *pgx.Conn) ([]user.My_user, error) {
	rows, err := conn.Query(context.Background(), "select *from my_user")
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	list := []user.My_user{}
	for rows.Next() {
		var u user.My_user
		err1 := rows.Scan(&u.Name, &u.Password, &u.Email, &u.Phone, &u.Note, &u.State)
		if err1 != nil {
			return nil, err1
		}
		list = append(list, u)
	}

	return list, nil
}

// 根据用户名找人
func (m Managing_user) Finduser(name string, conn *pgx.Conn) (user.My_user, error) {
	var result user.My_user
	rows, err := conn.Query(context.Background(), "select *from my_user where name=$1", name)
	if err != nil {
		return result, errors.New("Error")
	}
	defer rows.Close()

	if rows.Next() {
		err2 := rows.Scan(&result.Name, &result.Password, &result.Email, &result.Phone, &result.Note, &result.State)
		if err2 != nil {
			return result, errors.New("扫描报错")
		}
	}
	return result, nil

}

// 禁止用户登录
func (m Managing_user) Forbiduser(name string, conn *pgx.Conn) error {
	rows, err1 := conn.Query(context.Background(), "select name from my_user where name=$1", name)
	if err1 != nil {
		return errors.New("发生错误")
	}
	if rows.Next() {
		s := "禁止登录"
		rows.Close()
		_, err2 := conn.Exec(context.Background(), "update my_user set  mystates=$1  where name=$2 ", s, name)
		if err2 != nil {
			return err2
		}
		return nil
	} else {
		return errors.New("无此用户")
	}
}

// 允许用户登录
func (m Managing_user) Allowuser(name string, conn *pgx.Conn) error {
	var state string
	rows, err1 := conn.Query(context.Background(), "select mystates from my_user where name=$1", name)
	if err1 != nil {
		return errors.New("发生错误")
	}
	if rows.Next() {
		err2 := rows.Scan(&state)
		defer rows.Close()
		if err2 != nil {
			return errors.New("扫描数据库出错")
		}
		if state == "禁止登录" {
			s := "可登录"
			rows.Close()
			_, err3 := conn.Exec(context.Background(), "update my_user set  mystates=$1  where name=$2 ", s, name)
			if err3 != nil {
				return err3
			}
			return nil
		} else {

			return errors.New("此人已被允许")
		}
	} else {

		return errors.New("无此用户")
	}

}
