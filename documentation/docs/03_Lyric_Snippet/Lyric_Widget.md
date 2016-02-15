## Widget

Once one of your clients is registered in the Lyric system, you can integrate the Lyric Widget into your website so when the client is logged in, they can see their Advance Limit, Current Balance and Available Balance.

### How to Use

1) Create a Web Service Call that generates a JWT token

The Lyric Widget makes a web service call to Lyric's APIs to get the Advance information.  In order to authenticate this call, you will need to provide a JWT token to the widget.  You can find more information on this [here](https://github.com/LyricFinancial/demo-integration-server#token-api).

2) Call your new web service and get the newly generated token.  You can store this token in local storage if you'd like so you're not creating a new token every time the page is refreshed.

3) Create an instance of Lyric Widget.  The constructor takes the memberToken and an optional advanceUrl.  By default, the advance api in the Lyric services will be used, but it can be overridden to use a different url.  Then call loadData() on it passing the newly generated token.  loadData() returns a promise so in the .then you can then get the html of the widget to add to your web page.

	lyricWidget = new LyricWidget(:memberToken)
	lyricWidget.loadData(token)
	.then ->
		html = lyricWidget.getWidget()
		document.getElementById('lyric-container').innerHtml = html

4) Customize the lyric widget how you'd like

	.widget-label {
		font-weight: bold;
	}

	.widget-value {
		
	}

	.widget-container {
		border-radius: 25px;
	  background: #d01e1e;
	  color: #fff;
	  padding: 20px; 
	  width: 235px;

	  h3 {
	  	margin-top: 2px;
	  }
	}

 
