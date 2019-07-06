import React from "react"
import PropTypes from "prop-types"
class Subregionbutton extends React.Component {

  constructor(props) {
    super(props);
    this.state = {mode: ""};
    this.toggle = this.toggle.bind(this)
  }

  toggle() {
    //
    // function disableScroll() {
    //   try {if (window.addEventListener) { FFwindow.addEventListener('DOMMouseScroll', preventDefault, false);} }catch(err) {}
    //   try {document.addEventListener('wheel', preventDefault, {passive: false})}catch(err){}; // Disable scrolling in Chrome} catch(err) {};
    //   try {window.onwheel = preventDefault }catch(err){};
    //   try {window.onmousewheel = document.onmousewheel = preventDefault } catch(err) {};
    //   try {window.ontouchmove  = preventDefault } catch(err) {};
    //   try {document.onkeydown  = preventDefaultForScrollKeys } catch(err) {};
    // }
    //
    // function enableScroll() {
    //   try {window.removeEventListener('DOMMouseScroll', preventDefault, false)} catch(err){};
    //   try {document.removeEventListener('wheel', preventDefault, {passive: false});}catch(err){};
    //   try {window.onmousewheel = document.onmousewheel = null;} catch(err){}
    //   try {window.onwheel = null;} catch(err){};
    //   try {window.ontouchmove = null;} catch(err){};
    //   try {document.onkeydown = null;} catch(err){};
    // }





    let sugregions = document.getElementById('subregions');
    let content = document.getElementById('content');

    if (this.state.mode == "") {
      this.setState({mode: "is-active"});
      sugregions.style.height = '100vh';
      setTimeout(function () {
        if (this.state.mode == "") {

        } else {
          sugregions.style.height = 'auto';
          sugregions.style.minHeight = "100vh"
        }
      }.bind(this), 700);
    } else {
      sugregions.style.height = sugregions.clientHeight.toString() + "px";
      sugregions.style.minHeight = "unset";
      setTimeout(function() {
        sugregions.style.height = '0px';
      },45);
      this.setState({mode: ""});
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
