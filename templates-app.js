angular.module('templates-app', ['demo-server/demo-server.tpl.html', 'demo/demo.tpl.html']);

angular.module("demo-server/demo-server.tpl.html", []).run(["$templateCache", function($templateCache) {
  $templateCache.put("demo-server/demo-server.tpl.html",
    "<div id=\"content\">\n" +
    "	<md-content layout-padding>\n" +
    "		<p class=\"info\">This demo mimics calling the vendor's server passing the vendorClientAccountId.  The client information is looked up on the server then passed to the Lyric registration API.  Click <a ui-sref=\"demo\">&lt;here&gt;</a> to go to the client demo.</p>\n" +
    "		<h2>My Membership</h2>\n" +
    "		<div class=\"your-info\">\n" +
    "		  <span>Current Address: <a class=\"edit\" ui-sref=\"demo.edit\">Edit</a></span>\n" +
    "		  <p>{{clientData.firstName}} {{clientData.lastName}}<br>\n" +
    "		    {{clientData.address1}}<br>\n" +
    "		    {{clientData.city}}, {{clientData.state}} {{clientData.zip}}</p>\n" +
    "		  <p> {{clientData.vendorClientAccountId}}\n" +
    "		</div>\n" +
    "		<br/>\n" +
    "		<div layout-gt-md=\"row\" layout=\"column\">\n" +
    "		  <md-input-container flex>\n" +
    "		    <label>Server Url</label>\n" +
    "		    <input ng-model=\"server.url\" name=\"serverUrl\" required>\n" +
    "		    <div class=\"error-messages\" ng-if=\"interacted(registrationForm.serverUrl)\" ng-messages=\"registrationForm.serverUrl.$error\">\n" +
    "					<div ng-messages-include=\"custom-messages\"></div>\n" +
    "				</div>\n" +
    "		  </md-input-container>\n" +
    "		</div>\n" +
    "		<section layout=\"row\" layout-align=\"end center\" layout-padding>\n" +
    "			<md-radio-group ng-model=\"postType.type\">\n" +
    "		    <md-radio-button value=\"json\" class=\"md-primary\">JSON</md-radio-button>\n" +
    "		    <md-radio-button value=\"form\" class=\"md-primary\">Form</md-radio-button>\n" +
    "		    <md-radio-button value=\"base64Encoded\" class=\"md-primary\">Base64 Encoded</md-radio-button>\n" +
    "		  </md-radio-group>\n" +
    "			<md-button class=\"md-raised md-primary\" onclick=\"confirm()\">Get Advance</md-button>\n" +
    "		</section>\n" +
    "	</md-content>\n" +
    "</div>");
}]);

