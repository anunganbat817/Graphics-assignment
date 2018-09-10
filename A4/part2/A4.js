/*
 * UBC CPSC 314, Vsep2017
 * Assignment 4 Template
 */

// Setup renderer
var canvas = document.getElementById('canvas');
var renderer = new THREE.WebGLRenderer();
renderer.setClearColor(0xFFFFFF);
canvas.appendChild(renderer.domElement);

// Adapt backbuffer to window size
function resize() {
  renderer.setSize(window.innerWidth, window.innerHeight);
  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();
  lightCamera.aspect = window.innerWidth / window.innerHeight;
  lightCamera.updateProjectionMatrix();
}

// Hook up to event listener
window.addEventListener('resize', resize);
window.addEventListener('vrdisplaypresentchange', resize, true);

// Disable scrollbar function
window.onscroll = function() {
  window.scrollTo(0, 0);
}

var depthScene = new THREE.Scene(); // shadowmap 
var finalScene = new THREE.Scene(); // final result

// Main camera 
var camera = new THREE.PerspectiveCamera(30, 1, 0.1, 1000); // view angle, aspect ratio, near, far
camera.position.set(0,10,20);
camera.lookAt(finalScene.position);
finalScene.add(camera);

// COMMENT BELOW FOR VR CAMERA
// ------------------------------

// Giving it some controls
cameraControl = new THREE.OrbitControls(camera);
cameraControl.damping = 0.2;
cameraControl.autoRotate = false;
// ------------------------------
// COMMENT ABOVE FOR VR CAMERA



// UNCOMMENT BELOW FOR VR CAMERA
// ------------------------------
// Apply VR headset positional data to camera.
// var controls = new THREE.VRControls(camera);
// controls.standing = true;

// // Apply VR stereo rendering to renderer.
// var effect = new THREE.VREffect(renderer);
// effect.setSize(window.innerWidth, window.innerHeight);


// var display;

// // Create a VR manager helper to enter and exit VR mode.
// var params = {
//   hideButton: false, // Default: false.
//   isUndistorted: false // Default: false.
// };
// var manager = new WebVRManager(renderer, effect, params);
// ------------------------------
// UNCOMMENT ABOVE FOR VR CAMERA


// ------------------------------
// LOADING MATERIALS AND TEXTURES

// Shadow map camera
var shadowMapWidth = 10
var shadowMapHeight = 10
var lightDirection = new THREE.Vector3(0.49,0.79,0.49);
var lightCamera = new THREE.OrthographicCamera(shadowMapWidth / - 2, shadowMapWidth / 2, shadowMapHeight / 2, shadowMapHeight / -2, 1, 1000)
lightCamera.position.set(10, 10, 10)
lightCamera.lookAt(new THREE.Vector3(lightCamera.position - lightDirection));
depthScene.add(lightCamera);

// XYZ axis helper
var worldFrame = new THREE.AxisHelper(2);
finalScene.add(worldFrame)

// texture containing the depth values from the lightCamera POV
// anisotropy allows the texture to be viewed decently at skewed angles
var shadowMapWidth = window.innerWidth
var shadowMapHeight = window.innerHeight

// Texture/Render Target where the shadowmap will be written to
var shadowMap = new THREE.WebGLRenderTarget(shadowMapWidth, shadowMapHeight, { minFilter: THREE.LinearFilter, magFilter: THREE.NearestFilter } )

// Loading the different textures 
// Anisotropy allows the texture to be viewed 'decently' at different angles
var colorMap = new THREE.TextureLoader().load('images/color.jpg')
colorMap.anisotropy = renderer.getMaxAnisotropy()
var normalMap = new THREE.TextureLoader().load('images/normal.png')
normalMap.anisotropy = renderer.getMaxAnisotropy()
var aoMap = new THREE.TextureLoader().load('images/ambient_occlusion.png')
aoMap.anisotropy = renderer.getMaxAnisotropy()

var lavaMap = new THREE.TextureLoader().load('images/lava_texture.jpg')
lavaMap.anisotropy = renderer.getMaxAnisotropy()
var nMap = new THREE.TextureLoader().load('images/norm.png')
nMap.anisotropy = renderer.getMaxAnisotropy()


// Uniforms
var cameraPositionUniform = {type: "v3", value: camera.position }
var lightColorUniform = {type: "c", value: new THREE.Vector3(1.0, 1.0, 1.0) };
var ambientColorUniform = {type: "c", value: new THREE.Vector3(1.0, 1.0, 1.0) };
var lightDirectionUniform = {type: "v3", value: lightDirection };
var kAmbientUniform = {type: "f", value: 0.1};
var kDiffuseUniform = {type: "f", value: 0.8};
var kSpecularUniform = {type: "f", value: 0.4};
var shininessUniform = {type: "f", value: 50.0};
var lightViewMatrixUniform = {type: "m4", value: lightCamera.matrixWorldInverse};
var lightProjectMatrixUniform = {type: "m4", value: lightCamera.projectionMatrix};

