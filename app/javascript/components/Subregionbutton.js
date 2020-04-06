import React from "react"
import Chevron from "./Chevron";

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
      msg = this.props.hide_msg;
      active = "active"
    } else {
      msg = this.props.show_msg;
    }
      return (
          <a href="#" onClick={this.toggle} className="dropdown_link">{msg} <span className={active}> <Chevron></Chevron></span></a>
      );


  }
}

export default Subregionbutton;
