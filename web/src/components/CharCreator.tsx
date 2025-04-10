import { useEffect, useState } from "react";

import { useNuiEvent } from "../hooks/useNuiEvent";
import { fetchNui } from "../utils/fetchNui";
import "./CharCreator.scss";

import Identity from "./CharCreator/Identity";
import Heritage from "./CharCreator/Heritage";
import Appareance from "./CharCreator/Appareance";
import Clothes from "./CharCreator/Clothes";
import Face from "./CharCreator/Face";
import DiseaseComponent from "./CharCreator/Disease";

import parents from "../parents";
import translation from "../translation";
type ParentType = "dad" | "mom";



const CONFIG = {
    logo: "https://sacha-dev.fr/ldo_logo.PNG",
  appareance: {
    beard_1: {
      ranges: [
        {
          type: "beard_2",
          title: translation["appearance"]["opacity"],
          value: 0,
          min: 0,
          max: 10,
        },
      ],
      palettes: [
        { type: "beard_3", title: translation["appearance"]["primary_color"] },
        {
          type: "beard_4",
          title: translation["appearance"]["secondary_color"],
        },
      ],
      value: 0,
      min: 0,
      max: 0,
    },
    eyebrows_1: {
      ranges: [
        {
          type: "eyebrows_2",
          title: translation["appearance"]["opacity"],
          value: 0,
          min: 0,
          max: 10,
        },
        {
          type: "eyebrows_5",
          title: translation["appearance"]["height"],
          value: -10,
          min: -10,
          max: 10,
        },
      ],
      palettes: [
        {
          type: "eyebrows_3",
          title: translation["appearance"]["primary_color"],
        },
        {
          type: "eyebrows_4",
          title: translation["appearance"]["secondary_color"],
        },
      ],
      value: 0,
      min: 0,
      max: 0,
    },
    makeup_1: {
      ranges: [
        {
          type: "makeup_2",
          title: translation["appearance"]["opacity"],
          value: 0,
          min: 0,
          max: 10,
        },
      ],
      palettes: [
        { type: "makeup_3", title: translation["appearance"]["primary_color"] },
        {
          type: "makeup_4",
          title: translation["appearance"]["secondary_color"],
        },
      ],
      value: 0,
      min: 0,
      max: 0,
    },
    hair_1: {
      ranges: [],
      palettes: [
        {
          type: "hair_color_1",
          title: translation["appearance"]["primary_color"],
        },
        {
          type: "hair_color_2",
          title: translation["appearance"]["secondary_color"],
        },
      ],
      value: 0,
      min: 0,
      max: 0,
    },
  },
  clothes: {
    pants_1: {
      value: 0,
      min: 0,
      max: 15,
    },
    arms: {
      value: 0,
      min: 0,
      max: 15,
    },
    tshirt_1: {
      value: 0,
      min: 0,
      max: 15,
    },
    torso_1: {
      value: 0,
      min: 0,
      max: 15,
    },
    shoes_1: {
      value: 0,
      min: 0,
      max: 15,
    },
    pants_2: {
      value: 0,
      min: 0,
      max: 15,
    },
    arms_2: {
      value: 0,
      min: 0,
      max: 15,
    },
    tshirt_2: {
      value: 0,
      min: 0,
      max: 15,
    },
    torso_2: {
      value: 0,
      min: 0,
      max: 15,
    },
    shoes_2: {
      value: 0,
      min: 0,
      max: 15,
    },
  },
  face: {
    nose: {
      ranges: [
        {
          type: "nose_1",
          title: translation["face"]["nose_width"],
          value: -10,
          min: -10,
          max: 10,
        },
        {
          type: "nose_2",
          title: translation["face"]["nose_height"],
          value: -10,
          min: -10,
          max: 10,
        },
        {
          type: "nose_3",
          title: translation["face"]["nose_tip_length"],
          value: -10,
          min: -10,
          max: 10,
        },
        {
          type: "nose_4",
          title: translation["face"]["nose_bridge_depth"],
          value: -10,
          min: -10,
          max: 10,
        },
        {
          type: "nose_5",
          title: translation["face"]["height_of_the_tip"],
          value: -10,
          min: -10,
          max: 10,
        },
        {
          type: "nose_6",
          title: translation["face"]["broken_nose"],
          value: -10,
          min: -10,
          max: 10,
        },
      ],
      palettes: [],
    },
    chin: {
      ranges: [
        {
          type: "chin_1",
          title: translation["face"]["chin_height"],
          value: -10,
          min: -10,
          max: 10,
        },
        {
          type: "chin_2",
          title: translation["face"]["chin_length"],
          value: -10,
          min: -10,
          max: 10,
        },
        {
          type: "chin_3",
          title: translation["face"]["chin_width"],
          value: -10,
          min: -10,
          max: 10,
        },
        {
          type: "chin_4",
          title: translation["face"]["chin_hole_size"],
          value: -10,
          min: -10,
          max: 10,
        },
      ],
      palettes: [],
    },
    jaw: {
      ranges: [
        {
          type: "jaw_1",
          title: translation["face"]["jaw_width"],
          value: -10,
          min: -10,
          max: 10,
        },
        {
          type: "jaw_2",
          title: translation["face"]["jaw_height"],
          value: -10,
          min: -10,
          max: 10,
        },
        {
          type: "neck_thickness",
          title: translation["face"]["neck_thickness"],
          value: -10,
          min: -10,
          max: 10,
        },
      ],
      palettes: [],
    },
    cheeks: {
      ranges: [
        {
          type: "cheeks_1",
          title: translation["face"]["cheekbone_height"],
          value: -10,
          min: -10,
          max: 10,
        },
        {
          type: "cheeks_2",
          title: translation["face"]["cheekbone_width"],
          value: -10,
          min: -10,
          max: 10,
        },
        {
          type: "cheeks_3",
          title: translation["face"]["cheek_width"],
          value: -10,
          min: -10,
          max: 10,
        },
      ],
      palettes: [],
    },
    eyes: {
      ranges: [
        {
          type: "eye_squint",
          title: translation["face"]["eye_width"],
          value: -10,
          min: -10,
          max: 10,
        },
        {
          type: "eye_color",
          title: translation["face"]["eye_color"],
          value: 0,
          min: 0,
          max: 31,
        },
      ],
      palettes: [],
    },
  },
};

