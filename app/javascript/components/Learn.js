import React from "react"
import PropTypes from "prop-types"
import Zoom from "./Zoom";
import Name from "./Name";
import Speciesprogressbar from "./Speciesprogressbar";
import Info from "./Info";
import Signup from "./Signup";
import Tippy from "@tippy.js/react";
import Masteredlist from "./Masteredlist";
import Progressbar from "./Progressbar";

class Learn extends React.Component {


    reload() {
        for (let i = 0; i < this.props.taxons.length; i++) {
            window.localStorage.removeItem(this.props.region_id + '-' + this.props.taxons[i].id)
        }
        alert('a');
        location.reload();
    }

    preload(image_path) {
        let image = new Image();
        image.onload;
        image.src = image_path;
    }

    keydown(ev) {
        if (ev.key == " " || ev.key == "ArrowUp") {
            ev.preventDefault();
            this.new_question();
        }
        if (ev.key == "ArrowLeft") {
            this.answer(true)
        }
        if (ev.key == "ArrowRight") {
            this.answer(false)
        }
    }

    constructor(props) {

        super(props);

        window.addEventListener('keydown', this.keydown.bind(this));
        let txns = this.props.taxons;
        for (let i = 0; i < txns.length; i++) {
            txns[i].seen = 0;
            txns[i].correct = 0;
            txns[i].score = 0.0; // rolling average
            txns[i].photos = [];
        }

        this.state = {
            mode: "loading",
            complete_taxons: [],
            progress: 0,
            taxons: txns,
            num_taxons: this.props.taxons.length,
            loaded_taxons: 0,
            left_is_correct: undefined,
            left_class: '', // correct or incorrect
            right_class: '',
            incorrect_answer: undefined,
            current: this.props.taxons[0],
            correct: undefined,
            working_set: [],
            pending_set: [],
            mastered_set: [],
            mastered: false, // Last species was mastered
            done: false,
            questions_completed: 0,
        };
        let auth_token = document.querySelector("meta[name='csrf-token']").content;
        let photos = [];
        let num_loaded_taxons = 0;

        let pending_set = []; // Split txns in to these three arrays
        let working_set = [];
        let mastered_set = [];

        for (let i = 0; i < txns.length; i++) {
            let stored_txn = window.localStorage.getItem(this.props.region_id + '-' + txns[i].id);
            if (stored_txn != undefined) {
                stored_txn = JSON.parse(stored_txn);
                txns[i].score = stored_txn.score;
                txns[i].seen = stored_txn.seen;
                txns[i].correct = stored_txn.correct;
            }

            let num_preloaded = 0;

            fetch("/taxons/" + txns[i].id + "/photos/plenty", {
                method: 'GET',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json',
                    'X-CSRF-Token': auth_token,
                    'X-Requested-With': 'XMLHttpRequest',
                },
                credentials: 'same-origin',
            }).then(res => res.json()).then((result) => {
                // Setup photos
                for (let j = 0; j < result.length; j++) {
                    let url = result[j]['url'];
                    if (num_preloaded < 3) {
                        this.preload(url);
                        num_preloaded = num_preloaded + 1;
                    }

                    txns[i].photos.push(url);
                }
                // Check if we're done loading all taxons, if so setup working/mastered/and pending sets
                if ((this.props.taxons.length - (num_loaded_taxons + 1)) < 1) {
                    // Done loading taxons
                    for (let k = 0; k < txns.length; k++) {
                        if (txns[k].score >= this.props.mastery_cutoff_score) {
                            mastered_set.push(txns[k])
                        } else {
                            if (working_set.length < 6) {
                                working_set.push(txns[k])
                            } else {
                                pending_set.push(txns[k])
                            }
                        }
                    }
                    let current = working_set.pop();

                    if (working_set.length == 0) {
                        this.reload()
                    } else {


                        this.setState({
                            mode: "ready",
                            current: current,
                            pending_set: pending_set,
                            working_set: working_set,
                            mastered_set: mastered_set
                        }, function () {
                            this.new_question(true)
                        });

                    }
                }
                num_loaded_taxons = num_loaded_taxons + 1;
                this.setState({loaded_taxons: num_loaded_taxons});
            });

        }
        this.state.taxons = txns;

