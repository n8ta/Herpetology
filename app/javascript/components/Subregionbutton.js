import React from "react"
import PropTypes from "prop-types"
class Subregionbutton extends React.Component {

  constructor(props) {
    super(props);
    this.state = {mode: ""};
    this.toggle = this.toggle.bind(this)
  }

  toggle() {

    let sugregions = document.getElementById('subregions');
    let content = document.getElementById('content');

    if (this.state.mode == "") {
      this.setState({mode: "is-active"});
      sugregions.style.height = '100vh';
      setTimeout(function () {
        if (this.state.mode == "") {

        } else {
          content.style.display = "none";
          sugregions.style.height = 'auto';
          sugregions.style.minHeight = "100vh"
        }
      }.bind(this), 700);
    } else {
      content.style.display = "unset";
      sugregions.style.height = sugregions.clientHeight.toString() + "px";
      sugregions.style.minHeight = "unset";
      setTimeout(function() {
        sugregions.style.height = '0px';
      },45);
      this.setState({mode: ""});
    }
  }

  render () {
    let msg  ="";
    let active = "";
    if (this.state.mode == "is-active") {
      msg = "Hide Subregions"
      active = "active"
    } else {
      msg = "Show Subregions";
    }
    let chevron = <svg id='chevron' style={{enableBackground: 'new 0 0 512 512'}} version="1.1" viewBox="0 0 512 512" xmlSpace="preserve" xmlns="http://www.w3.org/2000/svg" xmlnsXlink="http://www.w3.org/1999/xlink"><path d="M298.3,256L298.3,256L298.3,256L131.1,81.9c-4.2-4.3-4.1-11.4,0.2-15.8l29.9-30.6c4.3-4.4,11.3-4.5,15.5-0.2l204.2,212.7  c2.2,2.2,3.2,5.2,3,8.1c0.1,3-0.9,5.9-3,8.1L176.7,476.8c-4.2,4.3-11.2,4.2-15.5-0.2L131.3,446c-4.3-4.4-4.4-11.5-0.2-15.8  L298.3,256z" /></svg>;
      return (
          <a href="#" onClick={this.toggle} className="subhead">{msg} <span className={active}> {chevron}</span></a>
      );


  }
}

export default Subregionbutton;
