import React, { useState, useEffect, useRef, useCallback } from "react";
import { fetchNui } from "../utils/fetchNui";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { debugData } from "../utils/debugData";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faTrash, faEdit, faPlus } from "@fortawesome/free-solid-svg-icons";
import groupStyle from "./Group_creator.module.scss";

/*
debugData([
    {
      action: "showGroupCreator",
      data: true,
    },
]);*/


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

  // Open Add Grade Modal
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

  useEffect(() => {
    const handleMessage = (event: MessageEvent) => {
      const data = event.data;
      if (data.action === "showGroupCreator") {
        console.log("showGroupCreator");
        setOpened(data.data);
      }
      
  } 
  window.addEventListener("message", handleMessage);

  return () => {
    window.removeEventListener("message", handleMessage);
  };
    });

  return (opened && (
    <div>
      {/* Rename Grade Modal */}
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
                Sauvegarder
              </button>
              <button onClick={handleModalClose} className={groupStyle["cancel-modal-btn"]}>
                Annuler
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Add Grade Modal */}
      {isAddGradeModalOpen && (
        <div className={groupStyle["modal-overlay"]}>
          <div className={groupStyle["modal-content"]}>
            <h2>Ajouter un grade</h2>
            <input
              type="text"
              value={newGradeName}
              onChange={(e) => setNewGradeName(e.target.value)}
              className={groupStyle["modal-input"]}
            />
            <div className={groupStyle["modal-actions"]}>
              <button onClick={handleSaveNewGrade} className={groupStyle["save-modal-btn"]}>
                Confirmer
              </button>
              <button onClick={handleModalClose} className={groupStyle["cancel-modal-btn"]}>
                Annuler
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Main Form */}
      <div className={groupStyle["container"]}>
        <div className={groupStyle["menu"]}>
          <h1 className={groupStyle["menu-title"]}>Créer un groupe</h1>
          <form className={groupStyle["form"]} onSubmit={(e) => e.preventDefault()}>
            {/* Group Name */}
            <div className={groupStyle["form-group"]}>
              <label htmlFor="groupName">Nom du groupe</label>
              <input
                type="text"
                id="groupName"
                placeholder="Entrer le nom du groupe"
                value={groupName}
                onChange={(e) => setGroupName(e.target.value)}
                required
              />
            </div>

            {/* Group Color */}
            <div className={groupStyle["form-group"]}>
              <label htmlFor="groupColor">Couleur du groupe</label>
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
              <label htmlFor="groupDescription">Description</label>
              <input
                type="text"
                id="groupDescription"
                placeholder="Petite description du groupe"
                value={groupDescription}
                onChange={(e) => setGroupDescription(e.target.value)}
                required
              />
            </div>

            {/* Grades Section */}
            <div className={`${groupStyle["form-group"]} ${groupStyle["grades-section"]}`}>
              <div className={groupStyle["grades-header"]}>
                <label>Liste des grades</label>
                <button
                  type="button"
                  className={groupStyle["add-grade-btn"]}
                  onClick={handleOpenAddGradeModal}
                >
                  <FontAwesomeIcon icon={faPlus} /> Ajouter un grade
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
              Envoyer
            </button>
          </form>
        </div>
      </div>
    </div>
  ));
};
export default Group_creator;
