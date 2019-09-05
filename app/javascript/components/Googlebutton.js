import React from "react"
import PropTypes from "prop-types"

class Googlebutton extends React.Component {
    render() {
        return (
            <span className={'google_button'}>
                <a href={"/users/auth/google_oauth2"}><img title={"Sign in with google"} src={"/assets/sign_in.png"}/></a>
            </span>
        );
    }
}

export default Googlebutton
