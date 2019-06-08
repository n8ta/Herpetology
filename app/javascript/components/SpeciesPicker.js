import React from "react"
import Zoom from './Zoom.js';
import Name from './Name.js';
import Datum from './Datum.js';
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
            prev_image_path: undefined,
        };
        this.handleClick = this.handleClick.bind(this);
        this.next = this.next.bind(this);
    }
    gen_options() {
        let options = new Array
        let disabled = this.state.mode == 'correct' || this.state.mode == "incorrect" || this.state.mode == "loading";
        for (let i = 0; i < this.state.options.length; i++) {
            let tmp = i;
            let btn_class = "";
            if (tmp == this.state.correct_index) {
                console.log(tmp,"correct");
                btn_class = "correct"
            }
            if (tmp == this.state.incorrect_index) {
                console.log(tmp,"incorrect");
                btn_class = "incorrect"
            }
            options.push(
                <li key={i}>
                    <button className={btn_class} disabled={disabled} data-index={i}
                            onClick={this.handleClick}>
                        <Name sciName={this.state.options[i].sci_name} commonName={this.state.options[i].common_name}></Name>
                    </button>
                </li>);
        }
        return options
    }
    preload(image_path) {
        let image = new Image();
        image.onload;
        image.src = image_path;
    }
    next(e) {
        this.setState({
            common_name: undefined,
            sci_name: undefined,
            mode: 'waiting',
            options: this.state.next_options,
            image_path: this.state.next_image_path,
            next_options: undefined,
            next_image_path: undefined,
            correct_index: undefined,
            incorrect_index: undefined,
        });
    }

    handleClick(e) {
        let index = e.currentTarget.dataset.index;
        console.log("index: ",index);
        let auth_token = document.querySelector("meta[name='csrf-token']").content;
        this.setState({mode: 'loading'});

        fetch(window.location + '/guess/' + index, {
            method: 'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
                'X-CSRF-Token': auth_token,
                'X-Requested-With': 'XMLHttpRequest',
            },
            credentials: 'same-origin',
        }).then(res => res.json()).then((result) => {
            this.setState({
                common_name: result['common_name'],
                sci_name: result['sci_name'],
                next_options: result['next_options'],
                next_image_path: result['next_image_path'],
                species_id: result['species_id'],
                prev_image_path: this.state.image_path
            });
            this.preload(result['next_image_path']);




            if (result['correct'] == true) {
                this.setState({mode: 'correct'});
            } else {
                this.setState({
                    mode: 'incorrect',
                    incorrect_index: result['guess_index']
                });
            }
            this.setState({correct_index: result['correct_index']});
        })
    };

    render() {
        let options_html = this.gen_options();
        let next_button = '';
        let message = '';
        let right = '';
        if (this.state.mode == 'loading') {
            message = "Loading";
        } else if (this.state.mode == 'correct') {
            message = <span className={'correct'}>Correct!</span>;
            next_button = <button onClick={this.next} id={'next'}>Next</button>
        } else if (this.state.mode == 'incorrect') {
            message = <span className={'incorrect'}>Incorrect</span>;
            next_button = <button onClick={this.next} id={'next'}>Next</button>
        } else if (this.state.mode == 'waiting') {
            message = "Make your best guess"
        }
        if (this.state.mode == "correct" || this.state.mode == "incorrect") {
            right = <Datum className={'column'} image_path={this.state.prev_image_path}
                           species_id={this.state.species_id}></Datum>
        } else {
            right = <Zoom url={this.state.image_path}/>
        }
        return (
            <div className="species">
                <div className="spec-left">
                    <h2>{message}</h2>
                    <ul>{options_html}</ul>
                    {next_button}
                    <br/>
                </div>
                <div className="spec-right">
                    {right}
                </div>
            </div>
        )
    }
}

SpeciesPicker.propTypes = {
    options: PropTypes.array,
    image_path: PropTypes.string,
};

export default SpeciesPicker

/*
*
* */