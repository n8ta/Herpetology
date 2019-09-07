import React from "react"
import PropTypes from "prop-types"

class Signin extends React.Component {

    constructor(props) {
        super(props);
        let auth_token = document.querySelector("meta[name='csrf-token']").content;
        this.state = {
            csrf: auth_token,
            ready: '',
            email_class: '',
            email_ready: undefined,
            password_class: '',
            password_ready: undefined
        };
        this.handleEmail = this.handleEmail.bind(this);
        this.handlePassword = this.handlePassword.bind(this);
    }

    handleEmail() {
        let email = document.getElementById('user_email');
        if (email == undefined) {
            return
        }
        email = email.value;

        function validateEmail(email) {
            var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
            return re.test(String(email).toLowerCase());
        }

        if (validateEmail(email)) {
            this.setState({email_ready: true, email_class: 'valid'})
        } else {
            this.setState({email_ready: false, email_class: ''})
        }
    }

    handlePassword() {

        let user_password = document.getElementById('user_password');
        if (user_password == undefined) {
            return
        }
        user_password=user_password.value;
        if (user_password == '') {
            this.setState({password_ready: false, password_class: ''});
        } else {
            this.setState({password_ready: true, password_class: 'valid'})
        }
    }


    render() {
        return (
            <div>
            <div className={'center'}>
                <h2>Log in</h2>
            </div>
            <div className='center'>
            <form onKeyUpCapture={this.updateButton} className="new_user" id="new_user" action="/users/sign_in" acceptCharset="UTF-8" method="post">


                    <input name="utf8" type="hidden" value="✓"/>
                    <input type="hidden" name="authenticity_token" value={this.state.csrf}/>
                    <input type="hidden" name="return_url" value={window.location}/>


                    <div className="field">
                        <label htmlFor="user_email">Email</label><br/>
                        <input onChange={this.handleEmail} className={this.state.email_class} autoFocus="autofocus"
                               autoComplete="email" type="email" name="user[email]"
                               id="user_email"/>
                    </div>
                    <div className="field">
                        <label htmlFor="user_password">Password</label><br/>
                        <input onKeyUp={this.handlePassword} className={this.state.password_class}
                               autoComplete="current-password" type="password" name="user[password]"
                               id="user_password"/>
                    </div>

                    <div className="field checkbox_container">
                        <input name="user[remember_me]" type="hidden" value="0"/>
                        <input defaultChecked type="checkbox" value="1"
                               name="user[remember_me]"
                               id="user_remember_me"/>
                        <label htmlFor="user_remember_me">Remember me</label>
                    </div>

                    <div className="actions center">
                        <input type="submit" className={this.state.password_ready && this.state.email_ready ? "ready" : ""} name="commit" value="Log in"
                               data-disable-with="Log in"/>
                    </div>
                </form>
            </div>
            </div>
        )
    }
}

export default Signin
