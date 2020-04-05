import React from "react"
import PropTypes from "prop-types"
import Report from "../Report";
import Alert from "../svgs/Alert";

class Deadherpreport extends React.Component {
    constructor(props) {
        super(props);
        let auth_token = document.querySelector("meta[name='csrf-token']").content;
        this.state = {csrf: auth_token, submitted: false};
        this.post = this.post.bind(this)
    }

    shouldComponentUpdate(next_props,next_state) {

        // Update when submitted changes state or props change
        if ((next_props.photo_id != this.props.photo_id) || (next_state.submitted == true && this.state.submitted == false) ) {
            this.state.submitted = false;
            return true
        } else {
            return false
        }
    }

    post() {
        this.setState({submitted: true});
        let auth_token = document.querySelector("meta[name='csrf-token']").content;
        this.setState({mode: 'loading'});
        let no_flash = "";
        if (this.props.no_flash == true) {
            no_flash = "&no_flash=true"
        }
        fetch('/reports?type=DeadHerpReport&photo_id='+this.props.photo_id+no_flash, {
            method: 'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
                'X-CSRF-Token': auth_token,
                'X-Requested-With': 'XMLHttpRequest',
            },
            credentials: 'same-origin',

        }).then(res => res.json()).then((result) => {
            this.props.after_report()
        });
    }


    render() {
        if (this.state.submitted == false) {
            return (
                <div className="center">
                    <button onClick={this.post} className={'small'}><Alert/>Dead Herp</button>
                </div>
            );
        } else {
            return (
                <div className="center">
                    <button className={'small submitted'}>Submitted Report, thanks!</button>
                </div>
            );
        }

    }
}

export default Deadherpreport

Report.propTypes = {
    photo_id: PropTypes.number,
    after_report: PropTypes.func,
};
