package test

import (
	"day6/work1"
	"testing"
)

func TestTimeout(b *testing.T) {
	work1.Timeshow()

}
func BenchmarkTimeout(b *testing.B) {
	for i := 0; i < b.N; i++ {
		work1.Timeshow()
	}
}
