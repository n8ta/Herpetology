import React from "react"
import PropTypes from "prop-types"


class Menubutton extends React.Component {
    constructor(props) {
        super(props);
        this.state = {mode: ""};
        this.toggle = this.toggle.bind(this)
    }

    toggle() {

        function disableScroll() {
            if (window.addEventListener) // older FF
                window.addEventListener('DOMMouseScroll', preventDefault, false);
            document.addEventListener('wheel', preventDefault, {passive: false}); // Disable scrolling in Chrome
            window.onwheel = preventDefault; // modern standard
            window.onmousewheel = document.onmousewheel = preventDefault; // older browsers, IE
            window.ontouchmove  = preventDefault; // mobile
            document.onkeydown  = preventDefaultForScrollKeys;
        }

        function enableScroll() {
            if (window.removeEventListener)
                window.removeEventListener('DOMMouseScroll', preventDefault, false);
            document.removeEventListener('wheel', preventDefault, {passive: false}); // Enable scrolling in Chrome
            window.onmousewheel = document.onmousewheel = null;
            window.onwheel = null;
            window.ontouchmove = null;
            document.onkeydown = null;
        }



        let menu = document.getElementById('menu');
        let body = document.querySelector('body');

        if (this.state.mode == "") {
            this.setState({mode: "is-active"});
            menu.style.height = '100vh';
            body.style.overflowY = 'hidden';
            disableScroll();
        } else {
            this.setState({mode: ""});
            menu.style.height = '0px';
            body.style.overflowY = 'unset';
            enableScroll();
        }
    }


    render() {
        return (
            <div id='menubutton'>
            <button onClick={this.toggle} className={["special","hamburger","hamburger--vortex",this.state.mode].join(" ")}  type="button">
                <span className="hamburger-box">
                    <span className="hamburger-inner"></span>
                </span>
            </button>
            </div>
        );
    }
}

export default Menubutton
