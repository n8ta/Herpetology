import React from "react"
import PropTypes from "prop-types"

class Zoom extends React.Component {
    constructor(props) {
        super(props);
        this.mouseMove = this.mouseMove.bind(this);
        this.mouseLeave = this.mouseLeave.bind(this);
        this.state = {
            mode: 'waiting',
            id: btoa(Math.random().toString(36)) // ~Random id
        }
    }

    mouseMove(e) {
        let cont = document.getElementById('zoom_container_'+this.state.id);
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
        return (
            <React.Fragment>
                <div className={'zoom_container'} id={'zoom_container_'+this.state.id} onMouseLeave={this.mouseLeave} onMouseMove={this.mouseMove}>
                    <div className={'zoom'} id={'zoom_'+this.state.id} style={style}>
                        <img className={'zoom_image'} id={'zoom_image_'+this.state.id}
                             src={this.props.url}/>
                    </div>
                </div>
            </React.Fragment>
        );
    }
}

Zoom.propTypes = {
    url: PropTypes.string,
    dead: PropTypes.bool
};
export default Zoom
