import streamlit as st
import json
import requests
import asyncio
import websockets


st.sidebar.title('メニュー')

st.sidebar.write('QRコードをスキャンして友達追加してください。')
st.sidebar.image('./linebot.png', use_column_width=True)
st.sidebar.write('お問い合わせはこちら')
st.sidebar.write('電話番号: 090-1234-5678')
st.sidebar.write('メールアドレス: help@help.help')

# Initialize session state
if "messages" not in st.session_state:
    st.session_state.messages = []

if "displayed_messages" not in st.session_state:
    st.session_state.displayed_messages = set()

# Function to receive messages from WebSocket
async def receive_messages():
    uri = "wss://562a-180-60-4-132.ngrok-free.app/ws"
    async with websockets.connect(uri) as websocket:
        while True:
            message = await websocket.recv()
            message_data = json.loads(message)
            st.session_state.messages.append({"role": "user", "name": message_data["name"], "content": message_data["text"]})

# Function to get user information from the FastAPI endpoint
def get_users():
    url = "https://562a-180-60-4-132.ngrok-free.app/users"
    response = requests.get(url)
    if response.status_code == 200:
        users = response.json()
        print("successfully get info from json")
        users = [user for user in users if user.get('name')]
        return users
    else:
        st.error(f"Failed to retrieve users. Status code: {response.status_code}")
        return []

# Display user information in the sidebar
def display_users(users):
    with profile_zone.container():
        with st.expander("プロフィール", expanded=True):
        # プロフィール表示関数
            def display_profile(profile):
                st.header(profile["name"])
                # st.image(profile["image"], use_column_width=True)
                st.info(f"会社,役職: {profile['company']}")
                st.error(f"電話番号: {profile['phone']}")
                st.warning(f"メールアドレス: {profile['email']}")
                st.info(f"趣味: {profile['hobbies']}")
                st.success(f"出身地: {profile['hometown']}")

            num_profiles = st.slider("表示するプロフィール数", 1, len(users), 3,key='slider9')

            # カラムを使ってプロフィールを表示
            cols = st.columns(num_profiles)
            for i in range(num_profiles):
                if i < len(users):  # プロフィールの数を超えないようにチェック
                    with cols[i % num_profiles]:
                        display_profile(users[i])



def display_messages():
    with chat_zone.container():
        st.title("リアクション")
        for i, message in enumerate(reversed(st.session_state.messages)):
            with st.chat_message(message["role"]):
                st.markdown(message['name'])
                st.markdown(message["content"])



# Main function to run the Streamlit app
async def main():
    asyncio.create_task(receive_messages())

    users = get_users()  # ユーザー情報を取得
    if users:
        display_users(users)  # サイドバーにユーザー情報を表示


    while True:
        display_messages()
        await asyncio.sleep(1)

# Run the main function
if __name__ == "__main__":
    if "messages" not in st.session_state:
        st.session_state.messages = []

    if "displayed_messages" not in st.session_state:
        st.session_state.displayed_messages = set()
    profile_zone= st.empty()
    chat_zone = st.empty()
    asyncio.run(main())