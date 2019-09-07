import React from "react"
import PropTypes from "prop-types"
import Report from "../Report";
import Alert from "../Alert";

class Badregionreport extends React.Component {
  constructor(props) {
    super(props);
    let auth_token = document.querySelector("meta[name='csrf-token']").content;
    this.state = {csrf: auth_token, submitted: false};
    this.post = this.post.bind(this)
  }


  post() {
    if (this.props.taxon_id == undefined) {return}

    this.setState({submitted: true});
    let auth_token = document.querySelector("meta[name='csrf-token']").content;
    let no_flash = "";
    if (this.props.no_flash == true) {
      no_flash = "&no_flash=true"
    }
    fetch("/reports?type=BadRegionReport&taxon_id="+this.props.taxon_id+"&region_id="+this.props.region_id+no_flash, {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'X-CSRF-Token': auth_token,
        'X-Requested-With': 'XMLHttpRequest',
      },
      credentials: 'same-origin',

    }).then(res => res.json()).then((result) => {
      this.props.after_report()
    });





  }


  render() {

    if (this.state.submitted == false) {
      return (
          <div className="center">
            <button disabled={this.props.disabled} onClick={this.post} className={'small'}><Alert/>Not found in this region</button>
          </div>
      );
    } else {
      return (
          <div className="center">
            <button className={'small submitted'}>Submitted Report, thanks!</button>
          </div>
      );
    }

  }
}

export default Badregionreport

Badregionreport.propTypes = {
  taxon_id: PropTypes.number,
  region_id: PropTypes.number,
  disabled: PropTypes.bool,
  after_report: PropTypes.func,
};
