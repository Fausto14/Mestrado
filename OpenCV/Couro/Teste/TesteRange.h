#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/highgui/highgui.hpp"
#include <stdlib.h>
#include <stdio.h>

using namespace cv;

/// Global variables

Mat src, src_gray;
Mat dst, detected_edges;

int edgeThresh = 1;
int lowThreshold;
int const max_lowThreshold = 100;
int ratio = 3;
int kernel_size = 3;
char* window_name = "Edge Map";

int H_MIN = 0;
int H_MAX = 256;
int S_MIN = 0;
int S_MAX = 256;
int V_MIN = 0;
int V_MAX = 256;

Mat mask, maskInv, temp_image;

vector<int> small_blobs;

/**
* @function CannyThreshold
* @brief Trackbar callback - Canny thresholds input with a ratio 1:3
*/
void on_trackbar(int, void*)
{
	/// Reduce noise with a kernel 3x3
	//blur(src_gray, detected_edges, Size(3, 3));

	/// Canny detector

	//filter HSV image between values and store filtered image to
	//mask matrix
	inRange(src_gray, Scalar(H_MIN, S_MIN, V_MIN), Scalar(H_MAX, S_MAX, V_MAX), mask);

	Mat element = getStructuringElement(0, Size(9, 9), Point(4, 4));
	morphologyEx(mask, mask, 0, element);//open
	morphologyEx(mask, mask, 1, element);//close

	namedWindow("mask", CV_WINDOW_FREERATIO);
	imshow("mask", mask);

	
	bitwise_not(mask, maskInv);

	maskInv.copyTo(temp_image);

	// find the contours
	vector< vector<Point> > contours;
	findContours(temp_image, contours, CV_RETR_CCOMP, CV_CHAIN_APPROX_SIMPLE);

	// CV_FILLED fills the connected components found
	//drawContours(mask, contours, -1, Scalar(255), CV_FILLED);

	/*
	Before drawing all contours you could also decide
	to only draw the contour of the largest connected component
	found. Here's some commented out code how to do that:
	*/

	vector<double> areas(contours.size());

	for (size_t i = 0; i < contours.size(); ++i) {
		if (contourArea(Mat(contours[i])) < 100000) {
			//areas[i] = contourArea(Mat(contours[i]));
			//small_blobs.push_back(i);
			printf("%d\n", i);
			drawContours(maskInv, contours, i, cv::Scalar(0), CV_FILLED);
		}
	}
	//// fill-in all small contours with zeros
	//for (size_t i = 0; i < small_blobs.size(); ++i) {
	//	drawContours(mask, contours, small_blobs[i], cv::Scalar(255),CV_FILLED);
	//}

	namedWindow("rangeInverse", CV_WINDOW_FREERATIO);
	imshow("rangeInverse", maskInv);
	

	// let's create a new image now
	Mat crop(mask.rows, mask.cols, CV_8UC3);

	// set background to white
	crop.setTo(Scalar(255, 255, 255));
	// and copy the object
	// normalize so imwrite(...)/imshow(...) shows the mask correctly!
	normalize(maskInv.clone(), maskInv, 1.0, 0.0, CV_MINMAX, CV_8UC1);
	
	src.copyTo(crop, maskInv);


	imshow(window_name, crop);
}


/** @function teste */
void teste()
{
	/// Load an image
	String path_img = "C:\\Users\\fadell\\Documents\\Mestrado\\dataBases\\couro_images_cropped\\c4_47.jpg";// argv[1]
	src = imread(path_img);
	/*Scalar value = Scalar(0, 0, 0);
	copyMakeBorder(src, src, 1, 1, 1, 1, BORDER_CONSTANT, value);*/

	/// Create a matrix of the same type and size as src (for dst)
	dst.create(src.size(), src.type());

	/// Convert the image to grayscale
	//cvtColor(src, src_gray, CV_BGR2GRAY);
	//convert frame from BGR to HSV colorspace
	cvtColor(src, src_gray, COLOR_BGR2HSV);

	/// Create a window
	namedWindow(window_name, CV_WINDOW_KEEPRATIO);

	/// Create a Trackbar for user to enter threshold
	createTrackbar("Min Threshold:", window_name, &lowThreshold, max_lowThreshold, on_trackbar);

	createTrackbar("H_MIN", window_name, &H_MIN, H_MAX, on_trackbar);
	createTrackbar("H_MAX", window_name, &H_MAX, H_MAX, on_trackbar);
	createTrackbar("S_MIN", window_name, &S_MIN, S_MAX, on_trackbar);
	createTrackbar("S_MAX", window_name, &S_MAX, S_MAX, on_trackbar);
	createTrackbar("V_MIN", window_name, &V_MIN, V_MAX, on_trackbar);
	createTrackbar("V_MAX", window_name, &V_MAX, V_MAX, on_trackbar);

	/// Show the image
	on_trackbar(0, 0);

	/// Wait until user exit program by pressing a key
	waitKey(0);

	//return 0;
}