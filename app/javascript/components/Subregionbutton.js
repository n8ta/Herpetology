import React from "react"
import PropTypes from "prop-types"
class Subregionbutton extends React.Component {

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



    let sugregions = document.getElementById('subregions');
    let body = document.querySelector('body');

    console.log(menu);
    if (this.state.mode == "") {
      this.setState({mode: "is-active"});
      sugregions.style.height = '100vh';
      body.style.overflowY = 'hidden';
      disableScroll();
    } else {
      this.setState({mode: ""});
      sugregions.style.height = '0px';
      body.style.overflowY = 'unset';
      enableScroll();
    }
  }

  render () {
    if (this.state.mode == "is-active") {
      return (
          <a href="#" onClick={this.toggle} className="subhead">Hide Subregions</a>
      );
    } else {
      return (
          <a href="#" onClick={this.toggle} className="subhead">Show Subregions</a>
      );
    }

  }
}

export default Subregionbutton;
