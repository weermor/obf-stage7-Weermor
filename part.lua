tPosition)
                            rootPart.CFrame = baseCFrame * CFrame.Angles(0, math.rad(30), 0)
                        end

                        if targetStrafeEnabled and currentTarget then
                            local targetRoot = currentTarget:FindFirstChild("HumanoidRootPart")
                            if targetRoot then
                                local angle = tick() * strafeSpeed
                                local targetCFrame = targetRoot.CFrame
                                local strafePosition
                                local targetTool = currentTarget:FindFirstChildOfClass("Tool")
                                local isTargetAttacking = targetTool and targetTool:FindFirstChild("Handle") and 
                                    targetHumanoid:FindFirstChild("Animator") and 
                                    #targetHumanoid.Animator:GetPlayingAnimationTracks() > 0

                                local targetHeight = killAuraMode == "UnderFeet" and targetRoot.Position.Y - 0.1 or targetRoot.Position.Y

                                if smartStrafeEnabled and isTargetAttacking then
                                    local basePosition = targetRoot.Position
                                    local retreatDistance = strafeDistance * 2
                                    local lookVector = targetCFrame.LookVector
                                    strafePosition = basePosition - (lookVector * retreatDistance)
                                else
                                    local relativeOffset = Vector3.new(
                                        math.sin(angle) * strafeDistance,
                                        killAuraMode == "UnderFeet" and 0.5 or 0,
                                        math.cos(angle) * strafeDistance
                                    )
                                    strafePosition = targetRoot.Position + targetCFrame:VectorToWorldSpace(relativeOffset)
                                end

                                strafePosition = Vector3.new(strafePosition.X, targetHeight, strafePosition.Z)
                                local currentPosition = rootPart.Position
                                local newPosition = currentPosition:Lerp(strafePosition, strafeSpeed * deltaTime)
                                local lookAtPosition = Vector3.new(targetRoot.Position.X, rootPart.Position.Y, targetRoot.Position.Z)
                                local baseCFrame = CFrame.new(newPosition, lookAtPosition)
                                rootPart.CFrame = baseCFrame * CFrame.Angles(0, math.rad(30), 0)
                            end
                        end

                        if currentTime - lastAttackTime >= attackCooldown then
                            local tool = character:FindFirstChildOfClass("Tool")
                            if tool and tool:FindFirstChild("Handle") then
                                local distance = (rootPart.Position - targetRoot.Position).Magnitude
                                if distance <= killAuraRange then
                                    tool:Activate()
                                    lastAttackTime = currentTime
                                end
                            end
                        end

                        lastSelectedTarget = currentTarget
                    else
                        currentTarget = nil
                        lastAttackedTargets = {}
                        lastSelectedTarget = nil
                        highlight.Parent = nil
                        if rootPart:FindFirstChild("BodyVelocity") then
                            rootPart:FindFirstChild("BodyVelocity"):Destroy()
                        end
                    end
                else
                    if rootPart:FindFirstChild("BodyVelocity") then
                        rootPart:FindFirstChild("BodyVelocity"):Destroy()
                    end
                end
            end)
        else
            highlight.Parent = nil
            currentTarget = nil
            lastAttackedTargets = {}
            lastSelectedTarget = nil
            if rootPart and rootPart:FindFirstChild("BodyVelocity") then
                rootPart:FindFirstChild("BodyVelocity"):Destroy()
            end
        end
         Duration = 3
    end
})


MovementWindow:Toggle({
    Text = "Speed Hack",
    Default = false,
    Callback = function(state)
        speedEnabled = state
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")

        if speedEnabled then
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Name = "SpeedHackVelocity"
            bodyVelocity.MaxForce = Vector3.new(math.huge, 0, math.huge)
            bodyVelocity.Parent = rootPart

            RunService.Heartbeat:Connect