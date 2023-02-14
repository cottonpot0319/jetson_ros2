import cv2

def main():
    cam = cv2.VideoCapture(cv2.CAP_V4L)

    while cam.isOpened():
        ret, frame = cam.read()

        if not ret:
            break

        cv2.imshow("img", frame)
        if cv2.waitKey(1) == 27:
            break

    cv2.destroyAllWindows()
    cam.release()


if __name__ == "__main__":
    main()