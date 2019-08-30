import React from "react"
import PropTypes from "prop-types"
import SpeciesPicker from "./SpeciesPicker";
import Zoom from "./Zoom";

class Learn extends React.Component {

    preload(image_path) {
        let image = new Image();
        image.onload;
        image.src = image_path;
    }


    constructor(props) {
        super(props);
        this.state = {
            mode: "Loading",
            progress: 0,
            taxons: this.props.taxons,
            num_taxons: this.props.taxons.length,
            loaded_taxons: 0
        };
        let taxons = this.props.taxons;
        let auth_token = document.querySelector("meta[name='csrf-token']").content;
        for (let i = 0; i < taxons.length; i++) {
            fetch("/taxons/" + taxons[i].id + "/photos/plenty", {
                method: 'GET',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json',
                    'X-CSRF-Token': auth_token,
                    'X-Requested-With': 'XMLHttpRequest',
                },
                credentials: 'same-origin',
            }).then(res => res.json()).then((result) => {
                this.setState({loaded_taxons: this.state.loaded_taxons + 1});
                for (let j = 0; j < result.length; j++) {
                    let url = result[j]['url'];
                    this.preload(url);
                    (this.state.taxons[i].photos = this.state.taxons[i].photos || []).push(url); // Create and push to array, how bout that syntax
                }
            });
        }
        this.render = this.render.bind(this);


    }


    render() {
        if (this.props.taxons.length - this.state.loaded_taxons > 1) {
            return (
                <div>
                    <h3 className="center">Loading...</h3>
                    <div className={'center'}>
                        <progress max={1.0} value={this.state.loaded_taxons / this.state.num_taxons}></progress>
                    </div>
                </div>
            )
        } else {
            return (
                <div id={"learn"}>
                    <h3 className={"center"}>So which is which?</h3>
                    <ul>
                        <li></li>
                    </ul>

                    <div className={'two-col'}>

                        <div>
                            <Zoom url={this.state.taxons[0].photos[0]}/>
                        </div>

                        <div>
                            <Zoom url={this.state.taxons[1].photos[0]}/>
                        </div>
                    </div>


                </div>
            )
        }
    }
}

SpeciesPicker.propTypes = {
    taxons: PropTypes.array,
};


export default Learn
