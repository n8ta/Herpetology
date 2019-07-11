import React from "react"
import Zoom from './Zoom.js';
import PropTypes from "prop-types"

class Handlereport extends React.Component {
    constructor(props) {
        super(props);
        this.state = {mode: '',confirmied: false};
        this.approve = this.approve.bind(this);
        this.approved_confirmed = this.approved_confirmed.bind(this);
        this.reject = this.reject.bind(this);
        this.rejected_confirmed = this.rejected_confirmed.bind(this);
    }

    approve() {
        if (this.state.mode == "") {
            this.setState({mode: 'approved'})
            this.post(this.props.approveUrl,this.approved_confirmed)
        }  else {
            alert("Already handled")
        }

    }
    reject() {
        if (this.state.mode == "") {
            this.setState({mode: 'rejected'})
            this.post(this.props.rejectUrl,this.rejected_confirmed)
        } else {
            alert("Already handled")

        }
    }

    approved_confirmed() {
        this.setState({confirmed: true}) // Call back after network request
    }
    rejected_confirmed() {
        this.setState({confirmed: true}) // Call back after network request
    }

    post(url) {
        let auth_token = document.querySelector("meta[name='csrf-token']").content;
        fetch(url, {
            method: 'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
                'X-CSRF-Token': auth_token,
                'X-Requested-With': 'XMLHttpRequest',
            },
            credentials: 'same-origin',

        }).then(res => res.json()).then((result) => {
            console.log(result);
            this.setState({msg: result['msg']});
        })
    }



    render() {
        let msg = "";
        let user = "";
        let approve_class = "";
        let reject_class = "";
        let disabled = 'false'
        if (this.state.mode == "approved" ) {
            if (this.state.confirmed == true) {
                approve_class = "confirmed"
            } else {
                approve_class = "active";
            }
            reject_class = "disabled";
            disabled = 'true' ;
        } else if (this.state.mode == "rejected") {
            if (this.state.confirmed == true) {
                reject_class = "confirmed"
            } else {
                reject_class = "active";
            }
            approve_class ="disabled";
            disabled = 'true';

        }


        if (this.props.userId) {
            user = <React.Fragment><strong>Created by: </strong> {this.props.userUsername}, {this.props.userSciAcc}% Sci, {this.props.userComAcc}% Com, {this.props.userTotal} Total IDs </React.Fragment>
        } else {
            user = <React.Fragment><strong>Created by:</strong> a user without an account</React.Fragment>
        }

        if (this.props.venomous) {
            msg = <React.Fragment><strong>{this.props.currentTaxonCommon} -- {this.props.currentTaxonSci}</strong><br/> should be marked as: {this.props.venomous}</React.Fragment>
        } else if (this.props.newTaxonCommon && this.props.newTaxonSci) {
            msg = <React.Fragment> <strong>Currently:</strong><br/> {this.props.currentTaxonCommon} -- {this.props.currentTaxonSci}<br/>
                <strong>Reported as:</strong><br/>{this.props.newTaxonCommon} -- {this.props.newTaxonSci}</React.Fragment>
        } else if (this.props.noHerp) {
            msg = <strong>Photo has no herp</strong>
        } else if (this.props.deadHerp) {
            msg = <strong>Photo contains a dead herp</strong>
        } else {
            alert("Messed up report, please contact the dev, https://github.com/n8ta/HerpID")
        }
        return (
            <div className="report">
                <Zoom url={this.props.photoUrl} no_text={true}/>
                <div>
                    <p>{msg}</p>
                    <p>{user}</p>
                    <div className={'buttons'}>
                    <svg className={approve_class} aria-disabled={disabled} onClick={this.approve}  role="button" title="Approve Report" viewBox="0 0 32 32" xmlns="http://www.w3.org/2000/svg"><g id="Accept"><path d="M16,4A12,12,0,1,0,28,16,12.0137,12.0137,0,0,0,16,4Zm5.207,9.707-6.8154,6.8155L10.7,15.6a1,1,0,1,1,1.6-1.2l2.3086,3.0776L19.793,12.293a1,1,0,0,1,1.414,1.414Z" /></g></svg>
                    <svg className={reject_class} aria-disabled={disabled} onClick={this.reject}  role="button" title="Reject Report" viewBox="0 0 32 32" xmlns="http://www.w3.org/2000/svg"><g><path d="M16,4A12,12,0,1,0,28,16,12.0134,12.0134,0,0,0,16,4Zm4.707,15.293a1,1,0,1,1-1.414,1.414L16,17.4141,12.707,20.707a1,1,0,0,1-1.414-1.414L14.5859,16,11.293,12.707a1,1,0,0,1,1.414-1.414L16,14.5859l3.293-3.2929a1,1,0,0,1,1.414,1.414L17.4141,16Z" /></g></svg>
                    </div>
                </div>



            </div>
        );
    }
}

Handlereport.propTypes = {
    reportId: PropTypes.number,
    photoUrl: PropTypes.node,
    venomous: PropTypes.string, // reporter says this is the correct status for venom
    currentTaxonCommon: PropTypes.string, // current taxon in the photo
    currentTaxonSci: PropTypes.string,
    newTaxonCommon: PropTypes.string, // reporter believes this is the correct id
    newTaxonSci: PropTypes.string,
    noHerp: PropTypes.bool, // photo has no herp
    userId: PropTypes.number, // reporter_id
    userUsername: PropTypes.string, // reporter_username
    userTotal: PropTypes.number,
    userSciAcc: PropTypes.number,
    userComAcc: PropTypes.number,
    approveUrl: PropTypes.string,
    rejectUrl: PropTypes.string,
    deadHerp: PropTypes.bool,
};
export default Handlereport