function Charcreator() {
  const [visible, setVisible] = useState(false);
  useNuiEvent("setVisibleCharCreator", (data: { visible?: boolean }) => {
    setVisible(data.visible || false);
  });

  const updateConfig = (config: any, data: any) => {
    const newConfig = { ...config };
  
    for (const key in data) {
      const { value, min, max } = data[key];      

        for (const appearanceKey in newConfig.appearance) {
          const appearanceItem = newConfig.appearance[appearanceKey];
          if (!appearanceItem) continue; 
  
          const rangeItem = appearanceItem.ranges?.find(
            (range: any) => range.type === key
          );
          if (rangeItem) {
            rangeItem.value = value;
            rangeItem.min = min;
            rangeItem.max = max;
          }
  
          const paletteItem = appearanceItem.palettes?.find(
            (palette: any) => palette.type === key
          );
          if (paletteItem) {
            paletteItem.value = value;
          }
        }
  
      if (newConfig.clothes[key]) {
        newConfig.clothes[key].value = value;
        newConfig.clothes[key].min = min;
        newConfig.clothes[key].max = max;
      }
  
      for (const faceKey in newConfig.face) {
        const faceItem = newConfig.face[faceKey];
  
        if (!faceItem) continue; 
  
        const faceRangeItem = faceItem.ranges?.find(
          (range: any) => range.type === key
        );
        if (faceRangeItem) {
          faceRangeItem.value = value;
          faceRangeItem.min = min;
          faceRangeItem.max = max;
        }
      }
    }

    const appearanceKeys = ["beard_1", "eyebrows_1", "makeup_1", "hair_1"];

    appearanceKeys.forEach(key => {
      if (data[key]) { 
        const { value, min, max } = data[key];
        if (newConfig.appareance[key]) {
          newConfig.appareance[key].value = value;
          newConfig.appareance[key].min = min;
          newConfig.appareance[key].max = max;
        }
      }
    });    
    console.log(newConfig, CONFIG);
    return newConfig;
  };

  const [selectedComponent, setSelectedComponent] =
    useState<string>("Heritage");
  const [identityData, setIdentityData] = useState({
    sexe: "male",
    lastname: "",
    firstname: "",
    nationality: "",
    birthdate: "",
  });

  const [heritageData, setHeritageData] = useState({
    selectedChoice: "dad" as ParentType,
    selectedParents: parents["dad"],
    selectedParentsItem: { dad: parents["dad"][0], mom: parents["mom"][0] },
  });

  const [appearanceData, setAppearanceData] = useState({
    selectedType: "hair_1",
    ranges: {
      beard_2: 0,
      eyebrows_2: 0,
      eyebrows_5: -10,
      makeup_2: 0,
    },
    palettes: {
      beard_3: 0,
      beard_4: 0,
      eyebrows_3: 0,
      eyebrows_4: 0,
      makeup_3: 0,
      makeup_4: 0,
      hair_color_1: 0,
      hair_color_2: 0,
    },
  });

  const [clothesData, setClothesData] = useState({
    selectedType: "pants_1",
    selectedTexture: 10,
  });

  const [faceData, setFaceData] = useState({
    selectedType: "nose",
    ranges: {
      nose_1: -10,
      nose_2: -10,
      nose_3: -10,
      nose_4: -10,
      nose_5: -10,
      nose_6: -10,
      chin_1: -10,
      chin_2: -10,
      chin_3: -10,
      chin_4: -10,
      jaw_1: -10,
      jaw_2: -10,
      neck_thickness: -10,
      cheeks_1: -10,
      cheeks_2: -10,
      cheeks_3: -10,
      eye_squint: -10,
      eye_color: 0,
    },
    palettes: {},
  });

  const [diseaseData, setDiseaseData] = useState({
    specificity: "",
    disease: "",
    allergies: "",
    addictions: "",
    selectedOption: "A",
  });

  useNuiEvent("setDatasCharCreator", (data: any) => {
    const updatedConfig = updateConfig(CONFIG, data.data);
    CONFIG['logo'] = data.logo;
    
    setIdentityData((prevData: any) => {
      const resetData: any = {};
      for (let key in prevData) {
        if (key === "sexe") {
          resetData[key] = "male";
        } else {
          resetData[key] = "";
        }
      }
      return resetData;
    });

    setDiseaseData((prevData: any) => {
      const resetData: any = {};
      for (let key in prevData) {
        if (key === "selectedOption") {
          resetData[key] = "A";
        } else {
          resetData[key] = "";
        }
      }
      return resetData;
    });
  });

  const isIdentityFinished = () => {
    return (
      identityData.lastname.length > 2,
      identityData.firstname.length > 2,
      identityData.nationality.length > 2,
      identityData.birthdate.length === 10
    )
  }

  const handleActions = (action: string) => {    
    if (action === "reset") fetchNui("reset", translation.notification.reset)
    if (action === "save") {
      fetchNui("save", {
        diseaseData: diseaseData,
        identityData: identityData
      })
    } else {
      fetchNui("notif", translation.notification.cant_finish)
    }
  }

  const handleHeritageChoiceChange = (selectedType: ParentType) => {
    const currentSelected = heritageData.selectedParentsItem[selectedType];
    setHeritageData((prev) => ({
      ...prev,
      selectedChoice: selectedType,
      selectedParents: parents[selectedType].map((parent: any) =>
        parent.id === currentSelected.id
          ? { ...parent, selected: true }
          : { ...parent, selected: false }
      ),
    }));
  };

  const handleParentChange = (item: any) => {
    setHeritageData((prev) => ({
      ...prev,
      selectedParentsItem: {
        ...prev.selectedParentsItem,
        [item.type]: item,
      },
      selectedParents: prev.selectedParents.map((parent) =>
        parent.id === item.id
          ? { ...parent, selected: true }
          : { ...parent, selected: false }
      ),
    }));

    fetchNui("change", {
      type: item.type,
      new: parseInt(item.id),
    });
  };

  const handleIdentityChange = (field: string, value: any) => {
    setIdentityData((prev) => ({
      ...prev,
      [field]: value,
    }));
  };

  const handleAppearanceChange = (
    type: string,
    value: any,
    category: "ranges" | "palettes" | null
  ) => {
    fetchNui("change", {
      type: type,
      new: parseInt(value),
    });

    if (category === null) {
      setAppearanceData((prev) => ({
        ...prev,
        [type]: value,
      }));

      return;
    }

    if (category) {
      setAppearanceData((prev) => ({
        ...prev,
        [category]: {
          ...prev[category],
          [type]: value,
        },
      }));

      return;
    }
  };

  const handleClothesChange = (type: string) => {
    setClothesData((prev) => ({
      ...prev,
      selectedType: type,
      selectedTexture: type === "arms" ? 15 : 10,
    }));
  };

  const handleFaceChange = (
    type: string,
    value: any,
    category: "ranges" | "palettes" | null
  ) => {
    if (category === null) {
      setFaceData((prev) => ({
        ...prev,
        [type]: value,
      }));

      return;
    }

    if (category) {
      setFaceData((prev) => ({
        ...prev,
        [category]: {
          ...prev[category],
          [type]: value,
        },
      }));

      fetchNui("change", {
        type: type,
        new: parseInt(value)
      })

      return;
    }
  };

  const handleDiseaseChange = (field: string, value: any) => {
    setDiseaseData((prev) => ({
      ...prev,
      [field]: value,
    }));
  };

  const renderSelectedComponent = () => {
    switch (selectedComponent) {
      case "Identity":
        return <Identity data={identityData} onChange={handleIdentityChange} />;
      case "Heritage":
        return (
          <Heritage
            selectedChoice={heritageData.selectedChoice}
            selectedParents={heritageData.selectedParents}
            selectedParentsItem={heritageData.selectedParentsItem}
            //@ts-ignore
            handleChoiceChange={handleHeritageChoiceChange}
            onChangeParent={handleParentChange}
          />
        );
      case "Appareance":
        return (
          <Appareance
            data={appearanceData}
            onChange={handleAppearanceChange}
            CONFIG={CONFIG["appareance"]}
          />
        );
      case "Clothes":
        return (
          <Clothes
            data={clothesData}
            onChange={handleClothesChange}
            CONFIG={CONFIG["clothes"]}
          />
        );
      case "Face":
        return (
          <Face
            data={faceData}
            onChange={handleFaceChange}
            CONFIG={CONFIG["face"]}
          />
        );
      default:
        return (
          <DiseaseComponent data={diseaseData} onChange={handleDiseaseChange} />
        );
    }
  };

  return (
    <>
      {visible && (
        <div className="creator">
          <div className="left__side">
            <div className="server__logo">
              <img src={CONFIG['logo']} alt="" />
            </div>
            <div className="sidebar__container">
              <div className="sidebar__content">
                <div className="sidebar__items">

                  <div
                    className={`item ${
                      selectedComponent === "Heritage" ? "selected" : ""
                    }`}
                    onClick={() => {
                      setSelectedComponent("Heritage"),
                        fetchNui("change_camera", { type: "Heritage" });
                    }}
                  >
                    <img src="../assets/images/CharCreator/heritage.svg" alt="heritage" />
                    {translation["category"]["parents"]}
                  </div>
                  <div
                    className={`item ${
                      selectedComponent === "Appareance" ? "selected" : ""
                    }`}
                    onClick={() => {
                      setSelectedComponent("Appareance"),
                        fetchNui("change_camera", { type: "Appareance" });
                    }}
                  >
                    <img
                      src="../assets/images/CharCreator/appearance.svg"
                      alt="appearance"
                      style={{ width: "45px" }}
                    />
                    {translation["category"]["appearance"]}
                  </div>

                  <div
                    className={`item ${
                      selectedComponent === "Face" ? "selected" : ""
                    }`}
                    onClick={() => {
                      setSelectedComponent("Face"),
                        fetchNui("change_camera", { type: "Face" });
                    }}
                  >
                    <img
                      src="../assets/images/CharCreator/face.svg"
                      alt="face"
                      style={{ width: "45px" }}
                    />
                    {translation["category"]["face"]}
                  </div>

                </div>
                <div className="sidebar__actions">
                  <div className="aitem red" onClick={() => handleActions("reset")}>
                    <img src="../assets/images/CharCreator/ban-solid.svg" alt="ban" />
                    {translation["actions"]["reset"]}
                  </div>
                  <div className="aitem green" onClick={() => handleActions("save")}>
                    <img src="../assets/images/CharCreator/check-solid.svg" alt="check" />
                    {translation["actions"]["save"]}
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div className="right__side">
            <div className="right__side_content">
              {renderSelectedComponent()}
            </div>
          </div>
        </div>
      )}
    </>
  );
}

export default Charcreator;