import React from "react"
import PropTypes from "prop-types"


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
                    menu.style.minHeight = "100vh"
                }
            }.bind(this), 700);
        } else {
            menu.style.height = menu.clientHeight.toString() + "px";
            menu.style.minHeight = "unset";
            setTimeout(function() {
                menu.style.height = '0px';
            },45);
            this.setState({mode: ""});
        }
    }


    render() {
        return (
            <div id='menubutton'>
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

export default Menubutton
