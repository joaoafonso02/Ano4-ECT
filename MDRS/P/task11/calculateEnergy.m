function energy = calculateEnergy(T, sP, nNodes, nc, sol)
    nodesTraffic = zeros(1, nNodes);

    for flow = 1 : size(T, 1)
        if sol(flow) ~= 0
            nodes = sP{flow}{sol(flow)};
            for n = nodes
                nodesTraffic(n) = nodesTraffic(n) + sum(T(flow, 3:4));
            end
        end
    end

    totalTraffic = sum(nodesTraffic);
    
    energy = 0;
    for node = 1:nNodes
        % Calculate router throughput and capacity
        routerThroughput = nodesTraffic(node);
        routerCapacity = nc;
        
        % Calculate router energy consumption
        routerTrafficRatio = routerThroughput / routerCapacity;
        energy = energy + (20 + 80 * sqrt(routerTrafficRatio));
    end
end
