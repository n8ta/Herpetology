import React from "react"
import SubmitTip from "./SubmitTip";

export default class Submittipinmodal extends React.Component {

    constructor(props) {
        super(props);
        this.activate = this.activate.bind(this);
        this.deactivate = this.deactivate.bind(this);
        this.state = {active: false}
    }

    activate() {
        this.setState({active: true});
        let content = <SubmitTip {...this.props}/>;
        window.modal.set_content_and_callback(content, this.deactivate);
        window.modal.show();
    }

    deactivate() {
        this.setState({active: false});
        window.modal.set_content_and_callback("", this.deactivate);
    }

    render() {
        if (this.props.taxon) {
            return (
                <div className="center">
                    <button className={this.props.small ? "small" : ""  }onClick={this.activate.bind(this)}> + Submit Tip +</button>
                </div>
            )
        } else {
            return("")
        }

    }
}

