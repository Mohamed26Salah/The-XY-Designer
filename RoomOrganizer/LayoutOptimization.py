from FromNewToOld import *
from Room import *
from FireStoreWrite import *
from rl.agents import DQNAgent
from rl.policy import *
from rl.memory import SequentialMemory
import numpy as np

from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Flatten, Dropout
from tensorflow.keras.optimizers import Adam



def build_model(states, actions):
    model = Sequential()
    model.add(Flatten(input_shape=states))
    model.add(Dense(128, activation='relu', input_shape=states))
    model.add(Dense(128, activation='relu'))
    model.add(Dense(actions, activation='linear'))
    return model



def build_agent(model, actions, policy):
    policy = policy
    memory = SequentialMemory(limit=30000, window_length=1)
    dqn = DQNAgent(model=model, memory=memory, policy=policy,
                   nb_actions=actions, nb_steps_warmup=500, target_model_update=1e-3)
    return dqn

def fitall( env,keywords,model,actions):
    for i in keywords:
        dqn = build_agent(model, actions, EpsGreedyQPolicy(eps=0.2))
        dqn.compile(Adam(lr=1e-2), metrics=['mae'])
        dqn.fit(env, nb_steps=100, visualize=False, verbose=1)
        env.nextPlease()

def testall( env,keywords,model,actions):
    for i in keywords:
        dqn = build_agent(model, actions, EpsGreedyQPolicy(eps=0.2))
        dqn.compile(Adam(lr=1e-2), metrics=['mae'])
        dqn.test(env,nb_episodes=1,visualize=False)
        env.nextPlease()

def main_procces(json_data=None):
    FurnitureRects,WallRects,Keywords,FurnitureArray,Room1,pivot,angle,SurfacesForDebug,state4,data= pre_processing(json_data)
    env = RoomEnv(Keywords,WallRects,FurnitureRects,SurfacesForDebug,state4)
    states = env.observation_space.shape
    actions = env.action_space.n
    model = build_model(states, actions)
    fitall(env,FurnitureRects,model=model,actions=actions)
    env.close()
    # testall(env,FurnitureRects,model=model,actions=actions)
    FurnitureRects2,WallRects2=env.exportRoom()
    # Furniture

    transform12,transform14=ExtractFurniturePosition(FurnitureRects2,angle,pivot)

    for i,furniture in enumerate(FurnitureArray):
        furniture.transform[12]=transform12[i]/100
        furniture.transform[14]=transform14[i]/100
    Room1.objects=FurnitureArray
    toBeWritten =Room.to_dict(Room1)
    # Walls
    if(json_data):
        data = json_data
            
            # Iterating through the json
            # list
        data['objects']=toBeWritten['objects']

            # Closing file
        UploadToFirebase(data['specialID'],data)
        return data
    else:     
        return Room1

if __name__=="__main__":
    print(main_procces())
