
FROM archlinux:latest

RUN pacman -Sy gcc --noconfirm;
RUN pacman -Sy clang --noconfirm;
RUN pacman -Sy make --noconfirm;
RUN pacman -Sy extra/cmake --noconfirm;
RUN pacman -Sy git --noconfirm;
RUN pacman -Sy base-devel --noconfirm;
RUN pacman -Sy dbus --noconfirm;
RUN mkdir -p /var/run/dbus
WORKDIR /software

RUN git clone --depth=1 https://github.com/Kistler-Group/sdbus-cpp.git


WORKDIR /software/sdbus-cpp/build

RUN cmake .. -DCMAKE_BUILD_TYPE=Release
RUN make  .
RUN cmake --build . --target install

WORKDIR /cppdbus

COPY . .

WORKDIR /cppdbus/build

RUN cmake .. -DCMAKE_BUILD_TYPE=Release
RUN make 
ENTRYPOINT ["/bin/bash", "/cppdbus/container/start.sh"]