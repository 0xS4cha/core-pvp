import React, { useEffect, useState } from "react";
import {
  Card,
  Text,
  ScrollArea,
  Badge,
  Button,
  Flex,
  Title,
  Checkbox,
  ActionIcon,
  Grid,
  Loader,
} from "@mantine/core";
import {
  IconAlertCircle,
  IconCheckbox,
  IconInfoCircle,
  IconSkull,
  IconUxCircle,
  IconBrandCodepen,
  IconUser,
  IconWorld,
  IconUsersGroup,
  IconWebhook,
} from "@tabler/icons-react";
import { fetchNui } from "../../utils/fetchNui";

interface SimulatedConsoleProps {
  ranksInformation: any;
  ranksData: any;
  permission: any,
}

const SimulatedConsole: React.FC<SimulatedConsoleProps> = ({
  ranksInformation,
  permission,
  ranksData,
}) => {
  const [showContent, setShowContent] = useState(false);
  const [selectedPlayers, setSelectedPlayers] = useState({
    name: "",
    rank: 0,
    permission: {},
  });
  useEffect(() => {
    const timer = setTimeout(() => setShowContent(true), 1500);
    return () => clearTimeout(timer);
  }, []);

  
  if (!showContent) {
    return (
      <div
        style={{
          textAlign: "center",
          marginTop: 350,
          padding: "20px",
          color: "white",
        }}
      >
        <Loader size="xl" color="gray" variant="bars" />
        <Text weight={800} size="sm" tt="uppercase" color="gray">
          Loading ranklist...
        </Text>
      </div>
    );
  }

  const HandleSaveRank = () => {
    ranksData = fetchNui('crew:manage:saverank', //@ts-ignore
      selectedPlayers)

  }

  const HandleDeleteRank = () => {
    ranksData = fetchNui('crew:manage:deleterank', //@ts-ignore
      selectedPlayers.id_rank),
    setSelectedPlayers({
      name: "",
      rank: 0,
      permission: {},
    })
  }
  //@ts-ignore
  const handleCheckboxChange = (key) => (event) => {
    setSelectedPlayers((prev) => ({
      ...prev,
      permission: {
        ...prev.permission,
        [key]: event.currentTarget.checked,
      },
    }));
  };
  return (
    <Flex
      justify="center"
      align="flex-start"
      style={{ gap: "20px", width: "100%" }}
    >
      <div style={{ width: "100%" }}>
        <Title
          tt="uppercase"
          order={2}
          style={{ marginBottom: "15px", color: "white" }}
        >
          Liste des rangs
        </Title>
        <Card
          shadow="xs"
          radius="md"
          padding="sm"
          style={{
            backgroundColor: "rgba(35, 45, 61, 0.8)",
            border: "1px solid rgba(255, 255, 255, 0.1)",
            boxShadow: "0 4px 8px rgba(0, 0, 0, 0.1)",
          }}
        >
          <Flex
            gap="xs"
            justify="flex-start"
            align="center"
            direction="row"
            wrap="wrap"
            mb={20}
          >
            <ActionIcon
              variant="light"
              style={{
                width: "40px",
                height: "40px",
                borderRadius: "10px",

                backgroundColor: "rgba(55, 65, 81, 0.85)",
                pointerEvents: "none",
                display: "flex",
                justifyContent: "center",
                alignItems: "center",
              }}
              color="yellow"
            >
              <IconWebhook size={24} />
            </ActionIcon>
            <Flex
              justify="flex-start"
              align="flex-start"
              direction="column"
              wrap="wrap"
            >
              <Title
                tt="uppercase"
                order={3}
                style={{ color: "white", marginTop: 0 }}
              >
                Liste des rangs
              </Title>
              <Text color="dimmed" size="sm">
                Liste de tout les rangs de votre crew
              </Text>
            </Flex>
          </Flex>
          <ScrollArea scrollbarSize={1} style={{ height: 623 }}>
            <Grid gutter="xs" style={{ width: "100%" }}>
              {Object.entries(ranksData).map(([key, rank]) => (
                <Grid.Col span={12} key={key}>
                  <Card
                    shadow="xs"
                    radius="sm"
                    padding="xs"
                    onClick={() =>
                      setSelectedPlayers(
                        //@ts-ignore
                        rank
                      )
                    }
                    style={{
                      backgroundColor: "rgba(25, 35, 51, 0.8)",
                      border: "1px solid rgba(255, 255, 255, 0.2)",
                      boxShadow: "0 4px 8px rgba(0, 0, 0, 0.1)",
                      marginBottom: 10,
                    }}
                  >
                    <Flex justify="space-between" align="center" gap="xs">
                      <Flex gap="xs" align="center">
                        <ActionIcon
                          radius="xs"
                          size="lg"
                          variant="light"
                          style={{
                            backgroundColor: "rgba(55, 65, 81, 0.85)",
                            pointerEvents: "none",
                            border: "1px solid rgba(255, 255, 255, 0.1)",
                          }}
                        >
                          {
                            //@ts-ignore
                            rank.rank
                          }
                        </ActionIcon>
                        <Text
                          tt="uppercase"
                          size="sm"
                          weight={600}
                          color="white"
                        >
                          {
                            //@ts-ignore
                            rank.name
                          }
                        </Text>
                      </Flex>
                      <Flex gap="xs" align="center">
                        <Badge variant="dot" color="blue" size="sm" radius="sm">
                          {
                            //@ts-ignore
                            rank.id_rank
                          }
                        </Badge>
                      </Flex>
                    </Flex>
                  </Card>
                </Grid.Col>
              ))}
            </Grid>
          </ScrollArea>
        </Card>
      </div>
      {selectedPlayers.rank && (
        <div style={{ width: "40%", marginTop: 50 }}>
          <Flex direction="column" gap="xs">
            <Card
              shadow="xs"
              radius="md"
              padding="sm"
              style={{
                backgroundColor: "rgba(35, 45, 61, 0.8)",
                border: "1px solid rgba(255, 255, 255, 0.1)",
                boxShadow: "0 4px 8px rgba(0, 0, 0, 0.1)",
                height: "100%",
              }}
            >
              <Flex
                gap="xs"
                justify="flex-start"
                align="center"
                direction="row"
                wrap="wrap"
                mb={20}
              >
                <ActionIcon
                  variant="light"
                  style={{
                    width: "40px",
                    height: "40px",
                    borderRadius: "10px",
                    backgroundColor: "rgba(55, 65, 81, 0.85)",
                    pointerEvents: "none",
                    display: "flex",
                    justifyContent: "center",
                    alignItems: "center",
                  }}
                  color="violet"
                >
                  <IconUsersGroup size={24} />
                </ActionIcon>
                <Flex
                  justify="flex-start"
                  align="flex-start"
                  direction="column"
                  wrap="wrap"
                >
                  <Title
                    tt="uppercase"
                    order={3}
                    style={{ color: "white", marginTop: 0 }}
                  >
                    Rang séléctionné
                  </Title>
                  <Text color="dimmed" size="sm">
                    Information sur le rang
                  </Text>
                </Flex>
              </Flex>
              <Card
                shadow="xs"
                radius="sm"
                padding="xs"
                style={{
                  backgroundColor: "rgba(25, 35, 51, 0.8)",
                  border: "1px solid rgba(255, 255, 255, 0.2)",
                  boxShadow: "0 4px 8px rgba(0, 0, 0, 0.1)",
                  marginBottom: 10,
                }}
              >
                <Flex justify="space-between" align="center" gap="xs">
                  <Flex gap="xs" align="center">
                    <Text tt="uppercase" size="sm" weight={600} color="white">
                      Nom du rang
                    </Text>
                  </Flex>
                  <Flex gap="xs" align="center">
                    <Badge variant="dot" color="red" size="sm" radius="sm">
                      {selectedPlayers.name}
                    </Badge>
                  </Flex>
                </Flex>
              </Card>

              <Card
                shadow="xs"
                radius="sm"
                padding="xs"
                style={{
                  backgroundColor: "rgba(25, 35, 51, 0.8)",
                  border: "1px solid rgba(255, 255, 255, 0.2)",
                  boxShadow: "0 4px 8px rgba(0, 0, 0, 0.1)",
                  marginBottom: 40,
                }}
              >
                <Flex justify="space-between" align="center" gap="xs">
                  <Flex gap="xs" align="center">
                    <Text tt="uppercase" size="sm" weight={600} color="white">
                      UUID
                    </Text>
                  </Flex>
                  <Flex gap="xs" align="center">
                    <Badge variant="dot" color="blue" size="sm" radius="sm">
                      {
                        //@ts-ignore
                        selectedPlayers.id_rank
                      }
                    </Badge>
                  </Flex>
                </Flex>
              </Card>
              {permission['changePerm'] && (
                <>
              {Object.entries(selectedPlayers.permission).map(
                ([key, p]) => (
                  <Card
                    shadow="xs"
                    radius="sm"
                    padding="xs"
                    style={{
                      backgroundColor: "rgba(25, 35, 51, 0.8)",
                      border: "1px solid rgba(255, 255, 255, 0.2)",
                      boxShadow: "0 4px 8px rgba(0, 0, 0, 0.1)",
                      marginBottom: 10,
                    }}
                  >
                    <Flex justify="space-between" align="center" gap="xs">
                      <Flex gap="xs" align="center">
                        <Text
                          tt="uppercase"
                          size="sm"
                          weight={600}
                          color="white"
                        >
                          {key}
                        </Text>
                      </Flex>
                      <Flex gap="xs" align="center">
                        <Checkbox
                          checked={
                            //@ts-ignore
                            selectedPlayers.permission[key] || false
                          }
                          onChange={handleCheckboxChange(key)}
                        />
                      </Flex>
                    </Flex>
                  </Card>
                )
              )}
              </>)}
              {permission['deleteRank'] && (
              <Button
                style={{
                  background: "var(--degrade-radial-rouge)",
                  border: "1px solid rgba(255, 255, 255, 0.2)",
                  boxShadow: "0 4px 8px rgba(0, 0, 0, 0.1)",
                  marginBottom: 10,
                }}
                fullWidth
                onClick={()=> HandleDeleteRank()}
              >
                Supprimer
              </Button>)}
              {permission['changePerm'] && (
              <Button
                style={{
                  background: "var(--degrade-radial-vert)",
                  border: "1px solid rgba(255, 255, 255, 0.2)",
                  boxShadow: "0 4px 8px rgba(0, 0, 0, 0.1)",
                  marginBottom: 10,
                }}
                fullWidth
                onClick={()=> HandleSaveRank()}
              >
                Sauvegarder
              </Button>)}
            </Card>
          </Flex>
        </div>
      )}
    </Flex>
  );
};

export default SimulatedConsole;
