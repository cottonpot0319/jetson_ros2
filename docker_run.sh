# デバイスの管理設定
sudo xhost +si:localuser:root
sudo xhost +si:localuser:user
XAUTH=/tmp/.docker.xauth
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
chmod 777 $XAUTH

# コンテナの基本設定
docker run --privileged --runtime nvidia -it --rm --network host -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix/:/tmp/.X11-unix:rw \
    -v $XAUTH:$XAUTH -e XAUTHORITY=$XAUTH \
    -v /etc/udev/rules.d:/etc/udev/rules.d \
    -v /dev:/dev \
    -v /sys/class/gpio:/sys/class/gpio \
    -v /sys/class/pwm:/sys/class/pwm \
    -v /sys/devices:/sys/devices \
    -v $PWD:/home/user/ros2_ws/src \
    --device /dev/gpiochip0:/dev/gpiochip0 \
    --device /dev/gpiochip1:/dev/gpiochip1 \
    --device /dev/video0:/dev/video0:mwr \
    --name jetson-ros2 \
    jetson/ros2:foxy-pytorch-l4t-r32.7.1
# docker run --privileged -it --rm --runtime nvidia -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:rw --device /dev/video0:/dev/video0:mwr --name pytorch_ros2 pytorch_ros2:r32.7.1-pth1.10-py3
