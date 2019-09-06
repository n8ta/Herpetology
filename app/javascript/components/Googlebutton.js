import React from "react"
import PropTypes from "prop-types"
import Taxon from "./Taxon";

class Googlebutton extends React.Component {

    constructor(props) {
        super(props)
        if (this.props.return_url != undefined) {
            let auth_token = document.querySelector("meta[name='csrf-token']").content;
            let data = { url: this.props.return_url };
            fetch('/users/set_return_url', {
                method: 'POST',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json',
                    'X-CSRF-Token': auth_token,
                    'X-Requested-With': 'XMLHttpRequest',
                },
                body: JSON.stringify(data),
                credentials: 'same-origin',

            }).then(res => res.json()).then((result) => {
            })
        }
    }


    render() {
        return (
            <span className={'google_button'}>
                <a href={"/users/auth/google_oauth2"}><img title={"Sign in with google"} src={"/assets/sign_in.png"}/></a>
            </span>
        );
    }
}


Googlebutton.propTypes = {
    return_url: PropTypes.string,
};



export default Googlebutton
