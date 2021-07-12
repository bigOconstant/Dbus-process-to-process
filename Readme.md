# Messaging with Dbus in C++

Curious how dbus could be used for process to process communication,

This is a minimal example of a project with three applications. A client and server in C++ and a client in golang.

The Server listens on dbus for a message. `./build/server`. The client sends a message to the server, `./build/client/client "hello world"`.

The server will now print *hello world* and tell the client thanks.

## Building

### Requirements

clang or gcc, make, cmake,and [sdbus-cpp](https://github.com/Kistler-Group/sdbus-cpp) which is used as a high level dbus library. 

### Intructions

for detailed build instructions checkout the [dockerfile](./Dockerfile) which details how the project is built on arch linux.

### Run

To test I suggest testing in docker-compose.

1. `docker-compose build`
2. in one terminal, `docker-compose up`
3. In another terminal, `docker-compose exec dbuscpp /bin/bash -c "source .env && ./build/client 'hello world'"` to test the C++ client or for golang `docker-compose exec dbuscpp /bin/bash -c "source .env && ./go/src/client/dbus 'hello world'"`