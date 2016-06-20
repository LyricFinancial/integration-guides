<a class="brand navbar-brand pull-left" href="<?= $params['base_page'] . $params['index']->getUri(); ?>"><?= $params['title']; ?></a>

<a class="brand navbar-brand pull-right" href="#" onclick="logout()">Logout</a>
<a class="brand navbar-brand pull-right" href="http://client-demo-stage.lyricfinancial.com/#/demo-server">Demos</a>
<a class="brand navbar-brand pull-right" href="/secure/assignments-api/">Assignment API</a>
<a class="brand navbar-brand pull-right" href="/secure/vendor-api/">Vendor API</a>
<a class="brand navbar-brand pull-right" href="/secure/assignments/#/advances">Assignments</a>
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