allprojects {
    repositories {
        maven(url = uri("https://maven.aliyun.com/repository/google"))
        maven(url = uri("https://maven.aliyun.com/repository/central"))
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// بعض المكتبات (مثل file_selector_android) تفرض AGP خاص فيها
// نجبرها تستخدم نفس إصدار مشروعنا 8.9.1 لتفادي فشل التحميل
subprojects {
    buildscript {
        configurations.classpath {
            resolutionStrategy.eachDependency {
                if (requested.group == "com.android.tools.build" &&
                    requested.name == "gradle"
                ) {
                    useVersion("8.9.1")
                    because("Align plugin AGP with the app project")
                }
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