// Materials
var depthMaterial = new THREE.ShaderMaterial({})

var terrainMaterial = new THREE.ShaderMaterial({
  // side: THREE.DoubleSide,
  uniforms: {
    lightColorUniform: lightColorUniform,
    ambientColorUniform: ambientColorUniform,
    lightDirectionUniform: lightDirectionUniform,
    kAmbientUniform: kAmbientUniform,
    kDiffuseUniform: kDiffuseUniform,
    kSpecularUniform, kSpecularUniform,
    shininessUniform: shininessUniform,
    lightViewMatrixUniform: lightViewMatrixUniform,
    lightProjectMatrixUniform: lightProjectMatrixUniform,
    colorMap: { type: "t", value: colorMap },
    normalMap: { type: "t", value: normalMap },
    aoMap: { type: "t", value: aoMap },
    shadowMap: { type: "t", value: shadowMap },
  },
});

var armadilloMaterial = new THREE.ShaderMaterial({
  uniforms: {
    lightColorUniform: lightColorUniform,
    ambientColorUniform: ambientColorUniform,
    lightDirectionUniform: lightDirectionUniform,
    kAmbientUniform: kAmbientUniform,
    kDiffuseUniform: kDiffuseUniform,
    kSpecularUniform, kSpecularUniform,
    shininessUniform: shininessUniform,
  },
});

var textureMaterial = new THREE.ShaderMaterial({
  uniforms: {
    lightColorUniform: lightColorUniform,
    ambientColorUniform: ambientColorUniform,
    lightDirectionUniform: lightDirectionUniform,
    kAmbientUniform: kAmbientUniform,
    kDiffuseUniform: kDiffuseUniform,
    kSpecularUniform, kSpecularUniform,
    shininessUniform: shininessUniform,
    lightViewMatrixUniform: lightViewMatrixUniform,
    lightProjectMatrixUniform: lightProjectMatrixUniform,
    nMap: { type: "t", value: nMap },
    aoMap: { type: "t", value: aoMap },
    shadowMap: { type: "t", value: shadowMap },
    lavaMap: { type: "t", value: lavaMap},
  },
});



var skyboxCubemap = new THREE.CubeTextureLoader()
  .setPath( 'images/cubemap/' )
  .load( [
  'cube1.png', 'cube2.png',
  'cube3.png', 'cube4.png',
  'cube5.png', 'cube6.png'
  ] );

  // var f = new THREE.BoxGeometry(20,20,20);
  // for (var i = 0; i <500; i ++) {
  // 	var object1 = new THREE.Mesh( g, new THREE.MeshBasicMaterial( { color: Math.random() * 0x1212e7}));
  // 	object1.position.x = Math.random() * 2000 - 1000;
  // 	object1.position.y = Math.random() * 800 - 300; 
  // 	object1.position.z = Math.random() * 400 - 200;
  // 	object1.position.x = Math.random() * 2 * Math.PI;
  // 	obejct1.position.y = Math.random() * 2 * Math.PI;
  // }

var skyboxMaterial = new THREE.ShaderMaterial({
	uniforms: {
    skybox: {type: "t", value: skyboxCubemap}
  },
    side: THREE.DoubleSide
});

//{
 //   skybox: { type: "t", value: skyboxCubemap },
 // },

var skybox = new THREE.Mesh(
  new THREE.BoxGeometry(1000,1000,1000),
  skyboxMaterial);



// finalScene.add(skybox);
finalScene.background = skyboxCubemap;

var objects = [];
var raycaster, parentTransform, sphereInter;
var mouse = new THREE.Vector2();
var radius = 100, theta = 0;
var currentIntersected;

var g = new THREE.BoxGeometry(10,10,12);
for ( var i = 0; i < 250; i ++ ) {
var object = new THREE.Mesh( g, new THREE.MeshBasicMaterial( { color: Math.random() * 0xffd700 } ) );
object.position.x = Math.random() * 1000 - 500;
object.position.y = Math.random() * 600 - 300;
object.position.z = Math.random() * 800 - 400;
object.rotation.x = Math.random() * 2 * Math.PI;
object.rotation.y = Math.random() * 2 * Math.PI;
object.rotation.z = Math.random() * 2 * Math.PI;
object.scale.x = Math.random() * 2 + 1;
object.scale.y = Math.random() * 2 + 1
object.scale.z = Math.random() * 2 + 1;
object.castShadow = true;
object.receiveShadow = true;
finalScene.add( object );
objects.push( object );
};

