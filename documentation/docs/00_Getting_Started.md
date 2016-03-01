

## Getting Started

Follow these steps to integrate your system with the Lyric APIs.

### 1) Add the "Get Advance" button to your website.
Follow the directions in the [Lyric Snippet](!Lyric_Snippet/Lyric_Snippet) to update your website to include a "Get Advance" button.  This snippet will display a Terms & Conditions modal as well as the wait indicator while you make the call to your server to make the Lyric Registration API call.  Use our [Angular Demos](!Angular_Demo) as a reference.

### 2) Record agreement to Terms & Conditions
If necessary, before you make the registration call to the server, make an API call that will record the acknowledgement of the Terms & Conditions.

### 3) Add an API to your server to make the Lyric Registration API call
Lyric will provide you with a vendorId and a username and password to be used to authenticate with the vendor APIs.  These pieces of information should be kept securely on your server, so you will need to create a new API call that will then turn around and call the Lyric Registration API.  Use our [Demo Integration Server](!Demo_Integration_Server) to guide you in this process.  It demonstrates passing json as well as multipart form-data.  

	  The vendorClientAccountId is the unique key for the user in your system.  We will use this key to determine uniqueness.

### 4) Save the memberToken that gets returned
A successful response from the Lyric Registration API will return an ACCESS_TOKEN in the header as well as a memberToken in the body.  The ACCESS_TOKEN needs to be returned in the response of your new API call.  The memberToken should be saved with your user record and used for any subsequent calls to the Lyric vendor APIs.

### 5) Add Lyric Widget to your client portal
Once an advance has been made, you can add the Lyric Widget to your website so that clients can see their Advance Limit, Current Balance and Available Balance.  Follow the directions in the [Lyric Snippet](!Lyric_Snippet/Lyric_Widget) to see how to add it to your page.  Use our [Lyric Widget Demo](!Angular_Demo/Lyric_Widget_Demo) as a reference.


## Demo Pages

You can find the demo [here](http://vatm-demo.lyricfinancial.com/#/demo-server) and the lyric widget demo [here](http://vatm-demo.lyricfinancial.com/#/lyric-widget).