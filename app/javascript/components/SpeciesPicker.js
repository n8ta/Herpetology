import React from "react"
import Zoom from './Zoom.js';
import Report from './Report.js';
import Signup from './Signup.js';
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
            num_chosen: 0,
            sci_chosen: undefined,
            common_chosen: undefined,
            asked_about_signup: undefined,
            iterations: 0,
            venmous: undefined,
        };
        this.handleClick = this.handleClick.bind(this);
        this.handleReport = this.handleReport.bind(this);
        this.next = this.next.bind(this);

        console.log(Cookies.get("asked_about_signup"));
        let asked_about_signup = Cookies.get("asked_about_signup");
        if (asked_about_signup == undefined) {
            this.state.asked_about_signup = false;
        } else {
            this.state.asked_about_signup = true;
        }
        Cookies.get("asked_about_signup");


    }

    gen_options() {
        let options = {'sci': [], 'common': []};
        let sci_disabled = this.state.mode == 'answered' || this.state.mode == "loading" || this.state.sci_chosen != undefined ? "disabled" : ""
        let common_disabled = this.state.mode == 'answered' || this.state.mode == "loading" || this.state.common_chosen != undefined ? "disabled" : ""
        for (let i = 0; i < this.state.options['sci'].length; i++) {
            let tmp = i;
            let sci_btn_class = "";
            let common_btn_class = "";

            if (this.state.mode == "answered") {
                if (tmp == this.state.sci_correct_index) {
                    sci_btn_class = "correct"
                } else if (tmp == this.state.sci_chosen) {
                    sci_btn_class = "incorrect"
                } else {
                }
                if (tmp == this.state.common_correct_index) {
                    common_btn_class = "correct"
                } else if (tmp == this.state.common_chosen) {
                    common_btn_class = "incorrect"
                } else {
                }

            } else {

                if (tmp == this.state.sci_chosen) {
                    sci_btn_class = "guess"
                }
                if (tmp == this.state.common_chosen) {
                    common_btn_class = "guess"
                }
            }


            options['sci'].push(
                <li key={i} className={sci_btn_class}>
                    <button disabled={sci_disabled} data-type={'sci'} data-index={i}
                            onClick={this.handleClick}>
                        <span className="common_name">{this.state.options['sci'][i]}</span>
                    </button>
                </li>);

            options['common'].push(
                <li key={i} className={common_btn_class}>
                    <button disabled={common_disabled} data-type={'common'} data-index={i}
                            onClick={this.handleClick}>
                        <span className="sci_name">{this.state.options['common'][i]}</span>
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

    next() {

        if (this.state.asked_about_signup == false && this.state.iterations == 6) {
            this.setState({mode: "signup", asked_about_signup: true});
            // Cookies.set("asked_about_signup",true,{expires: 1})
        } else {
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
                sci_chosen: undefined,
                common_chosen: undefined,
                message: undefined,
                num_chosen: 0,
                venomous: undefined,
                iterations: this.state.iterations + 1,
            });
        }

    }

    handleReport() {
        this.setState({mode: 'report'})
    }

    handleClick(e) {

        let index = e.currentTarget.dataset.index;
        let type = e.currentTarget.dataset.type;
        if (type == 'sci') {
            this.setState({sci_chosen: index});
        } else if (type == 'common') {
            this.setState({common_chosen: index});
        }

        if (this.state.num_chosen == 1) {
            this.setState({mode: "loading", num_chosen: 1});
        } else {
            this.state.num_chosen += 1;
            return
        }


        let auth_token = document.querySelector("meta[name='csrf-token']").content;
        this.setState({mode: 'loading'});
        let data = {
            'common_guess': this.state.common_chosen || index, // SetState is async so we may not have it in the state yet, so if it's undefined use the index
            'sci_guess': this.state.sci_chosen || index,
        };
        fetch(window.location, {
            method: 'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
                'X-CSRF-Token': auth_token,
                'X-Requested-With': 'XMLHttpRequest',
            },
            body: JSON.stringify(
                data),
            credentials: 'same-origin',

        }).then(res => res.json()).then((result) => {
            this.setState({
                common_name: result['common_name'],
                sci_name: result['sci_name'],
                next_options: result['next_options'],
                next_image_path: result['next_image_path'],
                species_id: result['species_id'],
                prev_image_path: this.state.image_path,
                sci_correct_index: result['correct_sci_index'],
                common_correct_index: result['correct_common_index'],
                mode: 'answered',
                sci_correct: result['sci_correct'],
                common_correct: result['common_correct'],
                venomous: result['venomous'],
                photo_id: result['photo_id'],
            });
            this.preload(result['next_image_path']);
        })
    };

    render() {
        let options = this.gen_options();
        let sci_options = options['sci'];
        let common_options = options['common'];
        let next_button = '';
        let left = '';
        let right = '';
        let form = '';
        let left_title = "Scientific";
        let right_title = "Common";
        let report = '';
        let zoom = <Zoom url={this.state.image_path} venomous={this.state.venomous}/>
        if (this.state.mode == 'answered') {
            next_button = <div id={'next'} className={"center"}>
                <button className={'main happypath'} onClick={this.next}>Next <br/></button>
            </div>;
            left = sci_options;
            right = common_options;
            left_title = <span className={"incorrect"}>Scientific ✗</span>;
            right_title = <span className={"incorrect"}> Common ✗</span>;
            if (this.state.sci_correct) {
                left_title = <span className={"correct"}>Scientific ✓</span>;
            }
            if (this.state.common_correct) {
                right_title = <span className={"correct"}> Common ✓</span>;
            }
            report = <div onClick={this.handleReport} className={'center'}><a href={'#'}
                                                                              className={'main'}>Contribute a Correction</a></div>
        } else if (this.state.mode == 'waiting') {
            left = sci_options;
            right = common_options;
        } else if (this.state.mode == "signup") {
            return (
                <div>

                    <Signup/>
                    <div id={'next'} className={"center"}>
                        <button className={'main badpath'} onClick={this.next}>No Thanks <br/></button>
                    </div>
                </div>
            )
        } else if (this.state.mode == "report") {
            return (
                <div className="center">
                    <div>
                        <h2>New Report</h2>
                        <Report photo_id={this.state.photo_id}
                                url={this.state.image_path}
                                venomous={this.state.venomous}></Report>
                    </div>
                </div>
            )
        }
        return (
            <div className="species">
                {zoom}
                {form}
                <div className={['two-col', this.state.mode].join(' ')}>
                    <div>
                        <h4>{left_title}</h4>
                        {left}
                    </div>
                    <div>
                        <h4>{right_title}</h4>
                        {right}
                    </div>


                </div>
                {report}

                {next_button}

                <br/>

            </div>
        )
    }
}

SpeciesPicker.propTypes = {
    options: PropTypes.object,
    image_path: PropTypes.string,
};

export default SpeciesPicker

/*
*
* */