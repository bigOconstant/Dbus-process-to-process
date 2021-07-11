package main

import (
	"fmt"
	"os"

	"github.com/godbus/dbus/v5"
)

func signal(recieved chan bool, signalReady chan bool) {
	conn, err := dbus.ConnectSessionBus()
	if err != nil {
		panic(err)
	}

	if err = conn.AddMatchSignal(
		dbus.WithMatchObjectPath("/org/wolf/Messenger"),
		dbus.WithMatchInterface("org.wolf.Messenger"),
	); err != nil {
		panic(err)
	}

	c := make(chan *dbus.Signal, 10)
	conn.Signal(c)
	signalReady <- true
	for v := range c {
		fmt.Println(v.Body...)
		recieved <- true
		break
	}

	defer conn.Close()

}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Please enter a message to send")
		return
	}
	arg := os.Args[1]
	recieved := make(chan bool)
	signalReady := make(chan bool)
	go signal(recieved, signalReady)
	//Wait til the signal listener is ready to recieve replies
	<-signalReady
	conn, err := dbus.ConnectSessionBus()
	if err != nil {
		panic(err)
	}

	defer conn.Close()

	obj := conn.Object("org.wolf.Messenger", "/org/wolf/Messenger")
	call := obj.Call("org.wolf.Messenger.message", 1,
		arg)

	if call.Err != nil {
		panic(call.Err)
	}

	// Wait for reply to print before exiting
	<-recieved
}
