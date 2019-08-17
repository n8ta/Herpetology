import React from "react"
import PropTypes from "prop-types"
import SpeciesPicker from "./SpeciesPicker";


class Menubutton extends React.Component {
    constructor(props) {
        super(props);
        this.state = {mode: ""};
        this.toggle = this.toggle.bind(this)
    }

    toggle() {

        let menu = document.getElementById('menu');
        let content = document.getElementById('content');

        if (this.state.mode == "") {
            this.setState({mode: "is-active"});
            menu.style.height = '100vh';
            setTimeout(function () {
                if (this.state.mode == "") {

                } else {
                    menu.style.height = 'auto';
                    menu.style.minHeight = "100vh";
                    content.style.display = "none";
                }
            }.bind(this), 700);
        } else {
            content.style.display = "unset";
            menu.style.height = menu.clientHeight.toString() + "px";
            menu.style.minHeight = "unset";
            setTimeout(function() {
                menu.style.height = '0px';
            },45);
            this.setState({mode: ""});
        }
    }


    render() {
        let cls = "";
        if (this.props.alert == true) {
            cls = "active"
        }
        return (
            <div id='menubutton'>
                <div id='menubutton-alert' className={cls}></div>
                <button onClick={this.toggle}
                        className={["special", "hamburger", "hamburger--vortex", this.state.mode].join(" ")}
                        type="button">
                <span className="hamburger-box">
                    <span className="hamburger-inner"></span>
                </span>
                </button>
            </div>

        );
    }
}

SpeciesPicker.propTypes = {
    alert: PropTypes.bool,

};

export default Menubutton
