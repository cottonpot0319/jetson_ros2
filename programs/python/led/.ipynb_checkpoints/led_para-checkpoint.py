import Jetson.GPIO as GPIO

# 3個のGPIOをまとめて初期化
GPIO.setmode(GPIO.BOARD)
channels = [18, 12, 23]
GPIO.setup(channels, GPIO.OUT)
GPIO.output(23, GPIO.LOW)
GPIO.cleanup()
