import React from "react"
import PropTypes from "prop-types"
import SpeciesPicker from "./SpeciesPicker";

class Settings extends React.Component {
    constructor(props) {
        super(props);
        let auth_token = document.querySelector("meta[name='csrf-token']").content;
        this.state = {csrf: auth_token};
        this.post = this.post.bind(this);
    }


    post() {

        setTimeout(function () {
            let opt_out = document.getElementById('opt_out').checked;
            let show_dead = document.getElementById('show_dead').checked;
            console.log("opt_out", opt_out);
            console.log("show dead", show_dead);
            this.state.show_dead = !this.state.show_dead;
            let body = {};
            body['opt_out_of_email'] = opt_out;
            body['show_dead'] = show_dead;
            fetch('/users/settings', {
                method: 'POST',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json',
                    'X-CSRF-Token': this.state.csrf,
                    'X-Requested-With': 'XMLHttpRequest',
                },
                credentials: 'same-origin',
                body: JSON.stringify(body),
            })
        }.bind(this), 100);
    }

    render() {
        return (
            <React.Fragment>
                <div>
                    <input defaultChecked={this.props.show_dead} onClick={this.post} type="checkbox"
                           id={'show_dead'}/>
                    <label htmlFor="show_dead">Show dead animals</label>
                </div>
                <div>
                    <input defaultChecked={this.props.opt_out} onClick={this.post} type="checkbox" id={'opt_out'}/>
                    <label htmlFor="opt_out">Opt out of any email</label>
                </div>
            </React.Fragment>
        );
    }
}

Settings.propTypes = {
    show_dead: PropTypes.bool,
    email_opted_out: PropTypes.bool,
};

export default Settings
