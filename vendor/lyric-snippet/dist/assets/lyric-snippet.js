var advanceRequestComplete, advanceRequestError, closeModal, confirm, confirmed, errorModal, modal, span, waitModal;

modal = null;

span = null;

waitModal = null;

errorModal = null;

window.onload = function() {
  var errorModalTemplate, modalTemplate, waitModalTemplate;
  modalTemplate = mytemplate["templates/terms_and_conditions_modal.tpl.html"];
  document.body.insertAdjacentHTML('beforeend', modalTemplate);
  waitModalTemplate = mytemplate["templates/wait_indicator.tpl.html"];
  document.body.insertAdjacentHTML('beforeend', waitModalTemplate);
  errorModalTemplate = mytemplate["templates/error.tpl.html"];
  document.body.insertAdjacentHTML('beforeend', errorModalTemplate);
  modal = document.getElementById('tcModal');
  waitModal = document.getElementById('waitModal');
  errorModal = document.getElementById('errorModal');
  span = document.getElementsByClassName("close")[0];
  return span.onclick = function() {
    return modal.style.display = 'none';
  };
};

window.onclick = function(event) {
  if (event.target === modal) {
    modal.style.display = 'none';
  }
  if (event.target === errorModal) {
    return errorModal.style.display = 'none';
  }
};

confirm = function() {
  return modal.style.display = "block";
};

closeModal = function() {
  modal.style.display = "none";
  return errorModal.style.display = "none";
};

confirmed = function() {
  var event;
  if (window.CustomEvent) {
    event = new CustomEvent('confirmationComplete');
  } else {
    event = document.createEvent('CustomEvent');
    event.initCustomEvent('confirmationComplete', true, true);
  }
  document.dispatchEvent(event);
  modal.style.display = 'none';
  return waitModal.style.display = "block";
};

advanceRequestComplete = function(accessToken) {
  waitModal.style.display = "none";
  return window.open('http://vatm.dev:8080?access_token=' + accessToken, '_blank');
};

advanceRequestError = function() {
  waitModal.style.display = "none";
  return errorModal.style.display = "block";
};
