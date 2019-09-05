import React from "react"
import PropTypes from "prop-types"

class Setusername extends React.Component {
  constructor(props) {
    super(props);
    let auth_token = document.querySelector("meta[name='csrf-token']").content;
    this.state = {
      csrf: auth_token,
      username_valid: '',
      username_error: '',
    };
    this.handleUsername = this.handleUsername.bind(this);
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
      if (result.valid) {
        this.setState({username_valid: "valid", username_error: "", username_class: ''})
      } else {
        this.setState({username_valid: "invalid", username_error: "Username is taken", username_class: ''})
      }
    });

    this.setState({username_class: 'loading_anim'});


    if (username.value != "") {
      this.setState({username_touched: true});
    }
  }

  render() {
    return (
        <div className={'center'}>
          <div id={''}>
            <div className={'center'}>
              <h2>Pick your username</h2>
            </div>
            <div className={'center'}>
              <p>This will be visible to other users</p>
            </div>

            <div className={'center'}>
              <form className="new_user" id="sign_up_new_user" action="/users/set_username"
                    acceptCharset="UTF-8" method="post">



                <input name="utf8" type="hidden" value="✓"/>
                <input type="hidden" name="authenticity_token" value={this.state.csrf}/>

                <div className="field">
                  <label htmlFor="user_username">Username</label><br/>
                  <input onKeyUp={this.handleUsername} className={this.state.username_valid}
                         autoFocus="autofocus" autoComplete="username" type="text"
                         name="user[username]"
                         id="user_username"/>
                  <div className={this.state.username_class}></div>

                  <div className={'warning'}>{this.state.username_error}</div>
                </div>
              </form>
            </div>
          </div>
        </div>

    )
  }
};

export default Setusername
