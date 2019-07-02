import React from "react"
import PropTypes from "prop-types"

class Signup extends React.Component {
    constructor(props) {
        super(props);
        let auth_token = document.querySelector("meta[name='csrf-token']").content;
        this.state = {
            csrf: auth_token,
            class: 'disabled',
            email_valid: '',
            email_error: '',
            username_valid: '',
            username_error: '',
            password_valid: '',
            password_error: '',
            username_touched: false,

        };
        console.log(auth_token);
        this.handleSubmit = this.handleSubmit.bind(this);
        this.handleChange = this.handleChange.bind(this);
        this.handleUsername = this.handleUsername.bind(this);
    }

    handleSubmit() {
        Cookies.set("asked_about_signup",true,{expires: 365})
    }

    handleUsername() {
        let username = document.getElementById('user_username');

        if (username.value != "") {
            this.setState({username_touched: true});
        }
        console.log('handle users');
        this.handleChange();
    }

    handleChange() {
        console.log('handling change');
        let email = document.getElementById('user_email');
        let username = document.getElementById('user_username');
        let user_password = document.getElementById('user_password');
        let user_password_confirmation = document.getElementById('user_password_confirmation');

        function validateEmail(email) {
            var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
            return re.test(String(email).toLowerCase());
        }

        let email_valid = '';
        let email_error = '';
        let username_valid = '';
        let username_error = '';
        let password_valid = '';
        let password_error = '';
        let overall_state = '';


        if (email && validateEmail(email.value)) {
            email_valid = 'valid';
            email_error: '';
        } else if (email.value == "") {
            email_valid = '';
            email_error = '';
        } else {
            email_valid = '';
            email_error = 'Invalid email address'
        }

        if ((username.value != '') && (this.state.username_touched == false)) {
            username_valid = '';
            username_error = ''
        } else if ((username.value == "") && (this.state.username_touched == true)) {
            username_valid = '';
            username_error = 'Enter a username'
        } else if (username.value == "") {
            username_valid = '';
            username_error = ''
        } else {
            username_valid = 'valid';
            username_error = ''
        }

        if ((user_password.value != '') && (user_password_confirmation.value != '') && (user_password.value != user_password_confirmation.value)) {
            password_valid = '';
            password_error = 'Passwords Must Match'
        } else if (user_password.value != '' && user_password_confirmation.value != '' && user_password.value.length < 12) {
            password_valid = '';
            password_error = 'Password must be 12 or more characters'
        } else if ((user_password.value == user_password_confirmation.value) && (user_password.value.length > 11)) {
            password_valid = 'valid';
            password_error =  ''
        } else {
            password_valid = '';
            password_error = ''
        }


        if ((this.state.email_valid == "valid") && (this.state.username_valid == "valid") && (this.state.password_valid == "valid")) {
            overall_state = 'ready'
        } else {
            overall_state = ''
        }


        this.setState({class: overall_state, username_valid: username_valid, username_error: username_error, email_valid: email_valid, email_error: email_error, password_valid: password_valid, password_error: password_error});
        this.render();
    }


    render() {
        return (
            <div className={'center'}>
                <form onKeyUp={this.handleChange} className="new_user" id="new_user" action="/users" acceptCharset="UTF-8" method="post">


                    <input name="utf8" type="hidden" value="✓"/>
                    <input type="hidden" name="authenticity_token" value={this.state.csrf}/>

                    <div className="field">
                        <label htmlFor="user_email">Email</label><br/>
                        <input className={this.state.email_valid} onChange={this.handleChange} autoFocus="autofocus"
                               autoComplete="email" type="email"
                               name="user[email]"
                               id="user_email"/>
                        <div className={'warning'}>{this.state.email_error}</div>
                    </div>

                    <div className="field">
                        <label htmlFor="user_username">Username</label><br/>
                        <input className={this.state.username_valid} onChange={this.handleUsername}
                               autoFocus="autofocus" autoComplete="username" type="text"
                               name="user[username]"
                               id="user_username"/>
                        <div className={'warning'}>{this.state.username_error}</div>
                    </div>

                    <div className="field">
                        <label htmlFor="user_password">Password</label>
                        <em>(12 characters minimum)</em>
                        <br/>
                        <input className={this.state.password_valid} onChange={this.handleChange}
                               autoComplete="new-password" type="password"
                               name="user[password]" id="user_password"/>

                    </div>

                    <div className="field">
                        <label htmlFor="user_password_confirmation">Password confirmation</label><br/>
                        <input className={this.state.password_valid}
                               onChange={this.handleChange} autoComplete="new-password" type="password"
                               name="user[password_confirmation]"
                               id="user_password_confirmation"/>
                        <div className={'warning'}>{this.state.password_error}</div>
                    </div>

                    <div className="actions center">
                        <input onClick={this.handleSubmit} className={this.state.class} type="submit" name="commit" value="Sign up"
                               data-disable-with="Sign up"/>
                    </div>
                </form>
            </div>
        )
    }
};

export default Signup
