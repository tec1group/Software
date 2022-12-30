#include "serialib.h"
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <fstream>
#include <vector>

/* 
	Bin2TEC
	-------
 Send a Binary file or Intel HEX file to the TEC (Talking Electronic Computer)
 by Brian Chiha    DEC-2022

 For instructions type
	$bin2tec -h

*/


// Input parser ripped from
// https://stackoverflow.com/questions/865668/parsing-command-line-arguments-in-c
class InputParser
{
public:
    InputParser(int &argc, char **argv)
    {
        for (int i = 1; i < argc; ++i)
            this->tokens.push_back(std::string(argv[i]));
    }
    /// @author iain
    const std::string &getCmdOption(const std::string &option) const
    {
        std::vector<std::string>::const_iterator itr;
        itr = std::find(this->tokens.begin(), this->tokens.end(), option);
        if (itr != this->tokens.end() && ++itr != this->tokens.end())
        {
            return *itr;
        }
        static const std::string empty_string("");
        return empty_string;
    }
    /// @author iain
    bool cmdOptionExists(const std::string &option) const
    {
        return std::find(this->tokens.begin(), this->tokens.end(), option) != this->tokens.end();
    }

private:
    std::vector<std::string> tokens;
};

class binFile
{
public:
    binFile(std::string filename)
    {
        std::ifstream datafile(filename, std::ios::in | std::ios::binary);
        if (!datafile.is_open())
        {
            std::cout << "failed to open " << filename << '\n';
            exit(0);
        }
        uint8_t n = 0;
        while (datafile.good())
        {
            datafile.read(reinterpret_cast<char *>(&n), sizeof n);
            data.push_back(n);
        }
        datafile.close();
    };

    int openSerial(std::string port, u_int16_t baud)
    {
        // Connection to serial port
        char status = serial.openDevice(port.c_str(), baud);

        // If connection fails, return the error code otherwise, display a success message
        if (status != 1)
        {
            std::cout << "Failed to connect to " << port << ", error: " << int(status) << "\n";
            return status;
        }
        return status;
    }

    void closeSerial()
    {
        serial.closeDevice();
    }

    void sendIt()
    {
        uint32_t pos = 0; //data position
        float progress = 0.0; //progress indicator
        while (pos < data.size())
        {
            serial.writeChar(data[pos]);
            progress = pos / (float)data.size();

            int barWidth = 70;

            std::cout << "[";
            int p = barWidth * progress;
            for (int i = 0; i < barWidth; ++i)
            {
                if (i < p)
                    std::cout << "=";
                else if (i == p)
                    std::cout << ">";
                else
                    std::cout << " ";
            }
            std::cout << "] " << std::dec << int(progress * 100.0) << " % ("
                      << std::hex << std::uppercase << int(pos) << ") Bytes\r";
            std::cout.flush();
            usleep(8000); // 13 microseconds = 1 sample (on my computer, change if necessary)
            pos += 1;
        }
    }
    
private:
    std::vector<uint8_t> data;
    serialib serial;
};

int main(int argc, char *argv[])
{
    //defaults
    std::string filename = "";
    std::string port = "/dev/tty.usbserial-A50285BI";
    u_int16_t baud = 4800;
    
    //get command line
    InputParser input(argc, argv);
    if (input.cmdOptionExists("-h") || input.cmdOptionExists("-help"))
    {
        std::cout << "Bin2TEC - Send a binary file to the TEC-1F\n\n"
                  << "Usage : Bin2TEC [arguments]\n\nArguments:\n"
                  << "   -f       Filename (mandatory)\n"
                  << "   -p       Serial Port (default: /dev/tty.usbserial-A50285BI)\n"
                  << "   -b       Baud Rate (default: 4800)\n\n";
        return 0;
    }
    if (input.cmdOptionExists("-f"))
    {
        filename = input.getCmdOption("-f");
    }
    else
    {
        std::cout << "Must have a filename argument '-f <filename>'\n";
        return -1;
    }
    if (input.cmdOptionExists("-p"))
    {
        port = input.getCmdOption("-p");
    }
    if (input.cmdOptionExists("-b"))
    {
        baud = std::stoi(input.getCmdOption("-b"));
    }

    //Load BINARY data
    binFile binFile(filename);
    if (binFile.openSerial(port, baud) != 1)
    {
        return -1;
    }

    //Send data
    binFile.sendIt();
    //Close Serial Port
    binFile.closeSerial();
    return 0;
}
