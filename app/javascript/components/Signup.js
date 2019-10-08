import React from "react"
import Googlebutton from "./Googlebutton";
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
        this.handleSubmit = this.handleSubmit.bind(this);
        this.handleChange = this.handleChange.bind(this);
        this.handleUsername = this.handleUsername.bind(this);
        this.handleEmail = this.handleEmail.bind(this);
    }

    handleSubmit() {
        ga('send', 'event', 'compete', 'signup', 'true');
        Cookies.set("asked_about_signup", true, {expires: 365})
    }

    handleUsername() {

        let username = document.getElementById('user_username');
        let encoded = btoa(username.value);
        let auth_token = document.querySelector("meta[name='csrf-token']").content;
        fetch('/users/username_available/' + encoded, {
            method: 'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
                'X-CSRF-Token': auth_token,
                'X-Requested-With': 'XMLHttpRequest',
            },
            credentials: 'same-origin',


        }).then(res => res.json()).then((result) => {
            if (result['valid'] == true) {
                this.setState({username_valid: 'valid', username_error: '', username_class: ''})
            } else {
                this.setState({username_valid: '', username_error: 'Username taken', username_class: ''})
            }
            this.handleChange();
        });

        this.setState({username_class: 'loading_anim'});


        if (username.value != "") {
            this.setState({username_touched: true});
        }
        this.handleChange();
    }

    handleEmail() {

        function validateEmail(email) {
            var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
            return re.test(String(email).toLowerCase());
        }


        let email = document.getElementById('user_email');
        let encoded = btoa(email.value);
        let auth_token = document.querySelector("meta[name='csrf-token']").content;


        if (email && validateEmail(email.value)) {
            fetch('/users/email_available/' + encoded, {
                method: 'POST',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json',
                    'X-CSRF-Token': auth_token,
                    'X-Requested-With': 'XMLHttpRequest',
                },
                credentials: 'same-origin',


            }).then(res => res.json()).then((result) => {
                if (result['valid'] == true) {
                    this.setState({email_valid: 'valid', email_error: '', email_class: ''})
                } else {
                    this.setState({email_valid: '', email_error: 'Email taken', email_class: ''})
                }
                this.handleChange();

            });

            this.setState({email_class: 'loading_anim'});

        } else {
            this.setState({email_class: '', email_error: '', email_valid: ''})
        }
        this.handleChange();

    }

    handleChange() {
        let email = document.getElementById('user_email');
        let username = document.getElementById('user_username');
        let user_password = document.getElementById('user_password');
        let user_password_confirmation = document.getElementById('user_password_confirmation');


        let email_valid = this.state.email_valid;
        let email_error = this.state.email_error;
        let username_valid = this.state.username_valid;
        let username_error = this.state.username_error;
        let password_valid = '';
        let password_error = '';
        let overall_state = '';

        if ((username.value == "") && (this.state.username_touched == true)) {
            username_valid = '';
            username_error = 'Enter a username';
        } else if (username.value == "") {
            username_valid = '';
            username_error = '';
        }

        if ((user_password.value != '') && (user_password_confirmation.value != '') && (user_password.value != user_password_confirmation.value)) {
            password_valid = '';
            password_error = 'Passwords Must Match'
        } else if (user_password.value != '' && user_password_confirmation.value != '' && user_password.value.length < 12) {
            password_valid = '';
            password_error = 'Password must be 12 or more characters'
        } else if ((user_password.value == user_password_confirmation.value) && (user_password.value.length > 11)) {
            password_valid = 'valid';
            password_error = ''
        } else {
            password_valid = '';
            password_error = ''
        }


        if ((this.state.email_valid == "valid") && (this.state.username_valid == "valid") && (this.state.password_valid == "valid")) {
            overall_state = 'ready';
        } else {
            overall_state = '';
        }


        this.setState({
            username_valid: username_valid,
            username_error: username_error,
            class: overall_state,
            email_valid: email_valid,
            email_error: email_error,
            password_valid: password_valid,
            password_error: password_error
        });
        this.render();

    }


    render() {
        return (
            <div className={'center'}>
                <div id={'signup'}>
                    <div className={'center'}>
                        <h2>Sign Up </h2>
                    </div>
                    <div className={'center'}>
                        <p>Creating an account puts you on the scoreboard and lets us tailor the species you see to show you those you need to practice more.</p>
                    </div>

                    <div className={'center'}>
                    <Googlebutton return_url={this.props.return_url}/>
                    </div>

                    <div className={'center'}>
                        <form onKeyUp={this.handleChange} className="new_user" id="sign_up_new_user" action="/users"
                              acceptCharset="UTF-8" method="post">



                            <input name="utf8" type="hidden" value="✓"/>
                            <input type="hidden" name="authenticity_token" value={this.state.csrf}/>
                            <input type="hidden" name="return_url" value={this.props.return_url}/>

                            <div className="field">
                                <label htmlFor="user_email">Email</label><br/>
                                <input className={this.state.email_valid} onChange={this.handleEmail}
                                       autoFocus="autofocus"
                                       autoComplete="email" type="email"
                                       name="user[email]"
                                       id="user_email"/>
                                <div className={this.state.email_class}></div>


                                <div className={'warning'}>{this.state.email_error}</div>
                            </div>

                            <div className="field">
                                <label htmlFor="user_username">Username</label><br/>
                                <input className={this.state.username_valid} onChange={this.handleUsername}
                                       autoFocus="autofocus" autoComplete="username" type="text"
                                       name="user[username]"
                                       id="user_username"/>
                                <div className={this.state.username_class}></div>

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
                                <input onClick={this.handleSubmit} className={this.state.class} type="submit"
                                       name="commit" value="Sign up"
                                       data-disable-with="Sign up"/>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

        )
    }
};

Signup.propTypes = {
    return_url: PropTypes.string,
};

export default Signup
