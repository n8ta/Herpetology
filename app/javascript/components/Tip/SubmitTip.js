import React from "react"
import PropTypes from "prop-types"
import Name from "../Name"

export default class SubmitTip extends React.Component {

    constructor() {
        super();
        this.state = {lower_text: "", button_text: "Submit", mode: "ready", valid: false, dots: 0}; // "ready" "waiting" (waiting for network) "submitted" "approved" "failed"
        this.content = React.createRef();
    }

    handle_click(e) {
        e.preventDefault();
        let mode = this.state.mode;
        if (mode == "approved" || mode == "failed" || mode == "submitted") {
            window.modal.hide();
        }
        if (mode != "ready")
            return;

        this.setState({mode: "waiting", button_text: "Submitting"});
        setInterval(() => this.setState({dots: this.state.dots + 1}), 1000);

        let auth_token = document.querySelector("meta[name='csrf-token']").content;
        console.debug("Posting:", this.content.current.value, this.props.taxon.id, auth_token);
        fetch('/tips', {
            method: 'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
                'X-CSRF-Token': auth_token,
                'X-Requested-With': 'XMLHttpRequest',
            },
            credentials: 'same-origin',
            body:
                JSON.stringify({
                    tip: {content: this.content.current.value},
                    taxon_id: parseInt(this.props.taxon.id)
                })


        }).then(res => res.json()).then((result) => {
            console.debug("RECV: ", result);
            if (result.approved == true) {
                this.setState({mode: "approved",lower_text: "Thank you, your tip has been automatically approved."})
            } else {
                this.setState({mode: "submitted",lower_text: "Thank you! Your tip is pending approval."})
            }
        }).catch((res) => {
            this.setState({mode: "failed", lower_text: "Error submitting, please copy your tip and reload."});
        }).finally((res) => {
            this.setState({button_text: "✗ Close ✗"})
        })


    }

    check_valid = () => {
        this.setState({valid: this.content.current.value.length > 45});
    };

    dots(num_dots) {
        let dots = "";
        num_dots = num_dots % 5;
        for (let i = 0; i < num_dots; i++) {
            dots = dots.concat(".")
        }
        return dots;
    };


    render() {

        let button_text = this.state.button_text;
        if (this.state.mode == "waiting") {
            button_text=button_text.concat(this.dots(this.state.dots))
        }

        return (
            <div>
                <form id={"submit_tip"}>

                    <p>Your tip for identifying the <span className={'space'}></span> <Name
                        commonName={this.props.taxon.common_name} sciName={this.props.taxon.name}/></p>
                    <div className={'text_area_holder'}>
                        <textarea onKeyDown={this.check_valid} placeholder={"Enter your tip here"}
                                  ref={this.content}></textarea>
                    </div>

                    <div className={'center'}>
                        <button disabled={(!this.state.valid) && this.state.mode == "ready"}
                                onClick={(e) => this.handle_click(e)}>{button_text} </button>
                    </div>
                    <br/>
                    <div className={'center'}>
                        {this.state.lower_text}
                    </div>
                </form>
            </div>
        )
    }
}

SubmitTip.propTypes = {
    taxon: PropTypes.object,
};
