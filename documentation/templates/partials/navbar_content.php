<a class="brand navbar-brand pull-left" href="<?= $params['base_page'] . $params['index']->getUri(); ?>">
	<img src="<?= $base_url; ?>new-logo.png" alt="home" width="auto" height="80"/>
</a>

<a class="brand navbar-brand pull-right" href="#" onclick="logout()">Logout</a>
<a class="brand navbar-brand pull-right" href="/secure/assignments-api/">Assignment API</a>
<a class="brand navbar-brand pull-right" href="http://18.207.204.223:8080">Partner API</a>
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