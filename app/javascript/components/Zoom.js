import React from "react"
import Venomreport from './Venomreport.js';
import PropTypes from "prop-types"

class Zoom extends React.Component {
    constructor(props) {
        super(props);
        this.mouseMove = this.mouseMove.bind(this);
        this.mouseLeave = this.mouseLeave.bind(this);
        this.state = {
            mode: 'waiting',
            id: btoa(Math.random().toString(36)), // ~Random id so we can have two on the same page
        };
        this.ComponentDidUpdate = this.ComponentDidUpdate.bind(this);

    }

    ComponentDidUpdate() {
        this.render()
    }

    mouseMove(e) {
        let cont = document.getElementById('zoom_container_' + this.state.id);
        let pageX = e.clientX - cont.getBoundingClientRect().left;
        let pageY = e.clientY - cont.getBoundingClientRect().top;
        let origin = pageX + 'px ' + pageY + 'px';
        this.setState({
            mode: 'live',
            origin: origin
        });
    }

    mouseLeave() {
        this.state.mode = 'waiting'
    }

    render() {
        let style = {
            backgroundImage: "url('" + this.props.url + "')",
        };
        if (this.state && this.state.mode == 'live') {
            style = {
                backgroundImage: "url('" + this.props.url + "')",
                transformOrigin: this.state.origin,
            };
        }
        let venomous = "";
        if (this.props.no_text == true) {

        } else {
            if (this.props.venomous == "venomous") {
                venomous = <div id='poison_icon'>Venomous</div>
            } else if (this.props.venomous == "nonvenomous") {
                venomous = <div id='poison_icon'>Nonvenomous</div>
            } else if (this.props.venomous == "unknown") {
                venomous = <div id='poison_icon'>We don't know if it's venomous<Venomreport photo_id={this.props.photo_id}></Venomreport></div>
            }
        }

        return (
            <React.Fragment>
                <div className={'zoom_outer'}>
                    {venomous}
                    <div className={'zoom_inner'} id={'zoom_container_' + this.state.id} onMouseLeave={this.mouseLeave}
                         onMouseMove={this.mouseMove}>
                        <div className={'zoom'} id={'zoom_' + this.state.id} style={style}>
                            <img alt='Photo of an unknown reptile or amphibean' className={'zoom_image'} id={'zoom_image_' + this.state.id}
                                 src={this.props.url}/>

                        </div>
                    </div>
                </div>
            </React.Fragment>
        );
    }
}

Zoom.propTypes = {
    url: PropTypes.string,
    photo_id: PropTypes.number,
    venomous: PropTypes.string,
    no_text: PropTypes.bool,
};
export default Zoom
