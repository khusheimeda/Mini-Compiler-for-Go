print("You can view 4 different optimization!")
print("Please enter your choice")
print("1.To view code motion: Please enter code_motion")
print("2.To view dead code elimination: Please enter dead_code")
print("3.To view common subexpression elimination: Please enter sub_exp")
print("4.To view constant folding and propogation: Please enter constfp")
op=input()

import loop_invar_codeop as LIC
import dead_codeop as DCO
import subexpression as SBE
import constfp as CFP

if op=="code_motion":
    LIC.lic()
    print("Code motion optimisation result is present in code_motion.txt")

elif op=="dead_code":
    DCO.dco()
    print("Dead code optimisation result is present in deadcode_optimised.txt")

elif op=="sub_exp":
    SBE.sbe()
    print("Subexpression code optimisation result is present in subexpression.txt")

elif op=="constfp":
    CFP.cfp()
    print("Subexpression code optimisation result is present in const_fp.txt")

