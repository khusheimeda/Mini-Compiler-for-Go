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

