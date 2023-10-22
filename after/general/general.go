package general

import (
	"context"
	"errors"
	"fmt"
	"io"
	"net/http"
	"os"

	"github.com/jackc/pgx/v5"
)

// 处理图片文字信息
func Recivefile(conn *pgx.Conn, w http.ResponseWriter, r *http.Request, name string, jungle string) {
	err1 := r.ParseMultipartForm(10 << 20)
	if err1 != nil {
		http.Error(w, "无法解析文件", http.StatusBadRequest)
	}
	File, handler, err2 := r.FormFile("file")
	if err2 != nil {
		http.Error(w, "无法检索到此文件", http.StatusBadRequest)
	}
	defer File.Close()
	prefix := "/root/Documents/"
	filePath := fmt.Sprintf("%s%s", prefix, handler.Filename)
	dstFile, err3 := os.Create(filePath)
	if err3 != nil {
		http.Error(w, "无法创建目标文件", http.StatusInternalServerError)
		return
	}
	defer dstFile.Close()

	_, err4 := io.Copy(dstFile, File)
	if err4 != nil {
		http.Error(w, "无法写入目标文件", http.StatusInternalServerError)
		return
	}
	fmt.Fprintf(w, "文件上传成功")
	err5 := Insertfile(handler.Filename, filePath, name, conn, jungle)
	if err5 != nil {
		fmt.Fprintf(w, "文件插入数据库失败")
		return
	}

}

// 文件信息插入数据库
func Insertfile(file_name string, file_path string, name string, conn *pgx.Conn, jungle string) error {
	if jungle == "2" {
		_, err := conn.Exec(context.Background(), "insert into file(name,filename,filepath) values($1,$2,$3)", name, file_name, file_path)
		if err != nil {
			return err
		}

	} else if jungle == "9" {
		var filepath string
		i := 2
		filerow, err3 := conn.Query(context.Background(), "select filepath from file where name=$1 ", name)
		if err3 != nil {
			return errors.New("找文件路径出错")
		}
		for filerow.Next() {
			err4 := filerow.Scan(&filepath)
			if err4 != nil {
				return errors.New("数据库扫描发生错误")
			}
		}
		filerow.Close()
		countfilerow, err5 := conn.Query(context.Background(), "select filepath from file where filepath=$1 ", filepath)
		if err5 != nil {
			return errors.New("是否有重复路径时出错")
		}
		for countfilerow.Next() {
			err6 := filerow.Scan(&filepath)
			if err6 != nil {
				return errors.New("数据库扫描发生错误")
			}
			i--
		}
		filerow.Close()
		if i == 1 {
			err7 := os.Remove(filepath)
			if err7 != nil {
				return errors.New("删除文件出错")
			}

		}
		filerow.Close()
		_, err := conn.Exec(context.Background(), "update file set filename=$1,filepath=$2 where name=$3 ", file_name, file_path, name)
		if err != nil {
			return err
		}

	}
	return nil
}

// 数据库拿出文件信息
func Getfile(conn *pgx.Conn, name string) (string, error) {
	var filepath string
	rows, err := conn.Query(context.Background(), "select filepath from file where name=$1", name)
	if err != nil {
		return "", err
	}
	defer rows.Close()
	if rows.Next() {
		rows.Scan(&filepath)
	} else {
		return "", errors.New("no message")
	}
	return filepath, nil
}

// 删除用户
func Deletes(name string, conn *pgx.Conn) error {
	rows, err1 := conn.Query(context.Background(), "select name from my_user where name=$1", name)
	if err1 != nil {
		return errors.New("发生错误")
	}
	var result string
	var filepath string
	i := 2
	if rows.Next() {
		err2 := rows.Scan(&result)
		if err2 != nil {
			return errors.New("数据库扫描出错")
		}
	}
	rows.Close()
	if result != "" {
		_, err2 := conn.Exec(context.Background(), "delete from my_user where name=$1", name)
		if err2 != nil {
			return errors.New("发生错误,请重新操作")
		}
		filerow, err3 := conn.Query(context.Background(), "select filepath from file where name=$1 ", name)
		if err3 != nil {
			return errors.New("找文件路径出错")
		}
		for filerow.Next() {
			err4 := filerow.Scan(&filepath)
			if err4 != nil {
				return errors.New("数据库扫描发生错误")
			}
		}
		filerow.Close()
		countfilerow, err5 := conn.Query(context.Background(), "select filepath from file where filepath=$1 ", filepath)
		if err5 != nil {
			return errors.New("是否有重复路径时出错")
		}
		for countfilerow.Next() {
			err6 := filerow.Scan(&filepath)
			if err6 != nil {
				return errors.New("数据库扫描发生错误")
			}
			i--
		}
		filerow.Close()
		if i == 1 {
			err7 := os.Remove(filepath)
			if err7 != nil {
				return errors.New("删除文件出错")
			}

		}

		_, err8 := conn.Exec(context.Background(), "delete from file where name=$1", name)
		if err8 != nil {
			return errors.New("发生错误,请重新操作")
		}
		return nil
	} else {
		return errors.New("无此用户信息")
	}
}
