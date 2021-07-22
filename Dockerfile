
#**********************************
# Base layer, install dependencies*
#**********************************

FROM archlinux:latest as base

RUN pacman -Sy gcc --noconfirm;
RUN pacman -Sy clang --noconfirm;
RUN pacman -Sy make --noconfirm;
RUN pacman -Sy extra/cmake --noconfirm;
RUN pacman -Sy git --noconfirm;
RUN pacman -Sy base-devel --noconfirm;
RUN pacman -Sy dbus --noconfirm;
RUN pacman -Sy go --noconfirm;
RUN mkdir -p /var/run/dbus

WORKDIR /software

RUN git clone --depth=1 https://github.com/Kistler-Group/sdbus-cpp.git
WORKDIR /software/sdbus-cpp/build
RUN cmake .. -DCMAKE_BUILD_TYPE=Release
RUN make  .
RUN cmake --build . --target install
WORKDIR /

#Clean up
RUN rm -rf /software


FROM base as developer
ARG USERNAME=developer
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN pacman -Sy sudo --noconfirm;

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # add sudo support
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
 
 USER $USERNAME
WORKDIR /workspace

CMD ["sleep", "infinity"]
#**************************************
# Final layer, build example projects *
#**************************************

FROM base as final
WORKDIR /cppdbus

COPY . .

# Build golang client
WORKDIR /cppdbus/go/src/client
RUN go build
WORKDIR /cppdbus/build

# Build C++ client and server

RUN cmake .. -DCMAKE_BUILD_TYPE=Release
RUN make 
WORKDIR /cppdbus

ENTRYPOINT ["/bin/bash", "/cppdbus/container/start.sh"]