function plotSingleSimulation(flightOpts, t, State)
    r = State(:, 1:2);
    v = State(:, 3:4);

    altitude = r(:,2);
    vMag = vecnorm(v');
    acceleration = gradient(vMag, t);
    propellantMass = State(:, 5);

    burnOutIndex = find(max(0, t - flightOpts.BurnTime), 1);
    [~, apogeeIndex] = max(altitude);

    setupSubplots(4,3);

    nextPlot();
    plot(r(:,1)/1e3, r(:,2)/1e3, '-', 'HandleVisibility','off')
    hold on
    plot(r(1,1)/1e3, r(1,2)/1e3, '*', 'DisplayName', 'Initial')
    plot(r(apogeeIndex,1)/1e3, r(apogeeIndex,2)/1e3, 'b*', 'DisplayName', 'Apogee')
    plot(r(burnOutIndex,1)/1e3, r(burnOutIndex,2)/1e3, 'ro', 'DisplayName', 'Burnout')
    xlabel("downrange [km]");
    ylabel("altitude [km]");
    axis equal
    title("2D trajectory");
    legend('show', 'Location', 'best');
    grid on
    scaleLims(0.1);
    
    nextPlot();
    plot(t, altitude/1e3, 'HandleVisibility','off');
    hold on
    plot(t(apogeeIndex), altitude(apogeeIndex)/1e3, 'b*', 'DisplayName', 'Apogee')
    plot(t(burnOutIndex), altitude(burnOutIndex)/1e3, 'ro', 'DisplayName', 'Burnout')
    xlabel("time [s]");
    ylabel("Altitude [km]");
    title("Altitude over time");
    legend('show', 'Location', 'best');
    grid on
    scaleLims(0.1);

    nextPlot();
    plot(t, vMag, 'HandleVisibility','off');
    hold on
    plot(t(apogeeIndex), vMag(apogeeIndex), 'b*', 'DisplayName', 'Apogee')
    plot(t(burnOutIndex), vMag(burnOutIndex), 'ro', 'DisplayName', 'Burnout')
    xlabel("time [s]");
    ylabel("Velocity [m/s]");
    title("Velocity over time");
    legend('show', 'Location', 'best');
    grid on
    scaleLims(0.1);

    nextPlot();
    [ambientDensity, ambientPressure, speedOfSound] = atmosphereModel(altitude);
    plot(t, vMag./speedOfSound, 'HandleVisibility','off');
    hold on
    plot(t(apogeeIndex), vMag(apogeeIndex)./speedOfSound(apogeeIndex), 'b*', 'DisplayName', 'Apogee')
    plot(t(burnOutIndex), vMag(burnOutIndex)./speedOfSound(burnOutIndex), 'ro', 'DisplayName', 'Burnout')
    xlabel("time [s]");
    ylabel("Mach");
    title("Mach over time");
    legend('show', 'Location', 'best');
    grid on
    scaleLims(0.1);
    
    nextPlot();
    plot(altitude / 1000, vMag, 'HandleVisibility','off')
    hold on
    plot(altitude(1) / 1000, vMag(1), '*', 'DisplayName', 'Initial')
    plot(altitude(apogeeIndex) / 1000, vMag(apogeeIndex), 'b*', 'DisplayName', 'Apogee')
    plot(altitude(burnOutIndex) / 1000, vMag(burnOutIndex), 'ro', 'DisplayName', 'Burnout')
    xlabel("altitude [km]");
    ylabel("velocity [m/s]");
    title("Velocity as function of altitude");
    legend('show', 'Location', 'best');
    grid on
    scaleLims(0.1);


    nextPlot();
    plot(t, abs(acceleration)/9.8066, 'HandleVisibility','off');
    hold on
    plot(t(apogeeIndex), abs(acceleration(apogeeIndex))/9.8066, 'b*', 'DisplayName', 'Apogee')
    plot(t(burnOutIndex), abs(acceleration(burnOutIndex))/9.8066, 'ro', 'DisplayName', 'Burnout')
    xlabel("time [s]");
    ylabel("acceleration [g]");
    title("Acceleration over time");
    legend('show', 'Location', 'best');
    grid on
    scaleLims(0.1);
    
    nextPlot();
    plot(t, ambientPressure/1e3, 'HandleVisibility','off');
    hold on
    plot(t(apogeeIndex), ambientPressure(apogeeIndex)/1e3, 'b*', 'DisplayName', 'Apogee')
    plot(t(burnOutIndex), ambientPressure(burnOutIndex)/1e3, 'ro', 'DisplayName', 'Burnout')
    xlabel("time [s]");
    ylabel("Ambient pressure [kPa]");
    title("Atmosphere pressure");
    legend('show', 'Location', 'best');
    grid on
    scaleLims(0.1);

    nextPlot();
    plot(t, ambientDensity, 'HandleVisibility','off');
    hold on
    plot(t(apogeeIndex), ambientDensity(apogeeIndex), 'b*', 'DisplayName', 'Apogee')
    plot(t(burnOutIndex), ambientDensity(burnOutIndex), 'ro', 'DisplayName', 'Burnout')
    xlabel("time [s]");
    ylabel("Ambient density [kg/m^3]");
    title("Atmosphere density");
    legend('show', 'Location', 'best');
    grid on
    scaleLims(0.1);


    nextPlot();
    Cd = dragCoefficientModel(vMag, speedOfSound);
    % mass = massModel(t, flightOpts.DryMass, propellantMass);
    dragFactor = dragModel(vMag, ambientDensity, flightOpts.Radius, Cd);
    plot(t, dragFactor, 'HandleVisibility','off');
    hold on
    plot(t(apogeeIndex), dragFactor(apogeeIndex), 'b*', 'DisplayName', 'Apogee')
    plot(t(burnOutIndex), dragFactor(burnOutIndex), 'ro', 'DisplayName', 'Burnout')
    xlabel("time [s]");
    ylabel("drag [N]");
    title("Drag over time");
    legend('show', 'Location', 'best');
    grid on
    scaleLims(0.1);

    nextPlot();
    plot(altitude / 1000, dragFactor, 'HandleVisibility','off')
    hold on
    plot(altitude(1) / 1000, dragFactor(1), '*', 'DisplayName', 'Initial')
    plot(altitude(apogeeIndex) / 1000, dragFactor(apogeeIndex), 'b*', 'DisplayName', 'Apogee')
    plot(altitude(burnOutIndex) / 1000, dragFactor(burnOutIndex), 'ro', 'DisplayName', 'Burnout')
    xlabel("altitude [km]");
    ylabel("drag [N]");
    title("Drag as function of altitude");
    legend('show', 'Location', 'best');
    grid on
    scaleLims(0.1);

    nextPlot();
    plot(t, propellantMass, 'HandleVisibility','off')
    hold on
    plot(t(apogeeIndex), propellantMass(apogeeIndex), 'b*', 'DisplayName', 'Apogee')
    plot(t(burnOutIndex), propellantMass(burnOutIndex), 'ro', 'DisplayName', 'Burnout')
    xlabel("time [s]");
    ylabel("propellant mass [kg]");
    title("Propellant mass over time");
    legend('show', 'Location', 'best');
    xlim([-1 t(apogeeIndex)+1]);
    xticks([0 t(burnOutIndex) t(apogeeIndex)]);
    grid on
    scaleLims(0.1);

    nextPlot();
    massFlow = gradient(propellantMass, t);
    plot(t, massFlow, 'HandleVisibility','off')
    hold on
    plot(t(apogeeIndex), massFlow(apogeeIndex), 'b*', 'DisplayName', 'Apogee')
    plot(t(burnOutIndex), massFlow(burnOutIndex), 'ro', 'DisplayName', 'Burnout')
    xlabel("time [s]");
    xlim([-1 t(apogeeIndex)+1]);
    xticks([0 t(burnOutIndex) t(apogeeIndex)]);
    ylabel("propellant mass flow [kg/s]");
    title("Propellant mass flow over time");
    legend('show', 'Location', 'best');
    grid on
    scaleLims(0.1);
end
