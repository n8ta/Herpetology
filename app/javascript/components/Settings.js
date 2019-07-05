import React from "react"
import PropTypes from "prop-types"
import SpeciesPicker from "./SpeciesPicker";

class Settings extends React.Component {
    constructor(props) {
        super(props);
        let auth_token = document.querySelector("meta[name='csrf-token']").content;
        this.state  = {show_dead: this.props.show_dead, csrf: auth_token};
        this.update = this.update.bind(this);
    }

    update() {
        this.state.show_dead = !this.state.show_dead;
        let url =  "";
        if (this.state.show_dead == true) {
            url = "/users/show_dead"
        } else if (this.state.show_dead == false) {
            url = "/users/hide_dead"
        }

        fetch(url, {
            method: 'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
                'X-CSRF-Token': this.state.csrf,
                'X-Requested-With': 'XMLHttpRequest',
            },
            credentials: 'same-origin',

        })




    }
    render() {
        return (
            <React.Fragment>
                    <input defaultChecked={this.props.show_dead} onClick={this.update} type="checkbox" id={'show_dead'}/>
                <label htmlFor="show_dead">Show dead animals</label>
            </React.Fragment>
        );
    }
}

SpeciesPicker.propTypes = {
    show_dead: PropTypes.bool,
};

export default Settings
