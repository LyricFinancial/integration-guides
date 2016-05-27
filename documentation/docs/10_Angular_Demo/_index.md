<button><a href="https://github.com/LyricFinancial/integration-guides/tree/master/examples/client/angular/lyric-vendor-demo" target="_blank" class="btn btn-secondary btn-hero">View On GitHub</a></button>

This site is an angular example of creating a client to interface with the Lyric Vendor APIs.  It uses the [Lyric Snippet](!Lyric_Snippet/Lyric_Snippet) to interface with the registration api and has 2 routes to show 2 different use cases.

## Strategy
You can test the 2 different registration strategies by adding ?strategy= to the url.  By default, the **syncAutoRedirect** strategy is used.  If you add ?strategy=syncManualRedirect to the url, then the **synceManualRedirect** strategy will be used.  Go [here](!Lyric_Snippet/Lyric_Snippet) to learn about the different strategies.