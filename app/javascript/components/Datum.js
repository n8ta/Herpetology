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
            sci_correct: 0,
            common_correct: 0,
            sci_seen: 0,
            common_seen: 0,
            image_path: "",
        };
        let auth_token = document.querySelector("meta[name='csrf-token']").content;
        fetch('/user_taxon_data/' + this.props.species_id + '.json', {
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
                sci_correct: result['sci_correct'],
                common_correct: result['common_correct'],
                sci_seen: result['sci_seen'],
                common_seen: result['common_seen'],
            });
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
                <Zoom url={this.props.image_path}></Zoom>
                <p>Scientific: {this.state.sci_correct}/{this.state.sci_seen}  Common: {this.state.common_correct}/{this.state.common_seen}</p>
            </div>
        );
    }
}

Datum.propTypes = {
    species_id: PropTypes.number,
    image_path: PropTypes.string,
};
export default Datum
