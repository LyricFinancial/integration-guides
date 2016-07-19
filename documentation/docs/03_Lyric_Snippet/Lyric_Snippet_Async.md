Javascript library to allow you to integrate with Lyric services.

<button><a href="https://github.com/LyricFinancial/lyric-snippet" target="_blank" class="btn btn-secondary btn-hero">View On GitHub</a></button>

### How to Use - Asynchronous

**1) On your server, generate a JWT token to be used as an asyncToken.**

In order for the Lyric server to know that you wish to make the registration call asynchronously, you need to generate a JWT token that will be passed when creating the LyricSnippet instance as well as passed as a header on the registration call. You can find more information on this [here](!Demo_Integration_Server/Async_Token_Api).

**2) For the async strategy, the instance of LyricSnippet needs to be created with 3 params.  Optional override of Terms and Conditions, 'async' as strategy, and the asyncToken.**

      var lyric;
      lyric = new LyricSnippet("Custom Terms & Conditions", 'async', asyncToken);

  or

      var lyric;
      lyric = new LyricSnippet(document.getElementById('custom-terms').innerHTML, 'async', asyncToken);


**3) Call confirm() function to display Terms and Conditions that the user will need to agree to before saving their data.**

    <button class="md-raised md-primary" ng-click="lyric.confirm()">Get Advance</button>

  Or call from within another javascript function after any form validation has been completed.

**4) Add event listener to listen for confirmationComplete event.  This event gets fired after user agrees to the terms and conditions and is then redirected in a new window to the Snap Platform.  It is within this listener that you would make your server call to save the data to the Lyric API.  Remember to add the asyncToken as a 'ASYNC_TOKEN' header to the registration call.**

    document.addEventListener('confirmationComplete', eventHandler);

**5) If an error occurs, then that means the registration was not successful.**

The user has already been redirected to the Snap platform, however.  They will see there that an error occurred and will be instructed to come back to the vendor site. You will want to diplay messaging indicating that there was an issue with their advance.