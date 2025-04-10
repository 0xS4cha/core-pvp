import React, { useState, useRef, useEffect } from "react";
import { fetchNui } from "../utils/fetchNui";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { debugData } from "../utils/debugData";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faUnlock, faArrowLeft } from "@fortawesome/free-solid-svg-icons";
import pinStyle from "./Pin.module.scss";
import useSfx from "../hooks/useSfx";

/*
debugData([
  {
    action: "showPin",
    data: true,
  },
]);*/ 

const Pin = () => {
  const { playSfx } = useSfx();
  const sfxEnabled = useRef<boolean>(true);
  const [props, setProps] = useState<any[any]>([]);
  const [pin, setPin] = useState<string>("");
  const [correctInput, setCorrectInput] = useState<boolean | null>(null);
  const [opened, setOpened] = useState(false);

    useEffect(() => {
      const handleMessage = (event: MessageEvent) => {
        const data = event.data;
        if (data.action === "showPin") {
          console.log("showPin");
          setOpened(data.data);
        }
      };
      window.addEventListener("message", handleMessage);
  
      return () => {
        window.removeEventListener("message", handleMessage);
      };
    });

  useEffect(() => {
      const handleKeyDown = (event: any) => {
        if (event.key === "Escape" && props.canClose && opened) {
          handleClosePin(false);
        } else if (event.key === "Enter" && opened) {
          handleClosePin(true);
        } else {
          handleKeyPress(event.key);
        }
      };

      window.addEventListener("keydown", handleKeyDown);

      return () => {
        window.removeEventListener("keydown", handleKeyDown);
      };
    
  });

  const handleKeyPress = (key: string) => {
    
    setPin((prevPin) => {
      if (key === "Backspace") {
        const newPin = prevPin.slice(0, -1);
        const format = newPin.length > 0 ? newPin : "";
        setCorrectInput(null);
        return format;
      } else if (key >= "0" && key <= "9") {
       
        const newPin = prevPin + key;
        setCorrectInput(null);
        return newPin.length <= props.maxNumbers ? newPin : prevPin;
      } else {
        return prevPin;
      }
    });
  };

  const handleClosePin = (unlockBtn: boolean) => {
    
    let close: boolean = true;
    
    const reactive = props.reactiveUI
    const correctPin = reactive ? reactive.correctPin : null

    
    setPin((currentPin) => {
      const num = currentPin.trim() !== "" ? parseInt(currentPin, 10) : null;

      
      if (correctPin && correctPin !== num) {
        if (sfxEnabled.current) playSfx("error");
        setCorrectInput(false);
      } else if (correctPin && correctPin === num) {
        if (sfxEnabled.current) playSfx("success");
        setCorrectInput(true);
      } else {
        if (sfxEnabled.current) playSfx("switch");
      }
  
      if (reactive && !reactive.closeOnWrong && correctPin && correctPin !== num && unlockBtn) {
        close = false;
      }
  
      if (close) {
    
        setTimeout(() => {
          fetchNui("pinClosed", num);
        }, 300);
      }

      return currentPin;
    });

  };

  useNuiEvent("openPin", (data) => {
    sfxEnabled.current = data.useSfx;
    setPin("");
    setProps(data);
    setCorrectInput(null);
  });

  useNuiEvent("closePin", () => handleClosePin(false));

  return (opened && (
  <div className={pinStyle["container"]}>
    <div className={pinStyle["wrapper"]}>
      {(props.title || props["subtitle"]) && (
        <div className={pinStyle["header"]}>
          {props.title && <span className={pinStyle.title}>{props.title}</span>}
          {props.subtitle && (
            <span className={pinStyle.subtitle}>{props.subtitle}</span>
          )}
        </div>
      )}

      <div
        className={`${pinStyle.pinDisplay} ${
          correctInput === false
            ? pinStyle.incorrect
            : correctInput === true
            ? pinStyle.correct
            : pin
            ? pinStyle.default
            : pinStyle.grayBorder
        }`}
      >
        {pin && (
          <span
            className={`${pinStyle.pinText} ${
              correctInput === false
                ? pinStyle.textIncorrect
                : correctInput === true
                ? pinStyle.textCorrect
                : pinStyle.textDefault
            }`}
          >
            {!props.hidden ? pin : "*".repeat(pin.length)}
          </span>
        )}
      </div>

      <div className={pinStyle.keypad}>
        {Array.from({ length: 12 }, (_, index) => {
          const num = index === 10 ? 0 : index + 1;

          return (
            <div
              key={index}
              className={`${pinStyle.key} ${
                num === 10
                  ? pinStyle.backKey
                  : num === 12
                  ? pinStyle.enterKey
                  : pinStyle.numKey
              }`}
              onClick={() =>
                num !== 10 && num !== 12
                  ? handleKeyPress(num.toString())
                  : num === 10
                  ? handleKeyPress("Backspace")
                  : handleClosePin(true)
              }
            >
              {num !== 10 && num !== 12 ? (
                num
              ) : num === 10 ? (
                <FontAwesomeIcon icon={faArrowLeft} />
              ) : (
                <FontAwesomeIcon icon={faUnlock} />
              )}
            </div>
          );
        })}
      </div>
    </div>
    </div>
    
  ));
};
  
export default Pin;