#include "Segment.h"
//#include "haralick.h"
//#include "Cam.h"
#include <string>
#include <iostream>
//#include  "TesteRange.h"
//#include  "Teste2.h"

int main(int argc, char** argv)
{
	//teste();
	String path_img = "C:\\Users\\fadell\\Documents\\Mestrado\\dataBases\\couro_images\\c1_17.jpg";

	/*
	The original images were cut for segmentation to be more efficient.
	It was cut 100px from the bottom of each original image,
	because in the capture of the images, 
	some of them appear parts of the table where the photos were taken
	*/
	String folderpath = "C:\\Users\\fadell\\Documents\\Mestrado\\dataBases\\couro_images_cropped\\";
	vector<String> filenames;
	glob(folderpath, filenames);
	//random_shuffle(filenames.begin(), filenames.end());

	char nameFile[10];
	char dirFileROI[300];
	char dirFileMASK[300];

	vector<Mat> images;
	Mat roi, mask;

	////ROI
	//Mat roi = ROI(path_img);
	//cvtColor(roi, roi, CV_RGB2GRAY);
	/*namedWindow("ROI", CV_WINDOW_FREERATIO);
	imshow("ROI", roi);*/

	//extract features GLCM
	/*Mat glH = glcmH(roi);
	cout << "glH = " << endl << " " << glH << endl << endl;
	extractFeatures(glH, Mat::zeros(1, 1, CV_32F), Mat::zeros(1, 1, CV_32F), Mat::zeros(1, 1, CV_32F), 1, 6, "C:\\Users\\fadell\\Documents\\Mestrado\\results\\glcm.txt");*/

	for (int i = 0; i<filenames.size(); i++)
	{
		//int Class = (int)filenames[i][67]-48;
		/*
			Extract only the file name
			Change the number 66 according to the path of your images directory,
			in my case position 66 indicates the beginning of the part of the string that shows the name of the image or file.
		*/
		sprintf(nameFile,"%s",filenames[i].substr(66, 9));
		sprintf(dirFileROI, "C:\\Users\\fadell\\Documents\\Mestrado\\dataBases\\ROI\\%s", nameFile);
		sprintf(dirFileMASK, "C:\\Users\\fadell\\Documents\\Mestrado\\dataBases\\MASK\\%s", nameFile);

		//Get images of method
		images = ROI(filenames[i]);
		roi  = images[0];//segmented image
		mask = images[1];//mask used in the segmented image

		imwrite(dirFileROI, roi);
		imwrite(dirFileMASK, mask);

		images.clear();

		//extract features GLCM
		//Mat glH = glcmH(roi);
		//cout << "glH = " << endl << " " << glH << endl << endl;
		//extractFeatures(glH, Mat::zeros(1, 1, CV_32F), Mat::zeros(1, 1, CV_32F), Mat::zeros(1, 1, CV_32F), 1, Class, "C:\\Users\\fadell\\Documents\\Mestrado\\results\\glcm.txt");

	}



	/*/// Wait until user finishes program
	while (true)
	{
		int c;
		c = waitKey(20);
		if ((char)c == 27)
		{
			break;
		}
	}*/

	return 1;

}