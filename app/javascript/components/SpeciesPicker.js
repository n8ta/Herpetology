import React from "react"
import PropTypes from "prop-types"

class SpeciesPicker extends React.Component {
    constructor(props) {
        super(props);
        this.state = {mode: 'waiting'};
        this.handleClick = this.handleClick.bind(this);
    }

    handleClick(e) {
        let index = e.target.attributes[0].nodeValue;
        let auth_token = document.querySelector("meta[name='csrf-token']").content;
        console.log("Auth token:",auth_token);
        this.setState({mode: 'loading'});
        let region_id = window.location.toString().split("regions/")[1];
        if (region_id[region_id.length - 1] == '/') {
            region_id = region_id.substring(0, region_id.length - 1);
        }
        fetch('/regions/' + region_id + '/guess/' + index, {
            method: 'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
                'X-CSRF-Token': auth_token,
            },
        }).then(res => res.json()).then((result) => {
            console.log(result);
            this.state.common_name = result['common_name'];
            console.log(result['common_name']);
            console.log(result['sci_name']);
            this.state.sci_name = result['sci_name'];
            console.log('set general state:');
            console.log(this.state);

            if (result['correct'] == true) {
                this.setState({mode: 'correct'})
            } else {
                this.setState({mode: 'incorrect'});
            }
        })
    };

    render() {
        var options = [];
        var next = '';
        for (let i = 0; i < this.props.options.length; i++) {
            let tmp = i;
            options.push(
                <li key={i}>
                    <button data-index={i} onClick={this.handleClick}>Me!</button>
                    {this.props.options[i].common_name} <span className='sci_name'>({this.props.options[i].sci_name})</span>
                </li>);
        }
        var message = "";
        if (this.state.mode == 'loading') {
            message = <span>Loading</span>
            options = <img src='/loading.svg'></img>
        } else if (this.state.mode == 'correct') {
            message = <span>Correct! {this.state['common_name']} <span className="sci_name">({this.state['sci_name']})</span></span>
            next = <a href={window.location}>Next</a>
        } else if (this.state.mode == 'incorrect') {
            message = <span>Incorrect, it was: {this.state['common_name']} <span className="sci_name">{this.state['sci_name']}</span></span>
            next = <a href={window.location}>Next</a>
        } else if (this.state.mode == 'waiting') {
            message = "Make your best guess"
        }
        return (
            <div className="species">
                <h2>{message}</h2>
                {next}
                <ul>{options}</ul>

                <br/>
                <img src={this.props.image_path}></img>

            </div>
        )
    }
}

SpeciesPicker.propTypes = {
    id: PropTypes.number,
    image_path: PropTypes.string,
    options: PropTypes.array,
};

export default SpeciesPicker
