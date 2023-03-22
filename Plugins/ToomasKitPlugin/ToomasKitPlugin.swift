//
//  ToomasKitPlugin.swift
//  
//
//  Created by Toomas Vahter on 2022/11/25.
//

import Foundation
import PackagePlugin
import XcodeProjectPlugin

enum MyError: Error {
    case main
}

@main
struct ToomasKitPlugin: XcodeBuildToolPlugin, BuildToolPlugin {
    func createBuildCommands(context: XcodeProjectPlugin.XcodePluginContext, target: XcodeProjectPlugin.XcodeTarget) throws -> [PackagePlugin.Command] {
        
        context.xcodeProject.targets.forEach { xcodeTarget in
            print("targets=\(xcodeTarget.displayName)")
            xcodeTarget.dependencies.forEach { xcodeTargetDependency in
                print("dependencies=\(xcodeTargetDependency)")
            }
        }
        
        context.xcodeProject.filePaths.forEach { path in
            print("path=\(path.string)")
        }
        
        let inputJSON = context.xcodeProject.filePaths.filter { $0.extension == "json" }.first! //.appending("Source.json")
        let output = context.pluginWorkDirectory.appending("GeneratedEnum.swift")
        return [
            .buildCommand(displayName: "Generate Code",
                          executable: try context.tool(named: "CodeGenerator").path,
                          arguments: [inputJSON, output],
                          environment: [:],
                          inputFiles: [inputJSON],
                          outputFiles: [output])
        ]
    }
    
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [PackagePlugin.Command] {
    
        let inputJSON = target.directory.appending("Source.json")
        let output = context.pluginWorkDirectory.appending("GeneratedEnum.swift")
        return [
            .buildCommand(displayName: "Generate Code",
                          executable: try context.tool(named: "CodeGenerator").path,
                          arguments: [inputJSON, output],
                          environment: [:],
                          inputFiles: [inputJSON],
                          outputFiles: [output])
        ]
    }
}
