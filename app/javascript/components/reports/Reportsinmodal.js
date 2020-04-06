import React from "react"
import Alert from "../svgs/Alert";
import Reportmanager from "./Reportmanager";

export default class Reportsinmodal extends React.Component {

    constructor(props) {
        super(props);
        this.activate = this.activate.bind(this);
        this.deactivate = this.deactivate.bind(this);
        this.state = {active: false}
    }

    activate() {
        this.setState({active: true});
        let content = <Reportmanager {...this.props}/>;
        window.modal.set_content_and_callback(content,this.deactivate);
        window.modal.show();
    }

    deactivate() {
        console.debug("Done!");
        window.modal.set_content_and_callback("",this.deactivate);
        this.setState({active: false});
    }

    render() {
        return(
        <div className="center">
            <button onClick={this.activate.bind(this)} className={'small'}><Alert/>Report an issue</button>
        </div>
        )
    }
}

