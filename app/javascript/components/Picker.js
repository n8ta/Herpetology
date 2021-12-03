import PropTypes from "prop-types";
import React, {useEffect, useCallback, useState} from "react";
import Zoom from "./Zoom";
import Signup from "./Signup";
import Reportsinmodal from "./reports/Reportsinmodal";
import {jsonFetch} from "./fetch";

function preload(image_path) {
    let image = new Image();
    image.onload;
    image.src = image_path;
}

const Modes = {
    WAITING: 'waiting',
    LOADING: 'loading',
    ANSWERED: 'answered',
    SIGNUP: 'signup',
}
const Types = {
    SCI: 'sci',
    COM: 'common'
}

const Title = React.memo(({selected, mode, name, correct}) => {
    let title = `${name} ☐ `
    if (selected !== null) {
        title = `${name} ☑`
    }
    if (mode === Modes.ANSWERED) {
        title = <span className={"incorrect"}>{name} ✗</span>;
        if (correct) {
            title = <span className={"correct"}>{name} ✓</span>;
        }
    }
    return <h4>{title}</h4>
});

const Options = React.memo(({mode, selected, options, correctIdx, type, handleClick}) => {
    let disabled = (mode === Modes.ANSWERED || mode === Modes.LOADING || selected !== null) ? "disabled" : ""
    let output_list = [];
    for (let i = 0; i < options.length; i++) {
        let index = i;
        let btn_class = "";
        let mark = "";
        if (mode === Modes.ANSWERED) {
            if (index === correctIdx) {
                btn_class = "correct";
                mark = "✓";
            } else if (index === selected) {
                btn_class = "incorrect";
                mark = "✗";
            }
        } else {
            if (index === selected) {
                btn_class = "guess"
            }
        }
        output_list.push(
            <li key={i} className={btn_class}>
                <button className={'special'} disabled={disabled}
                        onClick={() => handleClick(type, i)}>
                    <span className="common_name">{options[i]} {mark}</span>
                </button>
            </li>);
    }
    return (<ol>{output_list}</ol>)
});

const Picker = ({options, image_path, photo_id, region_id}) => {
    const [taxon, setTaxon] = useState(null);
    const [mode, setMode] = useState(Modes.WAITING)
    const [photo, setPhoto] = useState(photo_id);
    const [imagePath, setImagePath] = useState(image_path);
    const [nextImagePath, setNextImagePath] = useState(null);
    const [venomous, setVenomous] = useState(null)
    const [opts, setOpts] = useState({[Types.SCI]: options["sci"], [Types.COM]: options["common"]});
    const [nextOptions, setNextOptions] = useState({[Types.SCI]: [], [Types.COM]: []});
    const [nextPhotoId, setNextPhotoId] = useState(null);

    const [correct, setCorrect] = useState({[Types.SCI]: null, [Types.COM]: null});
    const [selected, setSelected] = useState({[Types.SCI]: null, [Types.COM]: null});
    const [correctIdx, setCorrectIdx] = useState({[Types.SCI]: null, [Types.COM]: null});

    const [name, setName] = useState(null); // name.com name.sci
    const [asked, setAsked] = useState(true);

    const [iterations, setIterations] = useState(0);

    const next = useCallback(() => {
        if (asked === false && iterations === 6) {
            setMode(Modes.SIGNUP);
            setAsked(true);
            Cookies.set("asked_about_signup", true, {expires: 1})
        } else {
            setTaxon(null);
            setName(null);
            setMode(Modes.WAITING);
            setOpts(nextOptions);
            setImagePath(nextImagePath);
            setNextOptions(null);
            setNextImagePath(null);
            setCorrect({[Types.SCI]: null, [Types.COM]: null});
            setSelected({[Types.SCI]: null, [Types.COM]: null});
            setVenomous(null);
            setIterations(old => old + 1);
            setPhoto(nextPhotoId);
        }

    }, [Modes, opts, nextOptions, nextImagePath])

    useEffect(() => {
        let asked_about_signup = Cookies.get("asked_about_signup");
        setAsked(asked_about_signup !== undefined)
        Cookies.set("asked_about_signup");
    })

    const handleClick = useCallback((type, index) => {
        setSelected((old) => {
            return {[Types.SCI]: old[Types.SCI], [Types.COM]: old[Types.COM], [type]: index}
        })
    }, [setSelected]);

    useEffect(() => {
        let num_selected = (selected[Types.SCI] !== null ? 1 : 0) + (selected[Types.COM] !== null ? 1 : 0);
        if (num_selected === 2) {
            setMode(Modes.LOADING);
            const data = {
                'common_guess': selected[Types.COM],
                'sci_guess': selected[Types.SCI],
            };
            jsonFetch('POST', window.location, (result) => {
                setTaxon(result.taxon);
                setName({[Types.COM]: result.taxon.common_name, [Types.SCI]: result.taxon.name})
                setNextOptions(result['next_options']);
                setNextImagePath(result['next_image_path']);
                setCorrectIdx({[Types.SCI]: result['correct_sci_index'], [Types.COM]: result['correct_common_index']})
                setMode(Modes.ANSWERED);
                console.info("result", result)
                setCorrect({[Types.SCI]: result['sci_correct'], [Types.COM]: result['common_correct']});
                setVenomous(result['venomous']);
                setNextPhotoId(result['next_photo_id']);
                preload(result['next_image_path']);
            }, data)
        }
    }, [selected, setMode])

    if (mode === Modes.SIGNUP) {
        return (
            <div>

                <Signup return_url={window.location}/>
                <div className={"center"}>
                    <button className={'main badpath'} onClick={this.next}>No Thanks <br/></button>
                </div>
            </div>
        )
    }
    let left = null;
    let right = null;
    if (mode === Modes.WAITING || mode === Modes.ANSWERED) {
        left = <Options mode={mode} handleClick={handleClick} selected={selected[Types.SCI]} options={opts[Types.SCI]}
                        correctIdx={correctIdx[Types.SCI]} type={Types.SCI}/>
        right = <Options mode={mode} handleClick={handleClick} selected={selected[Types.COM]} options={opts[Types.COM]}
                         correctIdx={correctIdx[Types.COM]} type={Types.COM}/>
    }


    console.info("correct", correct);
    return (
        <div className="species">
            <span className={'instructions center'}>Pick the scientific and common names that match the photo</span>
            <Zoom photo_id={photo} url={imagePath} venomous={venomous}/>
            <div className={['two-col', mode].join(' ')}>
                <div>
                    <Title name={"Scientific"} selected={selected[Types.SCI]} mode={mode} correct={correct[Types.SCI]}/>
                    {left}
                </div>
                <div>
                    <Title name={"Common"} selected={selected[Types.COM]} mode={mode} correct={correct[Types.COM]}/>
                    {right}
                </div>
                {taxon &&
                <Reportsinmodal
                    photo_id={photo}
                    taxon_id={taxon?.id}
                    region_id={region_id}
                    taxon_com={name?.com}
                    taxon_sci={name?.sci}
                ></Reportsinmodal>}
                {mode === Modes.ANSWERED &&
                <div id={'next'} className={"center"}>
                    <button className={'main happypath'} onClick={next}>Next <br/></button>
                </div>
                }

            </div>
        </div>
    )
}

export default Picker;