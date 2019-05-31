import React from "react"
import PropTypes from "prop-types"

class Zoom extends React.Component {
    constructor(props) {
        super(props);
        this.mouseMove = this.mouseMove.bind(this);
        this.mouseLeave = this.mouseLeave.bind(this);
        this.state = {mode: 'waiting'}
    }
    mouseMove(e) {
        let cont = document.getElementById('zoom_container');
        let pageX = e.clientX-cont.getBoundingClientRect().left;
        let pageY = e.clientY-cont.getBoundingClientRect().top;
        let lhs = pageX + 'px ';
        let rhs = pageY + 'px';
        let origin = lhs + rhs;
        console.log('origin', origin);
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
        return (
            <React.Fragment>
                <div id={'zoom_container'} onMouseLeave={this.mouseLeave} onMouseMove={this.mouseMove}>
                    <div id={'zoom'} style={style}>
                        <img id={'zoom_image'}
                            src={this.props.url}/>
                    </div>
                </div>
            </React.Fragment>
        );
    }
}
Zoom.propTypes = {
    url: PropTypes.string
};
export default Zoom
