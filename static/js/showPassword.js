function togglePassword(button) {
    const passwordField = button.parentNode.querySelector('input');

    if (passwordField.type === 'password') {
        passwordField.type = 'text';
    } else {
        passwordField.type = 'password';
    }
}
