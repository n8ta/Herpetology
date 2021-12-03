import React from "react";
import Venomreport from "./Venomreport";

const VenomPlusImage = React.memo(({url, photo_id, venomous}) => {
    let venom = "";


    if (venomous === "venomous") {
        venom = <div className='poison_icon'>Venomous</div>
    } else if (venomous === "nonvenomous") {
        venom = <div className='poison_icon'>Nonvenomous</div>
    } else if (venomous === "unknown") {
        venom =
            (
                <div className='poison_icon'>
                    <Venomreport photo_id={photo_id}></Venomreport>
                </div>
            )
    }

    return (
        <div className={'image_outer'}>
            {venom}
            <img alt='Photo of an unknown herp' src={url}/>
        </div>
    )
});
VenomPlusImage.displayName = "Image";

export default VenomPlusImage;