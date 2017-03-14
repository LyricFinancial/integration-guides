<a class="brand navbar-brand pull-left" href="<?= $params['base_page'] . $params['index']->getUri(); ?>">
	<img src="<?= $base_url; ?>new-logo.png" alt="home" width="auto" height="80"/>
</a>

<a class="brand navbar-brand pull-right" href="#" onclick="logout()">Logout</a>
<a class="brand navbar-brand pull-right" href="http://client-demo-stage.lyricfinancial.com/#/demo-server" target='_blank'>Demos</a>
<a class="brand navbar-brand pull-right" href="/secure/assignments-api/">Assignment API</a>
<a class="brand navbar-brand pull-right" href="/secure/vendor-api/">Vendor API</a>
<a class="brand navbar-brand pull-right" href="/secure/finance/#/advances">Finance</a>
<a class="brand navbar-brand pull-right" href="/secure/settings/#/settings">Settings</a>
<a class="brand navbar-brand pull-right" href="/secure/docs/Getting_Started.html">Documentation</a>

<script type="text/javascript">

  function logout() {
    var xhttp = new XMLHttpRequest();

    xhttp.open("GET", "/logout", false);
    xhttp.setRequestHeader("Content-type", "application/json");
    xhttp.send();
    window.location.replace("/login")                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     ;
  }

</script>