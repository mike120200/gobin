package main

import (
	"container/heap"
	"fmt"
	"time"
)

type HeapNode struct {
	value    int //对应key
	deadline int //到期时间戳，精确到秒
}

type Heap []*HeapNode

func (h Heap) Len() int {
	return len(h)
}
func (h Heap) Less(i, j int) bool {
	return h[i].deadline < h[j].deadline
}
func (h Heap) Swap(i, j int) {
	h[i], h[j] = h[j], h[i]
}
func (h *Heap) Push(x interface{}) {
	node := x.(HeapNode)
	*h = append(*h, &node)
}
func (h *Heap) Pop() (x interface{}) {
	n := len(*h)
	last := (*h)[n-1]
	*h = (*h)[0 : n-1]
	return last
}

type TimeoutCache struct {
	cache map[int]interface{}
	hp    Heap
}

func NewTimeoutCache(cap int) *TimeoutCache {
	tc := new(TimeoutCache)
	tc.cache = make(map[int]interface{}, cap)
	tc.hp = Heap{}
	heap.Init(&tc.hp)
	return tc
}

func (tc *TimeoutCache) Add(key int, value interface{}, life int) {
	tc.cache[key] = value
	//计算截止时间
	deadline := int(time.Now().Unix()) + life
	node := HeapNode{value: key, deadline: deadline}
	heap.Push(&tc.hp, node)
}

func (tc TimeoutCache) Get(key int) (interface{}, bool) {
	value, exists := tc.cache[key]
	return value, exists
}

func (tc *TimeoutCache) taotai() {
	for {
		if tc.hp.Len() == 0 {
			time.Sleep(100 * time.Millisecond)
			continue
		}
		now := int(time.Now().Unix())
		top := tc.hp[0]
		if top.deadline < now {
			heap.Remove(&tc.hp, 0)
			delete(tc.cache, top.value)
		} else { //堆顶没到期
			time.Sleep(1 * time.Second)
		}
	}
}

func testTimeout() {
	tc := NewTimeoutCache(10)
	go tc.taotai() //在子协程执行，不影响主协程
	tc.Add(1, "1", 1)
	tc.Add(2, "2", 3)
	tc.Add(3, "3", 4)
	time.Sleep(2 * time.Second)
	for _, key := range []int{1, 2, 3} {
		_, exists := tc.Get(key)
		fmt.Printf("key %d exists %t\n", key, exists)
	}

}

func main3() {
	testTimeout()
}
