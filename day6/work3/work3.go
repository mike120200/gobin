package work3

import (
	"bufio"
	"compress/zlib"
	"fmt"
	"io"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"
)

func ReadFile(inpath string, writer1 *bufio.Writer, writer2 *zlib.Writer) {
	fin, err1 := os.Open(inpath)
	if err1 != nil {
		fmt.Println(err1)
		return
	}
	defer fin.Close()
	reader := bufio.NewReader(fin)
	for {
		if line, err2 := reader.ReadString('\n'); err2 != nil {
			if err2 == io.EOF {
				if len(line) > 0 {
					writer1.WriteString(line)
					writer1.WriteString("\n")
					writer2.Write([]byte(line))
					writer2.Write([]byte{'\n'})
				}
				break
			}
		} else {
			writer1.WriteString(line)
			writer2.Write([]byte(line))
		}

	}
}
func Mergefile(dir string) {
	fout, err1 := os.OpenFile("big.txt", os.O_CREATE|os.O_TRUNC|os.O_WRONLY, os.ModePerm)
	if err1 != nil {
		fmt.Println(err1)
		return
	}
	fout2, err2 := os.OpenFile("big.zlib", os.O_CREATE|os.O_TRUNC|os.O_WRONLY, os.ModePerm)
	if err2 != nil {
		fmt.Println(err1)
		return
	}
	defer fout.Close()
	defer fout2.Close()
	writer1 := bufio.NewWriter(fout)
	writer2 := zlib.NewWriter(fout2)

	if files, err3 := ioutil.ReadDir(dir); err3 != nil {
		fmt.Println(err3)
		return
	} else {
		for _, file := range files {
			if file.IsDir() {
				continue
			} else {
				basename := file.Name()
				if strings.HasSuffix(basename, ".txt") {
					filepath := filepath.Join(dir, basename)
					ReadFile(filepath, writer1, writer2)
				}
			}
		}
	}
	writer1.Flush()
	writer2.Flush()
}