angular.module("demo/demo.tpl.html", []).run(["$templateCache", function($templateCache) {
  $templateCache.put("demo/demo.tpl.html",
    "<script type=\"text/ng-template\" id=\"custom-messages\">\n" +
    "  <div ng-message=\"required\">This field is required</div>\n" +
    "  <div ng-message=\"email\">Invalid email address</div>\n" +
    "</script>\n" +
    "\n" +
    "<div id=\"content\">\n" +
    "	<md-content layout-padding>\n" +
    "		<p class=\"info\">This demo mimics calling Lyric registration API directly (Not Recommended). Click <a ui-sref=\"demo-server\">&lt;here&gt;</a> to go to the server demo.</p>\n" +
    "\n" +
    "		<form name=\"registrationForm\" ng-submit=\"submit(registrationForm, dob, royaltyEarningsFile)\" novalidate>\n" +
    "\n" +
    "			<div layout-gt-md=\"row\" layout=\"column\" layout-padding>\n" +
    "\n" +
    "				<div flex>\n" +
    "	   			<md-toolbar>\n" +
    "	    			<div class=\"md-toolbar-tools\">\n" +
    "	      			<h3 class=\"md-flex\">Personal Information</h3>\n" +
    "	    			</div>\n" +
    "	  			</md-toolbar>\n" +
    "	  			<br/>\n" +
    "\n" +
    "	  			<div layout-gt-md=\"row\" layout=\"column\">\n" +
    "				    <md-input-container flex>\n" +
    "				      <label>Vendor Client Account Id</label>\n" +
    "				      <input ng-model=\"clientData.vendorClientAccountId\" name=\"vendorClientAccountId\" required>\n" +
    "				      <div class=\"error-messages\" ng-if=\"interacted(registrationForm.vendorClientAccountId)\" ng-messages=\"registrationForm.vendorClientAccountId.$error\">\n" +
    "				  			<div ng-messages-include=\"custom-messages\"></div>\n" +
    "	      			</div>\n" +
    "				    </md-input-container>\n" +
    "				  </div>\n" +
    "\n" +
    "					<div layout-gt-md=\"row\" layout=\"column\">\n" +
    "				    <md-input-container flex>\n" +
    "				      <label>First Name</label>\n" +
    "				      <input ng-model=\"clientData.firstName\" name=\"firstName\" required>\n" +
    "				      <div class=\"error-messages\" ng-if=\"interacted(registrationForm.firstName)\" ng-messages=\"registrationForm.firstName.$error\">\n" +
    "				  			<div ng-messages-include=\"custom-messages\"></div>\n" +
    "	      			</div>\n" +
    "				    </md-input-container>\n" +
    "				    <md-input-container flex>\n" +
    "				      <label>Last Name</label>\n" +
    "				      <input ng-model=\"clientData.lastName\" name=\"lastName\" required>\n" +
    "				      <div class=\"error-messages\" ng-if=\"interacted(registrationForm.lastName)\" ng-messages=\"registrationForm.lastName.$error\">\n" +
    "				  			<div ng-messages-include=\"custom-messages\"></div>\n" +
    "	      			</div>\n" +
    "				    </md-input-container>\n" +
    "				  </div>\n" +
    "				  <div layout-gt-md=\"row\" layout=\"column\">\n" +
    "				    <md-input-container flex>\n" +
    "				      <label>Email</label>\n" +
    "				      <input type=\"email\" ng-model=\"clientData.email\" name=\"email\" required>\n" +
    "				      <div class=\"error-messages\" ng-if=\"interacted(registrationForm.email)\" ng-messages=\"registrationForm.email.$error\">\n" +
    "				  			<div ng-messages-include=\"custom-messages\"></div>\n" +
    "	      			</div>\n" +
    "				    </md-input-container>\n" +
    "				  </div>\n" +
    "				  <div layout-gt-md=\"row\" layout=\"column\">\n" +
    "				    <md-input-container flex>\n" +
    "				      <label>Social Security Number</label>\n" +
    "				      <input ng-model=\"clientData.ssn\" name=\"ssn\" \n" +
    "				      	required\n" +
    "				      	ng-pattern=\"/^\\d{3}-?\\d{2}-?\\d{4}$/\">\n" +
    "				      <div class=\"error-messages\" ng-if=\"interacted(registrationForm.ssn)\" ng-messages=\"registrationForm.ssn.$error\">\n" +
    "				      	<div ng-message=\"pattern\">SSN must be in the following format: XXX-XX-XXXX</div>\n" +
    "				  			<div ng-messages-include=\"custom-messages\"></div>\n" +
    "	      			</div>\n" +
    "				    </md-input-container>\n" +
    "				    <div flex>\n" +
    "				  		<md-datepicker ng-model=\"dob\" md-placeholder=\"Date of Birth\" name=\"dob\" required></md-datepicker>\n" +
    "				  		<div class=\"error-messages\" ng-if=\"interacted(registrationForm.dob)\" ng-messages=\"registrationForm.dob.$error\">\n" +
    "				  			<div ng-message=\"valid\">Invalid date</div>\n" +
    "				  			<div ng-messages-include=\"custom-messages\"></div>\n" +
    "	      			</div>\n" +
    "	      		</div>\n" +
    "				  </div>\n" +
    "\n" +
    "	  			<div layout-gt-md=\"row\" layout=\"column\">\n" +
    "				    <md-input-container flex>\n" +
    "				      <label>Primary Phone</label>\n" +
    "				      <input ng-model=\"clientData.phone\" name=\"phone\" required>\n" +
    "				      <div class=\"error-messages\" ng-if=\"interacted(registrationForm.phone)\" ng-messages=\"registrationForm.phone.$error\">\n" +
    "				  			<div ng-messages-include=\"custom-messages\"></div>\n" +
    "	      			</div>\n" +
    "				    </md-input-container>\n" +
    "				    <md-input-container flex>\n" +
    "				      <label>Mobile Phone</label>\n" +
    "				      <input ng-model=\"clientData.mobilePhone\" name=\"mobilePhone\" required>\n" +
    "				      <div class=\"error-messages\" ng-if=\"interacted(registrationForm.mobilePhone)\" ng-messages=\"registrationForm.mobilePhone.$error\">\n" +
    "				  			<div ng-messages-include=\"custom-messages\"></div>\n" +
    "	      			</div>\n" +
    "				    </md-input-container>\n" +
    "				  </div>\n" +
    "\n" +
    "	  			<md-subheader class=\"md-primary\">Address</md-subheader>\n" +
    "				  <div layout-gt-md=\"row\" layout=\"column\">\n" +
    "				    <md-input-container flex>\n" +
    "				      <label>Street Address</label>\n" +
    "				      <input ng-model=\"clientData.address1\" name=\"address1\" required>\n" +
    "				      <div class=\"error-messages\" ng-if=\"interacted(registrationForm.address1)\" ng-messages=\"registrationForm.address1.$error\">\n" +
    "				  			<div ng-messages-include=\"custom-messages\"></div>\n" +
    "	      			</div>\n" +
    "				    </md-input-container>\n" +
    "				  </div>\n" +
    "				  <div layout-gt-md=\"row\" layout=\"column\">\n" +
    "				    <md-input-container flex>\n" +
    "				      <label>Street Address Line 2</label>\n" +
    "				      <input ng-model=\"clientData.address2\">\n" +
    "				    </md-input-container>\n" +
    "				  </div>\n" +
    "				  <div layout-gt-md=\"row\" layout=\"column\">\n" +
    "				    <md-input-container flex>\n" +
    "				      <label>City</label>\n" +
    "				      <input ng-model=\"clientData.city\" name=\"city\" required>\n" +
    "				      <div class=\"error-messages\" ng-if=\"interacted(registrationForm.city)\" ng-messages=\"registrationForm.city.$error\">\n" +
    "				  			<div ng-messages-include=\"custom-messages\"></div>\n" +
    "	      			</div>\n" +
    "				    </md-input-container>\n" +
    "				    <md-input-container flex>\n" +
    "				      <label>State/Province</label>\n" +
    "				      <input ng-model=\"clientData.state\" name=\"state\" required>\n" +
    "				      <div class=\"error-messages\" ng-if=\"interacted(registrationForm.state)\" ng-messages=\"registrationForm.state.$error\">\n" +
    "				  			<div ng-messages-include=\"custom-messages\"></div>\n" +
    "	      			</div>\n" +
    "				    </md-input-container>\n" +
    "				  </div>\n" +
    "				  <div layout-gt-md=\"row\" layout=\"column\">\n" +
    "				    <md-input-container flex>\n" +
    "				      <label>Postal/Zip Code</label>\n" +
    "				      <input ng-model=\"clientData.zipCode\" name=\"zipCode\" required>\n" +
    "				      <div class=\"error-messages\" ng-if=\"interacted(registrationForm.zipCode)\" ng-messages=\"registrationForm.zipCode.$error\">\n" +
    "				  			<div ng-messages-include=\"custom-messages\"></div>\n" +
    "	      			</div>\n" +
    "				    </md-input-container>\n" +
    "\n" +
    "				    <md-input-container flex>\n" +
    "				      <md-select ng-model=\"clientData.country\" placeholder=\"Country\">\n" +
    "						    <md-option ng-value=\"country\" ng-repeat=\"country in countries\">{{ country }}</md-option>\n" +
    "						  </md-select>\n" +
    "				    </md-input-container>\n" +
    "\n" +
    "				  </div>\n" +
    "\n" +
    "				</div>\n" +
    "				<div flex>\n" +
    "\n" +
    "					<md-toolbar>\n" +
    "				    <div class=\"md-toolbar-tools\">\n" +
    "				      <h3 class=\"md-flex\">Financial Information</h3>\n" +
    "				    </div>\n" +
    "				  </md-toolbar>\n" +
    "	  			<br/>\n" +
    "\n" +
    "				  <div layout-gt-md=\"row\" layout=\"column\">\n" +
    "				    <md-input-container flex>\n" +
    "				      <label>Bank Name</label>\n" +
    "				      <input ng-model=\"clientData.bankName\" name=\"bankName\" required>\n" +
    "				      <div class=\"error-messages\" ng-if=\"interacted(registrationForm.bankName)\" ng-messages=\"registrationForm.bankName.$error\">\n" +
    "				  			<div ng-messages-include=\"custom-messages\"></div>\n" +
    "	      			</div>\n" +
    "				    </md-input-container>\n" +
    "				  </div>\n" +
    "				  <div layout-gt-md=\"row\" layout=\"column\">\n" +
    "				    <md-input-container flex>\n" +
    "				      <label>Account Number</label>\n" +
    "				      <input ng-model=\"clientData.bankAccountNumber\" name=\"bankAccountNumber\" required>\n" +
    "				      <div class=\"error-messages\" ng-if=\"interacted(registrationForm.bankAccountNumber)\" ng-messages=\"registrationForm.bankAccountNumber.$error\">\n" +
    "				  			<div ng-messages-include=\"custom-messages\"></div>\n" +
    "	      			</div>\n" +
    "				    </md-input-container>\n" +
    "				    <md-input-container flex>\n" +
    "				      <label>Routing Number</label>\n" +
    "				      <input ng-model=\"clientData.bankRoutingNumber\" name=\"bankRoutingNumber\" required>\n" +
    "				      <div class=\"error-messages\" ng-if=\"interacted(registrationForm.bankRoutingNumber)\" ng-messages=\"registrationForm.bankRoutingNumber.$error\">\n" +
    "				  			<div ng-messages-include=\"custom-messages\"></div>\n" +
    "	      			</div>\n" +
    "				    </md-input-container>\n" +
    "				  </div>\n" +
    "				  <div layout-gt-md=\"row\" layout=\"column\">\n" +
    "				    <md-input-container flex>\n" +
    "				      <md-select ng-model=\"clientData.bankAccountType\" name=\"bankAccountType\" required placeholder=\"Account Type\">\n" +
    "						    <md-option ng-value=\"type.code\" ng-repeat=\"type in accountTypes\">{{ type.description }}</md-option>\n" +
    "						  </md-select>\n" +
    "						  <div class=\"error-messages\" ng-if=\"interacted(registrationForm.bankAccountType)\" ng-messages=\"registrationForm.bankAccountType.$error\">\n" +
    "				  			<div ng-messages-include=\"custom-messages\"></div>\n" +
    "	      			</div>\n" +
    "				    </md-input-container>\n" +
    "				  </div>\n" +
    "				  <br/>\n" +
    "				  <md-toolbar>\n" +
    "				    <div class=\"md-toolbar-tools\">\n" +
    "				      <h3 class=\"md-flex\">Royalty Information</h3>\n" +
    "				    </div>\n" +
    "				  </md-toolbar>\n" +
    "	  			<br/>\n" +
    "\n" +
    "				  <div layout-gt-md=\"row\" layout=\"column\" ng-repeat=\"royaltyEarning in royaltyEarnings.earnings\">\n" +
    "				    <md-input-container flex>\n" +
    "				      <label>Royalty Source</label>\n" +
    "				      <input ng-model=\"royaltyEarning.source\">\n" +
    "				    </md-input-container>\n" +
    "				    <md-input-container flex>\n" +
    "				      <label>Name on Account</label>\n" +
    "				      <input ng-model=\"royaltyEarning.nameOnAccount\">\n" +
    "				    </md-input-container>\n" +
    "				    <md-input-container flex>\n" +
    "				      <label>Account Number</label>\n" +
    "				      <input ng-model=\"royaltyEarning.accountNumber\">\n" +
    "				    </md-input-container>\n" +
    "				    <md-input-container flex>\n" +
    "				      <label>Estimated Annual Royalties</label>\n" +
    "				      <input ng-model=\"royaltyEarning.estimatedRoyalties\">\n" +
    "				    </md-input-container>\n" +
    "				  </div>\n" +
    "\n" +
    "					<input type=\"file\" ngf-select ng-model=\"royaltyEarningsFile\" name=\"file\" ngf-pattern=\"'text/csv'\" ngf-accept=\"'text/csv'\" ngf-max-size=\"2MB\" ngf-model-invalid=\"errorFiles\">\n" +
    "\n" +
    "					<section layout=\"row\" layout-align=\"end center\" layout-padding>\n" +
    "						<md-radio-group ng-model=\"postType.type\">\n" +
    "				      <md-radio-button value=\"json\" class=\"md-primary\">JSON</md-radio-button>\n" +
    "				      <md-radio-button value=\"form\" class=\"md-primary\">Form</md-radio-button>\n" +
    "				      <md-radio-button value=\"base64Encoded\" class=\"md-primary\">Base64 Encoded</md-radio-button>\n" +
    "				    </md-radio-group>\n" +
    "	        	<md-button type=\"submit\" class=\"md-raised md-primary\">Get Advance</md-button>\n" +
    "	        	<!-- <md-button class=\"md-raised md-primary\" onclick=\"getAdvance()\">Get Advance</md-button> -->\n" +
    "	      	</section>\n" +
    "				</div>\n" +
    "			</div>\n" +
    "		</form>\n" +
    "	</md-content>\n" +
    "</div>");
}]);
