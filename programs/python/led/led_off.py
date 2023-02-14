import Jetson.GPIO as GPIO

# GPIO23をOFFにするコード
GPIO.setmode(GPIO.BOARD)
GPIO.setup(23, GPIO.OUT)
GPIO.output(23, GPIO.LOW) #LEDをOFF
GPIO.cleanup()
