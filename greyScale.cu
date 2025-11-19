
#include <cuda_runtime.h>
#include <npp.h>

#include <ImageIO.h>
#include <ImagesCPU.h>
#include <ImagesNPP.h>

#include <iostream>
#include <string>

//To keet things simple, everithing runs on the main function
int main()
{
    //We encapsulate everything in a try function to avoid errors (or at least to catch them)
    try
    {

        //We define the input and output name files
        std::string sFilename = "Emerald_Lakes_New_Zealand.jpg";
        std::string sResultFilename = "greyscale_output.jpg";

        //We load the input image knowing it is a RGB JPG
        npp::ImageCPU_8u_C4 oHostSrcColor;
        npp::loadImage(sFilename, oHostSrcColor); 
        npp::ImageNPP_8u_C4 oDeviceSrcColor(oHostSrcColor);

        //We declare the gray output
        npp::ImageNPP_8u_C1 oDeviceDstGray(oDeviceSrcColor.size());

        //This is the main body of the script, the function itself
        NPP_CHECK_NPP(nppiBGRAToGray_8u_C4C1R(
                            oDeviceSrcColor.data(), oDeviceSrcColor.pitch(),
                            oDeviceDstGray.data(), oDeviceDstGray.pitch(),
                            oDeviceDstGray.size()));


        //The host output file is set
        npp::ImageCPU_8u_C1 oHostFinal(oDeviceDstGray.size());
        oDeviceDstGray.copyTo(oHostFinal.data(), oHostFinal.pitch());

        //We save the image
        saveImage(sResultFilename, oHostFinal);
        std::cout << "Saved image: " << sResultFilename << std::endl;

        //We free memory
        nppiFree(oDeviceSrcColor.data());
        nppiFree(oDeviceDstGray.data());

        exit(EXIT_SUCCESS);
    }
    //Some catch errors, it is not compulsory but it is a good practice I saw in the labs
    catch (npp::Exception &rException)
    {
        std::cerr << "Program error! The following exception occurred: \n";
        std::cerr << rException << std::endl;
        std::cerr << "Aborting." << std::endl;

        exit(EXIT_FAILURE);
    }
    catch (...)
    {
        std::cerr << "Program error! An unknown type of exception occurred. \n";
        std::cerr << "Aborting." << std::endl;

        exit(EXIT_FAILURE);
        return -1;
    }

    return 0;
}