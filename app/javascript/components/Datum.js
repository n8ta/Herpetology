import React from "react"
import Zoom from './Zoom.js';
import Name from './Name.js';
import PropTypes from "prop-types"

class Datum extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            mode: 'waiting',
            sci_name: 'Loading...',
            common_name: 'Loading...',
            correct: 0,
            seen: 0,
            image_path: "",
        };
        let auth_token = document.querySelector("meta[name='csrf-token']").content;
        fetch('/user_species_data/' + this.props.species_id + '.json', {
            method: 'GET',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
                'X-CSRF-Token': auth_token,
                'X-Requested-With': 'XMLHttpRequest',
            },
            credentials: 'same-origin',
        }).then(res => res.json()).then((result) => {

            this.setState({
                mode: 'ready',
                sci_name: result['species']['genus']['name'] + ' ' + result['species']['name'],
                common_name: result['species']['common_names'][0]['name'],
                correct: result['correct'],
                seen: result['seen'],
            });
            console.log(result);
        });
    }


    render() {
        var title = '';
        if (this.state.mode == 'waiting') {
            title = "Loading..."
        } else if (this.state.mode == 'ready') {
            title = <Name sciName={this.state.sci_name} commonName={this.state.common_name}></Name>
        }
        return (
            <div className={'datum ' + this.state.mode}>
                <h2>{title}</h2>
                <p>You've seen this species <strong>{this.state.seen}</strong> time(s), and gotten it
                    right <strong>{this.state.correct}</strong> time(s).</p>
                <Zoom url={this.props.image_path}></Zoom>

            </div>
        );
    }
}

Datum.propTypes = {
    species_id: PropTypes.number,
    image_path: PropTypes.string,
};
export default Datum