var geometry = new THREE.SphereGeometry( 5 );
var material = new THREE.MeshBasicMaterial( { color: 0xff0000 } );
sphereInter = new THREE.Mesh( geometry, material );
sphereInter.visible = false;
finalScene.add(sphereInter);

var geometry = new THREE.Geometry();
var point = new THREE.Vector3();
var direction = new THREE.Vector3();
for ( var i = 0; i < 50; i ++ ) {
direction.x += Math.random() - 0.5;
direction.y += Math.random() - 0.5;
direction.z += Math.random() - 0.5;
direction.normalize().multiplyScalar( 10 );
point.add( direction );
geometry.vertices.push( point.clone() );
};

var parentTransform = new THREE.Object3D();
parentTransform.position.x = Math.random() * 40 - 20;
parentTransform.position.y = Math.random() * 40 - 20;
parentTransform.position.z = Math.random() * 40 - 20;
parentTransform.rotation.x = Math.random() * 2 * Math.PI;
parentTransform.rotation.y = Math.random() * 2 * Math.PI;
parentTransform.rotation.z = Math.random() * 2 * Math.PI;
parentTransform.scale.x = Math.random() + 0.5;
parentTransform.scale.y = Math.random() + 0.5;
parentTransform.scale.z = Math.random() + 0.5;

for ( var i = 0; i < 80; i ++ ) {
var object;
if ( Math.random() > 0.5 ) {
  object = new THREE.Line( geometry );
} else {
  object = new THREE.LineSegments( geometry );
}
object.position.x = Math.random() * 400 - 200;
object.position.y = Math.random() * 400 - 200;
object.position.z = Math.random() * 400 - 200;
object.rotation.x = Math.random() * 2 * Math.PI;
object.rotation.y = Math.random() * 2 * Math.PI;
object.rotation.z = Math.random() * 2 * Math.PI;
object.scale.x = Math.random() + 0.5;
object.scale.y = Math.random() + 0.5;
object.scale.z = Math.random() + 0.5;
parentTransform.add( object );
};

finalScene.add( parentTransform );


// the createMesh is the same function we saw earlier
var l1;
var l2; 
var l3; 
var l4; 
var clock = new THREE.Clock();
var object;
var sphere = new THREE.SphereGeometry( 0.5, 16, 8);

l1 = new THREE.PointLight( 0x68001A, 2, 50 );
l1.add( new THREE.Mesh( sphere, new THREE.MeshBasicMaterial( { color: 0x68001A } ) ) );
finalScene.add( l1 );

l2 = new THREE.PointLight( 0x1212e7, 2, 50 );
l2.add( new THREE.Mesh( sphere, new THREE.MeshBasicMaterial( { color: 0x01212e7 } ) ) );
finalScene.add( l2 );

l3 = new THREE.PointLight( 0x9A377B, 2, 50 );
l3.add( new THREE.Mesh( sphere, new THREE.MeshBasicMaterial( { color: 0x9A377B } ) ) );
finalScene.add( l3 );

l4 = new THREE.PointLight( 0x39f200, 2, 50 );
l4.add( new THREE.Mesh( sphere, new THREE.MeshBasicMaterial( { color: 0x39f200 } ) ) );
finalScene.add( l4 );


function render() {
  var time = Date.now() * 0.002;
  var delta = clock.getDelta()
  if( object ) object.rotation.y -= 0.5 * delta;
  l1.position.x = Math.sin( time * 0.7 ) * 30;
  l1.position.y = Math.cos( time * 0.5 ) * 40;
  l1.position.z = Math.cos( time * 0.3 ) * 30;
  l2.position.x = Math.cos( time * 0.3 ) * 30;
  l2.position.y = Math.sin( time * 0.5 ) * 40;
  l2.position.z = Math.sin( time * 0.7 ) * 30;
  l3.position.x = Math.sin( time * 0.7 ) * 30;
  l3.position.y = Math.cos( time * 0.3 ) * 40;
  l3.position.z = Math.sin( time * 0.5 ) * 30;
  l4.position.x = Math.sin( time * 0.3 ) * 30;
  l4.position.y = Math.cos( time * 0.7 ) * 40;
  l4.position.z = Math.sin( time * 0.5 ) * 30;
  renderer.render( finalScene, camera );
};


//Create an AudioListener and add it to the camera
var listener = new THREE.AudioListener();
camera.add( listener );

// create a global audio source
var sound = new THREE.Audio( listener );

var audioLoader = new THREE.AudioLoader();

//Load a sound and set it as the Audio object's buffer
audioLoader.load( 'sounds/mario.mp3', function( buffer ) {
  sound.setBuffer( buffer );
  sound.setLoop( true );
  sound.setVolume( 0.5 );
  sound.play();
});


