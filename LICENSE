
# YouTube to WAV Downloader and Converter to .HCA

This Python script allows you to download audio from YouTube videos in `.wav` format and convert multiple `.wav` files into `.hca` and looping that files using `VGAudiocli.exe`. 

**Go to [Releases](https://github.com/akhos09/wavtohactool/releases) to download the most recent version of the executable.**

<details>
<summary>Read more</summary>
   
## Table of Contents
- [Dependencies](#dependencies)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

## Dependencies

This script requires the following libraries and tools:

1. **yt-dlp**: A command-line program to download videos from YouTube and other sites.
2. **ffmpeg**: A multimedia framework for handling video, audio, and other multimedia files and streams, does all the proccess of downloading the `.wav` file of the URL from YouTube.
3. **SciPy**: For reading `.wav` files and the metadata of them.
4. **Tkinter**: For the file dialog to select `.wav` files.
5. **VGAudioCLI**: An executable which utility is to convert selected `.wav` files to `.hac`.
6. **(Optional) PyTube**: Library that is required for the URL extractor tool.
### Install Required Libraries

You can install the necessary Python libraries using `pip`. Run the following command:

```
pip install yt-dlp scipy
```

### Install FFmpeg
1. Download the .exe from [FFmpeg's official site](https://ffmpeg.org/download.html). or [FFmpeg's repository](https://github.com/BtbN/FFmpeg-Builds/releases) (Personally I prefer the repository). 
2. Extract the downloaded ZIP file to the directory where the script is located at.

## Installation

1. Clone this repository:

   ```
   git clone https://github.com/akhos09/wavtohac.git
   cd WavToHac
   ```

2. Ensure that all dependencies are installed as outlined above.

3. Place `ffmpeg.exe` in the same directory as this script or specify the correct path in the code.

## Usage

1. **Run the script**:

   Open a terminal or command prompt and navigate to the directory containing the script. Run the following command:

   ```
   python wavtohac.py
   ```

2. **Import the .txt file**

   Write down an `.txt` file (https://url,name,name.hca), to import the URL of the song from YouTube you want to download, the name of the `.wav` file, and the converted `.hca` file name.
   For example:

   ```
   https://www.youtube.com/watch?v=ixZDTiXiHsc,song1,hca1.hca
   https://www.youtube.com/watch?v=gqbQuypKCCU,song,hca2.hca
   ```

## Troubleshooting

- Ensure that `ffmpeg` is in the same directory as the script.
- Make sure `yt-dlp` is updated to the latest version for compatibility.
- If any errors occur while executing the commands, check the output for error messages for troubleshooting.
- If the script is not executed where the script is located at, it will not recognise the .exe of VGAudioCLI, so just make sure you are in the directory of the script and the VGAudioCLI.exe.

## License

See the [LICENSE](LICENSE) file for details.