        this.render = this.render.bind(this);
        this.current = this.current.bind(this);
        this.new_question = this.new_question.bind(this);
        this.keydown = this.keydown.bind(this);
        this.reset_mastered = this.reset_mastered.bind(this);
    }

    current(which) {
        return this.state.current
    }

    cancel_signup() {
        this.setState({mode: "answered"}, this.new_question);
    }

    new_question(first_time) {
        if (this.state.mode == "loading" && !first_time) {
            return
        }


        if ((this.state.questions_completed == 5) && (!Cookies.get("asked_about_signup"))) {
            this.setState({mode: "signup"});
            Cookies.set("asked_about_signup", true, {expires: 1});
            return
        }


        let left_correct = Math.random() > .5;

        let place = Math.floor(Math.random() * this.state.working_set.length);

        let reordered = this.state.working_set;


        if (this.state.current.score >= this.props.mastery_cutoff_score) {
            // You just mastered the current one!
            if (this.state.pending_set.length > 0) {
                // Pop of the pending set and put it on the working set
                let pending_set = this.state.pending_set;
                let new_taxon = pending_set.pop();
                this.setState({pending_set: pending_set});
                reordered.push(new_taxon)
            } else {

                // Pending set is empty, we're done her!
                if (this.state.working_set.length == 0) {
                    ga('send', 'event', 'learn', 'done', 'true');
                    this.setState({done: true})
                }

            }
            // We've mastered add it to the mastered set
            let old_mastered = this.state.mastered_set;
            old_mastered.push(this.state.current);
            this.setState({mastered_set: old_mastered});
        } else {
            // It isn't mastered put it back in the working set
            reordered.splice(place, 0, this.state.current);
        }

        let correct_answer = reordered.pop();
        let incorrect_answer = this.state.taxons[Math.floor(Math.random() * this.state.taxons.length)];
        while (incorrect_answer.id == correct_answer.id) {
            incorrect_answer = this.state.taxons[Math.floor(Math.random() * this.state.taxons.length)];
        }
        let correct_photo = correct_answer.photos[Math.floor(Math.random() * correct_answer.photos.length)];
        let incorrect_photo = incorrect_answer.photos[Math.floor(Math.random() * incorrect_answer.photos.length)];
        this.setState({
            incorrect_answer: incorrect_answer,
            current: correct_answer,
            left_is_correct: left_correct,
            correct_photo: correct_photo,
            incorrect_photo: incorrect_photo,
            working_set: reordered,
            left_class: '',
            right_class: '',
            mode: 'ready',
            correct: undefined,
        })
    }


    answer(clicked_left) {
        if (this.state.mode == "answered") {
            return
        }

        // If they clicked left and left is correct, they got it right
        // If they click right and right is correct, they got it right
        // This looks more complex than it is
        let correct = ((this.state.left_is_correct && clicked_left) || (!this.state.left_is_correct && !clicked_left));

        ga('send', 'event', 'learn', 'answer', correct);

        let current = this.state.current;
        if (correct) {
            current.correct += 1;
            current.score = (current.score * this.props.factor) + (1.0 - this.props.factor);
        } else {
            current.score = current.score * this.props.factor;
        }
        current.seen += 1;
        window.localStorage.setItem(this.props.region_id + '-' + current.id, JSON.stringify({
            score: current.score,
            seen: current.seen,
            correct: current.correct,
            version: 1
        }));


        this.setState({
            correct: correct,
            current: current,
            mode: "answered", clicked_left: clicked_left,
            left_class: this.state.left_is_correct ? "correct" : "",
            right_class: this.state.left_is_correct ? "" : "correct",
            mastered: current.score >= this.props.mastery_cutoff_score,
            questions_completed: this.state.questions_completed + 1,

        });
    }

    reset_mastered = (taxon) => {

        let taxon_id = taxon.id;

        // Called to reset a taxon
        let mastered_set = this.state.mastered_set;
        let working_set = this.state.working_set;
        let pending_set = this.state.pending_set;
        for (let i = 0; i < mastered_set.length; i++) {
            let txn = mastered_set[i];
            if (txn.id == taxon_id) {
                let mastered = mastered_set.splice(i, 1);
                mastered = mastered[0];
                mastered.seen = 0;
                mastered.correct = 0;
                mastered.score = 0;
                window.localStorage.setItem(this.props.region_id + '-' + mastered.id, JSON.stringify({
                    score: 0,
                    seen: 0,
                    correct: 0,
                    version: 1
                }));
                if (working_set.size < 6) {
                    working_set.push(mastered);
                } else {
                    pending_set.push(mastered);
                }

            }
        }
        this.setState({mastered_set: mastered_set, working_set: working_set, pending_set: pending_set})
    };

    render() {
        if (this.state.mode == "signup") {
            return (
                <div>
                    <div>
                        <Signup return_url={window.location.href}></Signup>
                    </div>
                    <div className={'center'}>
                        <button onClick={this.cancel_signup.bind(this)}>No thanks!</button>
                    </div>
                </div>

            )
        } else if ((this.state.mode == "loading") && (this.state.done != true)) {
            return (<div id={'learn'}>
                <h3 className="center">Loading...</h3>
                <div className={'center'}>
                    <Progressbar wide={true} width={100 * this.state.loaded_taxons / this.state.num_taxons}
                                 msg={this.state.loaded_taxons + "/" + this.state.num_taxons}/>
                </div>
            </div>)
        } else {
            // Default to left correct, if it's not switch everything
            let msg = <span>Which of these is a<span
                className={'common_name'}> {this.current().common_name} </span>(<span
                className={'sci_name'}>{this.current().name}</span>)?<br/></span>;
            let next_button = "";
            let zoom_left = <Zoom url={this.state.correct_photo}/>;
            let zoom_right = <Zoom url={this.state.incorrect_photo}/>;
            let left_text = undefined;
            let right_text = undefined;
            let hide_arrows_class = "";
            if (!this.state.left_is_correct) {
                let tmp = zoom_left;
                zoom_left = zoom_right;
                zoom_right = tmp;
            }
            if (this.state.mode == "answered" || (this.state.mode == "answered")) {

                next_button = <div title='You can use the up arrow as well' className={"center"}>
                    <button onClick={this.new_question}>Next (▲) <br/></button>
                </div>;

                if (this.state.correct == true) {

                    if (this.state.mastered) {
                        if (this.state.done) {
                            return (
                                <div>
                                <span>🎉
                                    <span
                                        className={"font-heavy"}>You've just learned the {this.props.root_taxon_name} of {this.props.region_name}</span></span>
                                    <a href={window.location}>
                                        <div className={"center"}>
                                            <button onClick={this.reload} className={'main'}>Start over?<br/></button>
                                        </div>
                                    </a>
                                </div>
                            )
                        } else {
                            msg = <span>🎉 <span
                                className={"font-heavy"}>Mastered</span> 🎉 <br/>You just mastered the <Name
                                commonName={this.state.current.common_name}
                                sciName={this.state.current.name}></Name></span>;
                        }

                    } else {
                        msg = <span>✓ <span className={"font-heavy"}>Correct</span> ✓ <br/>the other was a <Name
                            commonName={this.state.incorrect_answer.common_name}
                            sciName={this.state.incorrect_answer.name}></Name></span>;
                    }
                    hide_arrows_class = "hidden";
                } else {
                    msg = <span>❌ <span className="font-heavy">Incorrect</span> ❌ <br/>that was a <Name
                        commonName={this.state.incorrect_answer.common_name}
                        sciName={this.state.incorrect_answer.name}></Name></span>;
                    hide_arrows_class = "hidden"
                }
            } else {
                left_text = "This one";
                right_text = "This one";
            }

            let progbars = this.state.working_set.concat(this.state.current);
            progbars = progbars.sort(function (a, b) {
                return a.id - b.id
            });

            progbars = progbars.map((taxon) =>
                <Speciesprogressbar
                    key={Math.random()} score={taxon.score * 1.334}
                    seen={taxon.seen} correct={taxon.correct}
                    sci_name={taxon.name} common_name={taxon.common_name}></Speciesprogressbar>
            );

            return (
                <div id={"learn"}>
                    <Masteredlist reset_func={this.reset_mastered.bind(this)}
                                  mastered={this.state.mastered_set}></Masteredlist>
                    <div className="center main_progbar_holder">
                        <Progressbar wide={true} width={100 * this.state.mastered_set.length / this.state.taxons.length}
                                     msg={"Overall Progress " + this.state.mastered_set.length + "/" + this.state.taxons.length}></Progressbar>
                    </div>
                    <div id='progbar_container' className={'center'}>
                        {progbars}
                        <Tippy content="These bars show your progress on the 6 species you are currently learning"
                               placement={'bottom'}>
                            <div><Info></Info></div>

                        </Tippy>

                    </div>

                    <div className={"text-center lead"}>
                        <div className={'lead_text'}>{msg}</div>
                    </div>
                    <div className={'center'}>
                        {next_button}
                    </div>


                    <div className={'two-col'}>

                        <div onClick={function () {
                            this.answer(true)
                        }.bind(this)}>
                            <div className={'center'}>
                                <button title={'Left arrow key'} disabled={this.state.mode == "answered"}
                                        className={hide_arrows_class + ' main ' + this.state.left_class}>
                                    <h4>{left_text}</h4>
                                </button>
                            </div>
                            {zoom_left}
                        </div>

                        <div onClick={function () {
                            this.answer(false)
                        }.bind(this)}>
                            <div className={'center'}>
                                <button title={'Right arrow keys'} disabled={this.state.mode == "answered"}
                                        className={hide_arrows_class + ' main ' + this.state.right_class}>
                                    <h4>{right_text}</h4>
                                </button>
                            </div>
                            {zoom_right}
                        </div>
                    </div>


                </div>)
        }
    }
}

Learn.propTypes = {
    taxons: PropTypes.array,
    working_size: PropTypes.number,
    factor: PropTypes.number,
    region_name: PropTypes.string,
    region_id: PropTypes.number,
    root_taxon_name: PropTypes.string,
    mastery_cutoff_score: PropTypes.number,
};


export default Learn
