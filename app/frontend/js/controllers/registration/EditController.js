import swal from 'sweetalert';

export default {
  init() {
    const deleteAccountForm = document.querySelector('#delete_account_form');
    const deleteAccountButton = document.querySelector('#delete_account_button');

    deleteAccountButton.addEventListener('click', (ev) => {
      ev.preventDefault();
      swal({
        title: ev.target.dataset.alertTitle,
        text: ev.target.dataset.alertText,
        buttons: {
          cancel: {
            text: ev.target.dataset.alertCancelText,
            value: null,
            visible: true,
            className: 'button is-light',
            closeModal: true,
          },
          confirm: {
            text: ev.target.dataset.alertConfirmText,
            value: true,
            visible: true,
            className: 'button is-danger',
            closeModal: true,
          },
        },
        dangerMode: true,
      }).then((willDelete) => {
        if (willDelete) {
          deleteAccountForm.submit();
        }
      });
    });
  },
};
