import React from "react"
import PropTypes from "prop-types"

class SpeciesPicker extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            mode: 'waiting',
            image_path: props.image_path,
            options: props.options,
            next_image_path: undefined,
            next_options: undefined,
        };
        this.handleClick = this.handleClick.bind(this);
        this.next = this.next.bind(this);
    }

    gen_options() {
        let options = new Array
        for (let i = 0; i < this.state.options.length; i++) {
            let tmp = i;
            options.push(
                <li key={i}>
                    <button data-index={i} onClick={this.handleClick}>Guess</button>
                    {this.state.options[i].common_name} <span
                    className='sci_name'>({this.state.options[i].sci_name})</span>
                </li>);
        }
        return options
    }

    next(e) {
        this.setState ({
            common_name: undefined,
            sci_name: undefined,
            mode: 'waiting',
            options: this.state.next_options,
            image_path: this.state.next_image_path,
            next_options: undefined,
            next_image_path: undefined,
        });
    }

    handleClick(e) {
        let index = e.target.attributes[0].nodeValue;
        let auth_token = document.querySelector("meta[name='csrf-token']").content;
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
                'X-Requested-With': 'XMLHttpRequest',
            },
            credentials: 'same-origin',
        }).then(res => res.json()).then((result) => {
            this.state.common_name = result['common_name'];
            this.state.sci_name = result['sci_name'];
            this.state.next_options = result['next_options'];
            this.state.next_image_path = result['next_image_path'];

            if (result['correct'] == true) {
                this.setState({mode: 'correct'})
            } else {
                this.setState({mode: 'incorrect'});
            }
        })
    };

    render() {
        var options_html = this.gen_options();
        var next_button = '';
        var message = "";
        if (this.state.mode == 'loading') {
            message = <span>Loading</span>;
            options_html = <img src='/loading.svg'></img>;
        } else if (this.state.mode == 'correct') {
            message = <span><span className={'correct'}>Correct!</span> {this.state['common_name']} <span
                className="sci_name">({this.state['sci_name']})</span></span>
            next_button = <button onClick={this.next} id={'next'}>Next</button>
        } else if (this.state.mode == 'incorrect') {
            message = <span><span className={'incorrect'}>Incorrect</span>, it was a: {this.state['common_name']} <span
                className="sci_name">{this.state['sci_name']}</span></span>
            next_button = <button onClick={this.next} id={'next'}>Next</button>
        } else if (this.state.mode == 'waiting') {
            message = "Make your best guess"
        }
        return (
            <div className="species">
                <h2>{message}</h2>
                <ul>{options_html}</ul>
                {next_button}
                <br/>
                <img src={this.props.image_path}></img>

            </div>
        )
    }
}

SpeciesPicker.propTypes = {
    options: PropTypes.array,
    next_options: PropTypes.array,
    image_path: PropTypes.string,
    next_image_path: PropTypes.string,
};

export default SpeciesPicker

/*
*
* */