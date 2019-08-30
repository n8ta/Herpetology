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
            loaded_taxons: 0,
            left_is_correct: Math.random() > .5,
            left_class: '', // correct or incorrect
            right_class: '',
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
                    // Create and push to array, how bout that syntax
                    (this.state.taxons[i].photos = this.state.taxons[i].photos || []).push(url);
                }
            });
        }
        this.render = this.render.bind(this);
        this.current = this.current.bind(this);

    }

    // Current correct taxon TODO: non dummy
    current(which) {
        return this.state.taxons[0]
    }

    // Grab a random taxon
    rand() {
        let trial = this.state.taxons[Math.floor(Math.random() * this.state.taxons.length)];
        while (trial.id == this.current().id) {
            trial = this.state.taxons[Math.floor(Math.random() * this.state.taxons.length)];
        }
        return trial;
    }


    answer(clicked_left) {
        this.setState({
                left_class: this.state.left_is_correct ? "correct" : "incorrect",
                right_class: this.state.left_is_correct ? "incorrect" : "correct"
            }
        );
    }


    render() {
        if (this.props.taxons.length - this.state.loaded_taxons > 1) {
            return (<div>
                <h3 className="center">Loading...</h3>
                <div className={'center'}>
                    <progress max={1.0} value={this.state.loaded_taxons / this.state.num_taxons}></progress>
                </div>
            </div>)
        } else {
            let zoom_left = <Zoom
                url={this.current().photos[Math.floor(Math.random() * this.current().photos.length)]}/>;
            let rand = this.rand();
            let zoom_right = <Zoom url={rand.photos[Math.floor(Math.random() * rand.photos.length)]}/>;
            if (!this.state.left_is_correct) {
                let tmp = zoom_left;
                zoom_left = zoom_right;
                zoom_right = tmp;
            }

            return (<div id={"learn"}>
                <p className={"text-center lead"}>
                    Which of these photos is a
                    <span className={'common_name'}> {this.current().common_name} </span>
                    (<span className={'sci_name'}>{this.current().name}</span>)
                </p>

                <div className={'two-col'}>

                    <div>
                        <div className={'center'}>
                            <button onClick={function () {
                                this.answer(true)
                            }.bind(this)} className={'main ' + this.state.left_class}><h4>This one!</h4></button>
                        </div>
                        {zoom_left}
                    </div>

                    <div>
                        <div className={'center'}>
                            <button onClick={function () {
                                this.answer(false)
                            }.bind(this)} className={'main ' + this.state.right_class}><h4>This one!</h4></button>
                        </div>
                        {zoom_right}
                    </div>
                </div>


            </div>)
        }
    }
}

SpeciesPicker.propTypes = {
    taxons: PropTypes.array,
};


export default Learn
