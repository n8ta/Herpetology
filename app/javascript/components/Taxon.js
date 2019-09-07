import React from "react"
import PropTypes from "prop-types"
import Name from "./Name";
import Check from "./svgs/Check";
import Eye from "./svgs/Eye";
import Masteredlist from "./Masteredlist";

class Taxon extends React.Component {
  render () {
    let taxon = this.props.taxon;
    return (
        <li key={taxon.id}>
          <img src={taxon.photos[0].url}/>
          <div>
            <div>
              <Name commonName={taxon.common_name} sciName={taxon.name}/>
            </div>
            <div>
              {taxon.correct} <Check/> /{taxon.seen} <Eye/>
            </div>
            <div>
              <button onClick={() => this.props.reset_func(taxon)}>Reset this species</button>
            </div>
          </div>
        </li>
    );
  }
}


Taxon.propTypes = {
  taxon: PropTypes.object,
  reset_func: PropTypes.func,
};


export default Taxon
