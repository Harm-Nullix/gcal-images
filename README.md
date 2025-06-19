# Google Calendar Header Images

Thanks to [Carlos Martins](http://www.internetbestsecrets.com/2019/09/google-calendar-event-images.html) at Internet's Best Secrets, a number of keywords were found that will link images to Google Calendar.    
Also a huge thanks to Tored from the Kustom Discord server for all their help with getting this working.    
I wanted to make use of these calendar header icons in [KLWP](https://play.google.com/store/apps/details?id=org.kustom.wallpaper) so created this repository to track any images I find. 
If anyone wishes to contribute feel free to open a PR if you find more images!

<img src="https://github.com/pekempy/gcal-images/assets/22874875/596ed545-6d1c-4f54-b11d-7139d68e760e" width="250"/> <img src="https://github.com/pekempy/gcal-images/assets/22874875/736d8d5d-187b-4c20-8afd-26814ae3a749" width="250"/>
<img src="https://github.com/pekempy/gcal-images/assets/22874875/59871ef9-0e9c-4eaf-acf9-40455e0c0adb" width="250"/> <img src="https://github.com/pekempy/gcal-images/assets/22874875/f67ad6d6-b555-4c18-a18f-c16f292bae5b" width="250"/> 
<img src="https://github.com/pekempy/gcal-images/assets/22874875/1d69efc0-6b7e-4157-88c3-b64e9c86128a" width="250"/> <img src="https://github.com/pekempy/gcal-images/assets/22874875/f7c9a806-91b7-4cb7-b30e-d21779ed5a73" width="250"/> 


## How to use them
If you're wanting to access the URL directly, the name of the image from [images](https://github.com/pekempy/gcal-images/tree/main/images) folder should be appended to the end of this URL:     
`https://ssl.gstatic.com/tmly/f8944938hffheth4ew890ht4i8/flairs/xxhdpi/img_{here}.jpg`

For example, if I'm wanting to access the image for `theateropera.jpg` I would use the below URL:     
`https://ssl.gstatic.com/tmly/f8944938hffheth4ew890ht4i8/flairs/xxhdpi/img_theateropera.jpg`

I checked ~130,000 words against the URL and downloaded any which worked so the [images](https://github.com/pekempy/gcal-images/tree/main/images) folder is a bit of a dictionary for what exists.     
There may be more that weren't listed on the Internet's Best Secrets site either in the OP or in the comments, that are conjugations of words (e.g. `americanfootball`), but I've found and added as many as I've been able to.

## Setting up KLWP / KWGT
To use this in KLWP for calendar widgets, all that's required is a single global variable.
1. Create a Global text variable called `caltags` (or similar)
2. Copy all the content from [keywords.txt](https://raw.githubusercontent.com/pekempy/gcal-images/main/keywords.txt) into the text variable exactly as it shows on that link
3. On your shape, set the bitmap source to be the following formula:
```
https://ssl.gstatic.com/tmly/f8944938hffheth4ew890ht4i8/flairs/xxhdpi/img_$tc(reg, fl(0,0,0, tc(reg, tc(reg, gv(caltags), "\s*,\s*", "|"), "(.*):(.*)", "if(tc(low,ci(title, 0)) ~= ($2), $1 + @) +") + @), "@.*", "")$.jpg
```
What this will do is parse out the gv caltags to find each tag, and as soon as it finds the **first** match, it will return the key for that, and fetch the image from the URl.

If you also want to use the Location images from Google Maps, feel free to check out the [Wiki](https://github.com/pekempy/gcal-images/wiki) which has a guide on setting this up.

## Fetching Images with fetch.sh

This repository includes a `fetch.sh` script to streamline the process of fetching images from Google Calendar using specified year and version parameters.

### Prerequisites

1. Clone this repository locally:
   ```bash
   git clone https://github.com/pekempy/gcal-images.git
   cd gcal-images
   ```

2. Ensure `fetch.sh` has execution permissions:
   ```bash
   chmod +x fetch.sh
   ```


3. Install any required software/tool for converting SVG to JPG:  
   The `fetch.sh` script requires a command-line tool to convert the downloaded `.svg` files to `.jpg`. Ensure that any one of the following tools is installed and accessible in
   your terminal:

   #### Option 1: **ImageMagick**
   - Install ImageMagick, which provides the `convert` command that can be used to handle SVG to JPG conversion.  
     Installation commands:
     ```bash
     # On Ubuntu/Debian:
     sudo apt install imagemagick

     # On macOS (using Homebrew):
     brew install imagemagick
     ```
     Example command (used internally by the script):
     ```bash
     magick input.svg output.jpg
     ```

   #### Option 2: **CairoSVG**
   - Alternatively, you may use CairoSVG, which can be installed via pip and allows for SVG to JPG conversion.  
     Installation command:
     ```bash
     pip install cairosvg
     ```
   Example command (used internally by the script):
     ```bash
     cairosvg input.svg -o output.jpg
     ```

   #### Option 3: **Inkscape**
   - Inkscape is a powerful tool for handling SVG files and can also be used for conversion.  
     Installation commands:
     ```bash
     # On Ubuntu/Debian:
     sudo apt install inkscape

     # On macOS (using Homebrew):
     brew install --cask inkscape
     ```
   Example command (used internally by the script):
     ```bash
     inkscape input.svg --export-type=png --export-filename=output.png
     convert output.png output.jpg
     ```

   #### Option 4: **rsvg-convert (from librsvg)**
   - This is another lightweight tool for converting SVG files to raster images like JPG.  
     Installation commands:
     ```bash
     # On Ubuntu/Debian:
     sudo apt install librsvg2-bin

     # On macOS (using Homebrew):
     brew install librsvg
     ```
   Example command (used internally by the script):
     ```bash
     rsvg-convert input.svg -o output.jpg
     ```

   **Note:** Depending on the tool installed, make sure the system path is set correctly so the script can detect the required command (`convert`, `cairosvg`, `inkscape`, or
   `rsvg-convert`).
### Usage

The script requires two inputs: `year` and `version`, and will automatically download images into a folder structure organized as `images/{year}_{version}`. A `failed.txt` file
will track any failed image fetches, and successfully fetched image keywords will be appended to the root `keywords.txt` file.

Run the script as follows:

```bash
./fetch.sh -y <year> -v <version>
```

For example:

```bash
./fetch.sh -y 2024 -v v2
```

---

### What the script does

1. Reads from the root `keywords.txt` file containing the base keywords to look up image URLs.
2. Constructs URLs for the images using the `year` and `version` provided as input:
   ```
   https://ssl.gstatic.com/calendar/images/eventillustrations/${year}_${version}/img_${keyword}.svg
   ```
3. Downloads images into the corresponding folder `images/{year}_{version}`.
4. Logs:
   - **Failures** (URLs that don't work) to `failed.txt`.
   - **Successes** to the root `keywords.txt` file to track existing available images.

After this you can update the keywords to holds aliases using the `updateKeywords.sh` script

## Updating the keywords.txt files

The `updateKeywords.sh` script is a utility designed to help manage and update the `keywords.txt` files with aliases or alternative names for the images found based on the root keywords.txt. It ensures that the
`keywords.txt` file remains up to date and correctly formatted with additional keywords for better usability when setting up global variables in applications like KLWP.

### What it Does

1. Reads the root `keywords.txt` file to fetch the existing keywords and aliases.
2. Fetch all subdirectory `keywords.txt` files to update them with the root.
3. Ensures that all entries remain standardized and avoids duplications in the file.
4. Outputs the updated content back to the the corresponding `keywords.txt` file for further use.

### How to Use

1. Clone the repository locally (if it hasn't been done already):
   ```bash
   git clone https://github.com/pekempy/gcal-images.git
   cd gcal-images
   ```

2. Ensure `updateKeywords.sh` has execution permissions:
   ```bash
   chmod +x updateKeywords.sh
   ```

3. Run the script:
   ```bash
   ./updateKeywords.sh
   ```

4. After the script finishes execution, the `keywords.txt` files will be updated with the changes.

**Note:** Always verify the updated `keywords.txt` file to ensure all necessary changes have been correctly applied.`