// -------------------------------
// LOADING SHADERS
var shaderFiles = [
  'glsl/depth.vs.glsl',
  'glsl/depth.fs.glsl',

  'glsl/terrain.vs.glsl',
  'glsl/terrain.fs.glsl',  

  'glsl/bphong.vs.glsl',
  'glsl/bphong.fs.glsl',

  'glsl/skybox.vs.glsl',
  'glsl/skybox.fs.glsl',

  'glsl/texture.vs.glsl',
  'glsl/texture.fs.glsl'
];

new THREE.SourceLoader().load(shaderFiles, function(shaders) {
	depthMaterial.vertexShader = shaders['glsl/depth.vs.glsl']
	depthMaterial.fragmentShader = shaders['glsl/depth.fs.glsl']
	terrainMaterial.vertexShader = shaders['glsl/terrain.vs.glsl']
	terrainMaterial.fragmentShader = shaders['glsl/terrain.fs.glsl']	
	armadilloMaterial.vertexShader = shaders['glsl/bphong.vs.glsl']
	armadilloMaterial.fragmentShader = shaders['glsl/bphong.fs.glsl']
	skyboxMaterial.vertexShader = shaders['glsl/skybox.vs.glsl']	
	skyboxMaterial.fragmentShader = shaders['glsl/skybox.fs.glsl']
  textureMaterial.vertexShader = shaders['glsl/texture.vs.glsl']
  textureMaterial.fragmentShader = shaders['glsl/texture.fs.glsl']
})

// LOAD OBJ ROUTINE
// mode is the scene where the model will be inserted
function loadOBJ(scene, file, material, scale, xOff, yOff, zOff, xRot, yRot, zRot) {
  var onProgress = function(query) {
    if (query.lengthComputable) {
      var percentComplete = query.loaded / query.total * 100;
      console.log(Math.round(percentComplete, 2) + '% downloaded');
    }
  };

  var onError = function() {
    console.log('Failed to load ' + file);
  };

  var loader = new THREE.OBJLoader();
  loader.load(file, function(object) {
    object.traverse(function(child) {
      if (child instanceof THREE.Mesh) {
        child.material = material;
      }
    });

    object.position.set(xOff, yOff, zOff);
    object.rotation.x = xRot;
    object.rotation.y = yRot;
    object.rotation.z = zRot;
    object.scale.set(scale, scale, scale);
    scene.add(object)
  }, onProgress, onError);
}

// -------------------------------
// ADD OBJECTS TO THE SCENE
var terrainGeometry = new THREE.PlaneBufferGeometry(10, 10);
var terrain = new THREE.Mesh(terrainGeometry, terrainMaterial)
terrain.rotation.set(-1.57, 0, 0)
finalScene.add(terrain)
var terrainDO = new THREE.Mesh(terrainGeometry, depthMaterial)
terrainDO.rotation.set(-1.57, 0, 0)
depthScene.add(terrainDO)


loadOBJ(finalScene, 'obj/armadillo.obj', armadilloMaterial, 1.0, 0, 1.0, 0, 0, 0, 0)
loadOBJ(depthScene, 'obj/armadillo.obj', depthMaterial, 1.0, 0, 1.0, 0, 0, 0, 0)
loadOBJ(finalScene, 'obj/bunny.obj', textureMaterial, 1.0, 2.5, 0.1, 2, 0, -4, 0)
loadOBJ(depthScene, 'obj/bunny.obj', depthMaterial, 1.0, 2.5, 0.1, 2, 0, -4, 0)
loadOBJ(finalScene, 'obj/bunny.obj', textureMaterial, 0.5, 0.5, 0.1, 3, 0, -2, 0)
loadOBJ(depthScene, 'obj/bunny.obj', depthMaterial, 0.5, 0.5, 0.1, 3, 0, -2, 0)


// -------------------------------
// UPDATE ROUTINES
var keyboard = new THREEx.KeyboardState();

function checkKeyboard() { }

function updateMaterials() {
	cameraPositionUniform.value = camera.position

	depthMaterial.needsUpdate = true
	terrainMaterial.needsUpdate = true
	armadilloMaterial.needsUpdate = true
	skyboxMaterial.needsUpdate = true
  textureMaterial.needsUpdate = true
}

// Update routine
function update() {
	checkKeyboard()
	updateMaterials()
  render()

	requestAnimationFrame(update)
	renderer.render(depthScene, lightCamera, shadowMap)
	renderer.render(finalScene, camera)



  // UNCOMMENT BELOW FOR VR CAMERA
  // ------------------------------
  // Update VR headset position and apply to camera.
  // controls.update();
  // ------------------------------
  // UNCOMMENT ABOVE FOR VR CAMERA

  // To see the shadowmap values: 
    // renderer.render(depthScene, lightCamera)
}

resize()
update();
