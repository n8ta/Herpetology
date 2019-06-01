import React from "react"
import PropTypes from "prop-types"

class Datum extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            mode: 'ready',
            sci_name: 'sci_name',
            common_name: 'common_name',
            correct: 10,
            seen: 100,
            image_url: "https://i.postimg.cc/XvX90qPf/snek.png"
        };
    }

    componentDidMount() {
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
            console.log('loaded');
            this.setState({
                mode: 'ready',
                sci_name: 'sci_name',
                common_name: 'common_name',
                correct: 10,
                seen: 100,
                image_url: "https://i.postimg.cc/XvX90qPf/snek.png"
            });
        });
    }


    render() {
        var title = '';
        console.log('rendering:');
        if (this.state.mode == 'waiting') {
            console.log('  state: ', this.state.mode);
            title = "Loading..."
        } else if (this.state.mode == 'ready') {
            console.log(this.state);
            title = <span><span class="common_name">{this.state.common_name}</span> <span className="sci_name">{this.state.sci_name}</span></span>
            console.log('  state: ', this.state.mode);
        }
        return (
            <React.Fragment>
                <h2>{title}</h2>
                <img src={this.state.image_url}></img>
                <p>Correct: {this.state.correct}, Seen: {this.state.seen}</p>
            </React.Fragment>
        );
    }
}

Datum.propTypes = {
    species_id: PropTypes.number
};
export default Datum
