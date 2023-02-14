import Jetson.GPIO as GPIO

# GPIO23をONにするコード
GPIO.setmode(GPIO.BOARD)
GPIO.setup(23, GPIO.OUT)
GPIO.output(23, GPIO.HIGH) # LEDをON
GPIO.cleanup()
