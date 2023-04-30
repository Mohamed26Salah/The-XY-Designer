import json
import firebase_admin
from firebase_admin import credentials, storage
from firebase_admin import firestore
import datetime
cred = credentials.Certificate("the-xy-designer-74fa3-firebase-adminsdk-hr9h2-ca1adae06d.json")
firebase_admin.initialize_app(cred, {
    'storageBucket': 'the-xy-designer-74fa3.appspot.com'
})

def UploadToFirebase(specialID,data):
    
    SalahSceneID=specialID
    SalahUserID= specialID[:28]
    bucket = storage.bucket()
    filename = 'file'+specialID+'.json'
    
    folder_path = 'Scenes'  # path to the folder you want to upload the file to
    blob = bucket.blob(f'{folder_path}/{filename}')
    f2 = open('OutputToFirebase.json','w+')
    f2.write(json.dumps(data))

    f2.close()
    filepath = './OutputToFirebase.json'
    blob.upload_from_filename(filepath,content_type='json')
    url = blob.generate_signed_url(expiration=datetime.timedelta(days=365*100))
    print(url)

    db = firestore.client()

    doc_ref = db.collection(u'usersScenes').document(SalahUserID)
    doc_snapshot = doc_ref.get()
    array_field = doc_snapshot.get(u'jsonFiles')

    if array_field:
        for pos,field in enumerate(array_field):
            if field['id']==SalahSceneID:
                field['link']=url
                field['BeingOptimized']=False
                doc_ref.update({'jsonFiles': array_field})

    # https://firebasestorage.googleapis.com/v0/b/the-xy-designer-74fa3.appspot.com/o/Scenes%2Ffileh7RHlUTPo0YROvva4zsIVmjxziC3SalahIsThe%20Best%20the.json?alt=media&token=82ead8cf-7a11-4104-9abe-7504f628b253