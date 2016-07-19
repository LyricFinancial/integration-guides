Javascript library to allow you to integrate with Lyric services.

<button><a href="https://github.com/LyricFinancial/lyric-snippet" target="_blank" class="btn btn-secondary btn-hero">View On GitHub</a></button>

### How to Use - Synchronous

**2) Create an instance of LyricSnippet optionally overriding terms and conditions.**

      var lyric;
      lyric = new LyricSnippet("Custom Terms & Conditions");

  or

      var lyric;
      lyric = new LyricSnippet(document.getElementById('custom-terms').innerHTML);

  You can also pass a 2nd parameter for strategy.  We currently support 3 types of strategies: **syncAutoRedirect**, **syncManualRedirect**, and **async**.  syncAutoRedirect is used by default. Click [here](!Lyric_Snippet/Lyric_Snippet_Async) for more info on the async strategy.

**3) Call confirm() function to display Terms and Conditions that the user will need to agree to before saving their data.**

    <button class="md-raised md-primary" ng-click="lyric.confirm()">Get Advance</button>

  Or call from within another javascript function after any form validation has been completed.

**4) Add event listener to listen for confirmationComplete event.  This event gets fired after user agrees to the terms and conditions.  It is within this listener that you would make your server call to save the data to the Lyric API.**

    document.addEventListener('confirmationComplete', eventHandler);

**5) Once the Lyric API has been successfully called, call advanceRequestComplete function passing the ACCESS_TOKEN that was returned in the header of the Lyric /clients API call.**

    lyric.advanceRequestComplete(accessToken);

  If you're using the **syncAutoRedirect** strategy, then the wait inidicator will be removed and the Lyric vAtm page will automatically open in a new browser.  This strategy could be affected by pop up blockers since it opens a new web page in a new tab without direct input from the user.  You will need to be prepared to handle that if you use this strategy.

  If you're using the **syncManualRedirect** strategy, the wait indicator will be removed, then a new modal will appear letting the user know that their registration was successful and they will need to click a button to go over to the vAtm page.

  We are working on an **async** strategy that will send the user over to the vAtm prior to the registration call even completing.

**6) If an error occurs, call the advanceRequestError function.**

	lyric.advanceRequestError(error)