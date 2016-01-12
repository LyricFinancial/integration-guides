var mytemplate = {};

mytemplate["templates/error.tpl.html"] = "<div id=\"errorModal\" class=\"modal\">\n" +
   "\n" +
   "  <!-- Modal content -->\n" +
   "  <div class=\"modal-content\">\n" +
   "    <div class=\"modal-header\">\n" +
   "	    <h3>An Error Occurred</h3>\n" +
   "	  </div>\n" +
   "	  <div class=\"modal-body\">\n" +
   "\n" +
   "			<h3>An error occurred while processing your request.  Please try again later.</h3>\n" +
   "\n" +
   "	  </div>\n" +
   "	  <div class=\"modal-footer\">\n" +
   "	    <button type=\"button\" class=\"btn btn-white\" onclick=\"closeModal()\">Ok</button>\n" +
   "	  </div>\n" +
   "  </div>\n" +
   "\n" +
   "</div>";

mytemplate["templates/terms_and_conditions_modal.tpl.html"] = "<div id=\"tcModal\" class=\"modal\">\n" +
   "\n" +
   "  <!-- Modal content -->\n" +
   "  <div class=\"modal-content\">\n" +
   "    <div class=\"modal-header\">\n" +
   "    	<span class=\"close\">×</span>\n" +
   "	    <h3>Terms & Conditions</h3>\n" +
   "	  </div>\n" +
   "	  <div class=\"modal-body\">\n" +
   "\n" +
   "			<div class=\"terms\">\n" +
   "			  <p>Lorem ipsum dolor sit amet, <strong>consectetur</strong> adipiscing elit. Vivamus malesuada ex vel sagittis gravida. Mauris sed ligula at velit cursus volutpat. Nam sodales purus in ex iaculis, a molestie velit placerat. Vivamus tincidunt quis arcu et pharetra. Sed gravida a mauris quis porta. Quisque tempus, metus eu scelerisque tristique, tortor lorem pretium arcu, ultricies elementum nibh massa eu neque. Sed hendrerit et nibh eget varius. Pellentesque ultrices elit eget mi gravida aliquam. Maecenas nec metus eu <strong>odio viverra elementum</strong> vehicula quis metus.</p>\n" +
   "\n" +
   "				<p>Donec luctus ligula ac turpis consectetur, <strong>sit amet</strong> imperdiet massa lacinia. Fusce sit amet tempor tellus, a rhoncus nibh. Nulla ac erat ornare, condimentum mi vel, euismod diam.</p>\n" +
   "\n" +
   "				<ol>\n" +
   "			  	<li>Cras vitae nisi vitae nisl luctus volutpat ac et enim. Praesent nisl lorem, efficitur sed vestibulum in, facilisis ut arcu. Curabitur dictum fermentum sapien, a pellentesque orci maximus pretium. Quisque malesuada commodo molestie. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Suspendisse potenti.</li>\n" +
   "\n" +
   "			  	<li>Ut viverra quis erat et efficitur. Morbi eget odio semper, vulputate erat at, commodo dolor. Morbi eleifend ipsum in magna consectetur varius. Quisque malesuada gravida arcu, nec maximus risus aliquam et. Cras hendrerit ut metus a ultrices. Nulla ac ipsum eget lacus lobortis accumsan. Pellentesque pellentesque pharetra dui id sagittis.</li>\n" +
   "\n" +
   "			    <li>Cras vitae nisi vitae nisl luctus volutpat ac et enim. Praesent nisl lorem, efficitur sed vestibulum in, facilisis ut arcu. Curabitur dictum fermentum sapien, a pellentesque orci maximus pretium. Quisque malesuada commodo molestie. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Suspendisse potenti.</li>\n" +
   "\n" +
   "			  	<li>Ut viverra quis erat et efficitur. Morbi eget odio semper, vulputate erat at, commodo dolor. Morbi eleifend ipsum in magna consectetur varius. Quisque malesuada gravida arcu, nec maximus risus aliquam et. Cras hendrerit ut metus a ultrices. Nulla ac ipsum eget lacus lobortis accumsan. Pellentesque pellentesque pharetra dui id sagittis.</li>\n" +
   "\n" +
   "				</ol>\n" +
   "\n" +
   "				<p>Pellentesque ut est sed erat bibendum venenatis. Ut ut nisl diam. Nam viverra risus vitae lectus suscipit rutrum. Aliquam ut ante eu tellus posuere volutpat. Etiam gravida nunc in est eleifend bibendum. Proin tincidunt porttitor lacus. Duis viverra, nisi ut ornare tempor, lorem nibh hendrerit nisl, in molestie sapien massa vel eros. Nullam consequat nulla quis ex dictum rhoncus. Sed id sem elementum, consectetur sem sed, consectetur felis.</p>\n" +
   "\n" +
   "				<p>Vivamus id imperdiet quam. Etiam pellentesque vulputate sapien, vitae vestibulum ante ornare suscipit. In vitae sapien est. Nulla quis eros eget ipsum ultrices faucibus. Curabitur velit nisl, suscipit sed nibh sit amet, scelerisque pharetra dui. Ut rhoncus, massa et condimentum tempus, augue lacus blandit lorem, et bibendum turpis purus non mauris. Ut pulvinar dictum ligula in tristique.</p>\n" +
   "			</div>\n" +
   "\n" +
   "	  </div>\n" +
   "	  <div class=\"modal-footer\">\n" +
   "	    <button type=\"button\" class=\"btn btn-white\" onclick=\"confirmed()\">I Agree</button>\n" +
   "	  </div>\n" +
   "  </div>\n" +
   "\n" +
   "</div>";

mytemplate["templates/wait_indicator.tpl.html"] = "<div id=\"waitModal\" class=\"modal\">\n" +
   "\n" +
   "  <!-- Modal content -->\n" +
   "  <div class=\"modal-content\">\n" +
   "	  <div class=\"modal-body\">\n" +
   "\n" +
   "			<div class=\"wait-indicator\">\n" +
   "				<h3>Please wait while we process your request.</h3>\n" +
   "				<div class=\"spinner\">\n" +
   "				  <div class=\"rect1\"></div>\n" +
   "				  <div class=\"rect2\"></div>\n" +
   "				  <div class=\"rect3\"></div>\n" +
   "				  <div class=\"rect4\"></div>\n" +
   "				  <div class=\"rect5\"></div>\n" +
   "				</div>\n" +
   "			</div>\n" +
   "\n" +
   "	  </div>\n" +
   "  </div>\n" +
   "\n" +
   "</div>";
