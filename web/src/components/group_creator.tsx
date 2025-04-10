import React, { useState, useEffect, useRef, useCallback } from "react";
import { fetchNui } from "../utils/fetchNui";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { debugData } from "../utils/debugData";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faTrash, faEdit, faPlus } from "@fortawesome/free-solid-svg-icons";
import groupStyle from "./Group_creator.module.scss";

import ShinyText from './Utils/ShinyText';
import GradientText from './Utils/GradientText'
debugData([
    {
      action: "showGroupCreator",
      data: {
        show: false,
        translation: {
          save: 'Save',
          create: 'Create a group',
          cancel: 'Cancel',
          add_grade: 'Add grade',
          description: 'Description',
          descriptionText: 'Enter a description of your group',
          color: 'Color',
          name: 'Name of group',
          nameText: 'Enter the name of your group',
          listgrade: 'Grade list'
        }
      },
    },
]);


const Group_creator = () => {
  const [groupName, setGroupName] = useState("");
  const [opened, setOpened] = useState(false);
  const [groupDescription, setGroupDescription] = useState("");
  const [groupColor, setGroupColor] = useState<any>("");
  const [grades, setGrades] = useState<string[]>(["Boss"]);
  const [isModalOpen, setIsModalOpen] = useState<boolean>(false);
  const [newGradeName, setNewGradeName] = useState<string>("");
  const [currentGradeIndex, setCurrentGradeIndex] = useState<number | null>(null);
  const [isAddGradeModalOpen, setIsAddGradeModalOpen] = useState<boolean>(false);
  const [Translation, setTranslation] = useState<any>({})
  
  useEffect(() => {
    const handleKeyDown = (event: any) => {
      if (event.key === "Escape" && opened) {
        fetchNui("crew:create:close");
      }
    };

    window.addEventListener("keydown", handleKeyDown);

    return () => {
      window.removeEventListener("keydown", handleKeyDown);
    };
  });

  const handleOpenAddGradeModal = () => {
    setNewGradeName("");
    setIsAddGradeModalOpen(true);
  };

  // Save New Grade
  const handleSaveNewGrade = () => {
    if (newGradeName.trim()) {
      setGrades((prevGrades) => [...prevGrades, newGradeName.trim()]);
      setIsAddGradeModalOpen(false);
    }
  };

  // Close Modals
  const handleModalClose = () => {
    setIsModalOpen(false);
    setIsAddGradeModalOpen(false);
    setCurrentGradeIndex(null);
    setNewGradeName("");
  };

  // Rename Existing Grade
  const handleRenameGrade = (index: number) => {
    setCurrentGradeIndex(index);
    setNewGradeName(grades[index]);
    setIsModalOpen(true);
  };

  // Save Renamed Grade
  const handleSaveGradeName = () => {
    if (currentGradeIndex !== null) {
      const updatedGrades = [...grades];
      updatedGrades[currentGradeIndex] = newGradeName;
      setGrades(updatedGrades);
      handleModalClose();
    }
  };

  // Delete Grade
  const handleDeleteGrade = (index: number) => {
    setGrades((prevGrades) => prevGrades.filter((_, i) => i !== index));
  };

  // Handle Form Submit
  const handleSubmit = () => {

    fetchNui("Group:Create", {name: groupName, color: groupColor, description: groupDescription, rank: grades});
  };
  useNuiEvent("showGroupCreator", (data) => {
    setTranslation(data.translation)
    setOpened(data.show)
  });

 
  return (opened && (
    <div>
      {isModalOpen && (
        <div className={groupStyle["modal-overlay"]}>
          <div className={groupStyle["modal-content"]}>
            <h2>Renommer le grade</h2>
            <input
              type="text"
              value={newGradeName}
              onChange={(e) => setNewGradeName(e.target.value)}
              className={groupStyle["modal-input"]}
            />
            <div className={groupStyle["modal-actions"]}>
              <button onClick={handleSaveGradeName} className={groupStyle["save-modal-btn"]}>
                {Translation.save}
              </button>
              <button onClick={handleModalClose} className={groupStyle["cancel-modal-btn"]}>
              {Translation.cancel}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Add Grade Modal */}
      {isAddGradeModalOpen && (
        <div className={groupStyle["modal-overlay"]}>
          <div className={groupStyle["modal-content"]}>
            <h2>{Translation.add_grade}</h2>
            <input
              type="text"
              value={newGradeName}
              onChange={(e) => setNewGradeName(e.target.value)}
              className={groupStyle["modal-input"]}
            />
            <div className={groupStyle["modal-actions"]}>
              <button onClick={handleSaveNewGrade} className={groupStyle["save-modal-btn"]}>
              {Translation.save}
              </button>
              <button onClick={handleModalClose} className={groupStyle["cancel-modal-btn"]}>
              {Translation.cancel}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Main Form */}
      <div className={groupStyle["container"]}>
        <div className={groupStyle["menu"]}>
          <ShinyText text={Translation.create} disabled={false} speed={3} className={groupStyle["menu-title"]} />
          <form className={groupStyle["form"]} onSubmit={(e) => e.preventDefault()}>
            {/* Group Name */}
            <div className={groupStyle["form-group"]}>
              <label htmlFor="groupName">{Translation.name}</label>
              <input
                type="text"
                id="groupName"
                placeholder={Translation.nameText}
                value={groupName}
                onChange={(e) => setGroupName(e.target.value)}
                required
              />
            </div>

            {/* Group Color */}
            <div className={groupStyle["form-group"]}>
              <label htmlFor="groupColor">{Translation.color}</label>
              <input
                type="color"
                id="groupColor"
                value={groupColor}
                onChange={(e) => setGroupColor(e.target.value)}
                required
              />
            </div>

            {/* Group Description */}
            <div className={groupStyle["form-group"]}>
              <label htmlFor="groupDescription">{Translation.description}</label>
              <input
                type="text"
                id="groupDescription"
                placeholder={Translation.descriptionText}
                value={groupDescription}
                onChange={(e) => setGroupDescription(e.target.value)}
                required
              />
            </div>


            <div className={`${groupStyle["form-group"]} ${groupStyle["grades-section"]}`}>
              <div className={groupStyle["grades-header"]}>
                <label>{Translation.listgrade}</label>
                <button
                  type="button"
                  className={groupStyle["add-grade-btn"]}
                  onClick={handleOpenAddGradeModal}
                >
                  <FontAwesomeIcon icon={faPlus} /> {Translation.add_grade}
                </button>
              </div>
              <div className={groupStyle["grades-list"]}>
                {grades.map((grade, index) => (
                  <div key={index} className={groupStyle["grade-item"]}>
                    <span className={groupStyle["grade-name"]}>{grade}</span>
                    <div className={groupStyle["grade-actions"]}>
                      <button
                        className={groupStyle["edit-btn"]}
                        onClick={() => handleRenameGrade(index)}
                      >
                        <FontAwesomeIcon icon={faEdit} />
                      </button>
                      {index !== 0 && (
                        <button
                          className={groupStyle["delete-btn"]}
                          onClick={() => handleDeleteGrade(index)}
                        >
                          <FontAwesomeIcon icon={faTrash} />
                        </button>
                      )}
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {/* Submit Button */}
            <button className={groupStyle["submit-button"]} onClick={handleSubmit}>
            {Translation.save}
            </button>
          </form>
        </div>
      </div>
    </div>
  ));
};
export default Group_creator;
