# gcal-images

Thanks to [Carlos Martins](http://www.internetbestsecrets.com/2019/09/google-calendar-event-images.html) at Internet's Best Secrets, a number of keywords were found that will link images to Google Calendar.    
I wanted to make use of these calendar header icons in [KLWP](https://play.google.com/store/apps/details?id=org.kustom.wallpaper) so created this repository to track any images I find. 

<img src="https://github.com/pekempy/gcal-images/assets/22874875/596ed545-6d1c-4f54-b11d-7139d68e760e" width="250"/> <img src="https://github.com/pekempy/gcal-images/assets/22874875/736d8d5d-187b-4c20-8afd-26814ae3a749" width="250"/>
<img src="https://github.com/pekempy/gcal-images/assets/22874875/59871ef9-0e9c-4eaf-acf9-40455e0c0adb" width="250"/> <img src="https://github.com/pekempy/gcal-images/assets/22874875/f67ad6d6-b555-4c18-a18f-c16f292bae5b" width="250"/> 
<img src="https://github.com/pekempy/gcal-images/assets/22874875/1d69efc0-6b7e-4157-88c3-b64e9c86128a" width="250"/> <img src="https://github.com/pekempy/gcal-images/assets/22874875/f7c9a806-91b7-4cb7-b30e-d21779ed5a73" width="250"/> 


## How to use them
If you're wanting to access the URL directly, the name of the image from `images` folder should be appended to the end of this URL:     
`https://ssl.gstatic.com/tmly/f8944938hffheth4ew890ht4i8/flairs/xxhdpi/img_{here}.jpg`

For example, if I'm wanting to access the image for `theateropera.jpg` I would use the below URL:     
`https://ssl.gstatic.com/tmly/f8944938hffheth4ew890ht4i8/flairs/xxhdpi/img_theateropera.jpg`

I checked ~130,000 words against the URL and downloaded any which worked so the `images` folder is a bit of a dictionary for what exists.     
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
