@testset "Gas-Power Flow Problems" begin
    @testset "Quadratic Programming (QP) Formulation" begin
        # Set up problem metadata.
        g_file = "../test/data/matgas/GasLib-11-GPF.m"
        p_file = "../test/data/matpower/case5-GPF.m"
        g_type, p_type = MISOCPGasModel, SOCWRPowerModel

        # Solve the gas-power flow feasibility problem.
        result = run_gpf(g_file, p_file, g_type, p_type, juniper;
            gm_solution_processors=[_GM.sol_psqr_to_p!],
            pm_solution_processors=[_PM.sol_data_model!])

        # Ensure the problem has been solved to local optimality.
        @test result["termination_status"] == LOCALLY_SOLVED
        @test isapprox(result["objective"], 0.0, atol=1.0e-6)
        @test all([x["p"] >= 0.0 for (i, x) in result["solution"]["junction"]])
        @test all([x["vm"] >= 0.0 for (i, x) in result["solution"]["bus"]])
    end

    @testset "Nonlinear Programming (NLP) Formulation" begin
        # Set up problem metadata.
        g_file = "../test/data/matgas/GasLib-11-GPF.m"
        p_file = "../test/data/matpower/case5-GPF.m"
        g_type, p_type = MINLPGasModel, SOCWRPowerModel

        # Solve the gas-power flow feasibility problem.
        result = run_gpf(g_file, p_file, g_type, p_type, juniper;
            gm_solution_processors=[_GM.sol_psqr_to_p!],
            pm_solution_processors=[_PM.sol_data_model!])

        # Ensure the problem has been solved to local optimality.
        @test result["termination_status"] == LOCALLY_SOLVED
        @test isapprox(result["objective"], 0.0, atol=1.0e-6)
        @test all([x["p"] >= 0.0 for (i, x) in result["solution"]["junction"]])
        @test all([x["vm"] >= 0.0 for (i, x) in result["solution"]["bus"]])
    end
end

