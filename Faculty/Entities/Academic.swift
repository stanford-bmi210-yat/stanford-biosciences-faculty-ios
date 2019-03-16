import UIKit

public struct Academic : Decodable {
    public let id: Int
    public let fullName: String
    public let profilePicture: URL?
    public let email: String?
    public let phoneNumbers: [String]?
    public let website: String
    public let title: String
    public let homePrograms: [String]
    public let researchDescription: String
    public let researchSummary: String
    public let publications: [Publication]?
    public let similarAcademics: [Int]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case fullName = "name"
        case profilePicture = "imageAddress"
        case email = "emailAddress"
        case phoneNumbers = "phoneNumbers"
        case website = "websiteAddress"
        case title = "jobTitle"
        case homePrograms = "homePrograms"
        case researchSummary = "researchSummary"
        case researchDescription = "researchDescription"
        case publications = "publications"
        case similarAcademics = "similarProfessors"
    }
    
    public init(
        id: String,
        firstName: String,
        lastName: String,
        profilePicture: URL? = nil,
        email: String = "",
        phoneNumbers: [String] = [],
        website: String = "",
        title: String = "",
        homePrograms: [String] = [],
        currentResearch: String = "",
        researchSummary: String = "",
        recentPublications: [Publication] = [],
        relatedAcademics: [Int] = []
    ) {
        self.id = id.hashValue
        self.fullName = "\(firstName) \(lastName)"
        self.profilePicture = profilePicture
        self.email = email
        self.phoneNumbers = phoneNumbers
        self.website = website
        self.title = title
        self.homePrograms = homePrograms
        self.researchDescription = currentResearch
        self.researchSummary = researchSummary
        self.publications = recentPublications
        self.similarAcademics = relatedAcademics
    }
        
    public static let all: [Academic] = [
        .sanjiv,
        .andrew,
        .mark,
        .catherine,
        .christina,
        .hunter,
        .jonathan,
    ]

    public static let sanjiv = Academic(
        id: "sanjiv",
        firstName: "Sanjiv",
        lastName: "Gambhir",
        profilePicture: URL(string: "https://cap.stanford.edu/profiles/viewImage?profileId=3971&type=bigger&ts=1509541388615")!,
        email: "sgambhir@stanford.edu",
        phoneNumbers: ["(650) 725-2309", "(650) 725-6175"],
        website: "http://radiology.stanford.edu/", 
        title: "Virginia and D.K. Ludwig Professor for Clinical Investigation in Cancer Research and Professor, by courtesy, of Materials Science and Engineering",
        homePrograms: ["Biomedical Informatics"],
        currentResearch: """
        My laboratory is developing imaging assays to monitor fundamental cellular/molecular events in living subjects including patients. Technologies such as positron emission tomography (PET), optical (fluorescence, bioluminescence, Raman), ultrasound, and photoacoustic imaging are all under active investigation.
        
        Imaging agents for multiple modalities including small molecules, engineered proteins, and nanoparticles are under development and being clinically translated. Our goals are to detect cancer early and to better manage cancer through the use of both in vitro diagnostics and molecular imaging. Strategies are being tested in small animal models and are also clinically translated.
        
        In the early detection setting we are exploring multiple strategies that are pushing the limits of the fewest numbers of detectable cancer cells. The goal is to intercept cancer early so that patient outcomes can be markedly improved.
        
        For the management of cancer we are focused on using imaging to optimize stratification of cancer patients, predicting response to therapy, and monitoring response to therapy and recurrence. We are particularly interested in cell based therapies and immunotherapies where molecular imaging can help optimize these therapies.
        
        When we are successful the role of cost-effective diagnostics in cancer will be markedly enhanced with better patient outcomes.
        """,
        recentPublications: [
            Publication(title: "Discussions with Leaders: A Conversation Between Sam Gambhir and Johannes Czernin"),
            Publication(title: "Striatal dopamine deficits predict reductions in striatal functional connectivity in major depression: a concurrent 11C-raclopride positron emission tomography and functional magnetic resonance imaging investigation"),
            Publication(title: "Assessment of tumor redox status through (S)-4-(3-[18F]fluoropropyl)-L-glutamic acid positron emission tomography imaging of system xc- activity"),
            Publication(title: "Surface-Enhanced Raman Scattering Nanoparticles for Multiplexed Imaging of Bladder Cancer Tissue Permeability and Molecular Phenotype"),
            Publication(title: "Development and MPI tracking of novel hypoxia-targeted theranostic exosomes"),
        ],
        relatedAcademics: [
            "andrew".hashValue,
            "jonathan".hashValue,
            "hunter".hashValue,
            "catherine".hashValue,
        ]
    )
    
    public static let andrew = Academic(
        id: "andrew",
        firstName: "Andrew",
        lastName: "Gentles",
        profilePicture: URL(string: "https://cap.stanford.edu/profiles/viewImage?profileId=27065&type=bigger&ts=1538158152976")!,
        email: "andrewg@stanford.edu",
        phoneNumbers: ["(650) 725-3121"],
        website: "https://scholar.google.com/citations?user=6JO_L6wAAAAJ&hl=en",
        title: "Assistant Professor (Research) of Medicine (Biomedical Informatics) and, by courtesy, of Biomedical Data Science",
        homePrograms: ["Biomedical Informatics", "Immunology"],
        recentPublications: [
            Publication(title: "Data mining for mutation-specific targets in acute myeloid leukemia"),
            Publication(title: "GFPT2-expressing cancer-associated fibroblasts mediate metabolic reprogramming in human lung adenocarcinoma"),
            Publication(title: "The Immune Landscape of Cancer"),
            Publication(title: "Machine Learning Identifies Stemness Features Associated with Oncogenic Dedifferentiation"),
            Publication(title: "Subtype assignment of CLL based on B-cell subset associated gene signatures from normal bone marrow - A proof of concept study"),
        ],
        relatedAcademics: [
            "jonathan".hashValue,
            "hunter".hashValue,
            "catherine".hashValue,
            "sanjiv".hashValue,
        ]
    )
    
    public static let christina = Academic(
        id: "christina",
        firstName: "Christina",
        lastName: "Curtis",
        profilePicture: URL(string: "https://cap.stanford.edu/profiles/viewImage?profileId=61618&type=bigger&ts=1509498207988")!,
        email: "cncurtis@stanford.edu",
        phoneNumbers: ["(650) 498-9943"],
        website: "http://med.stanford.edu/curtislab.html",
        title: "Assistant Professor of Medicine (Oncology) and of Genetics",
        homePrograms: [
            "Biomedical Informatics",
            "Cancer Biology",
            "Genetics",
        ],
        currentResearch: """
        We are particularly interested in elucidating tumor evolutionary dynamics, novel therapeutic targets, and the genotype to phenotype map in cancer. A unifying theme of our research is to exploit ‘omic’ data derived from clinically annotated samples in robust computational frameworks coupled with iterative experimental validation in order to advance our understanding of cancer systems biology. In particular, we employ advanced genomic techniques, computational and mathematical modeling, and elegant model systems in order to:
        1) Model the evolutionary dynamics of tumor progression and therapeutic resistance
        2) Elucidate disease etiology and novel molecular targets through integrative analyses of high-throughput omic data
        3) Develop techniques for the systems-level interpretation of genotype-phenotype associations in cancer
        """,
        recentPublications: [
            Publication(title: "Clonal replacement and heterogeneity in breast tumors treated with neoadjuvant HER2-targeted therapy"),
            Publication(title: "Assessment of ERBB2/HER2 Status in HER2-Equivocal Breast Cancers by FISH and 2013/2014 ASCO-CAP Guidelines"),
            Publication(title: "Quantification of subclonal selection in cancer from bulk sequencing data (vol 50, pg 895, 2018)"),
            Publication(title: "Harnessing Tumor Evolution to Circumvent Resistance"),
            Publication(title: "Quantification of subclonal selection in cancer from bulk sequencing data"),
        ],
        relatedAcademics: [
            "andrew".hashValue,
            "jonathan".hashValue,
            "hunter".hashValue,
            "catherine".hashValue,
            "sanjiv".hashValue,
        ]
    )
    
    public static let catherine = Academic(
        id: "catherine",
        firstName: "Catherine",
        lastName: "Blish",  
        profilePicture: URL(string: "https://cap.stanford.edu/profiles/viewImage?profileId=24377&type=bigger&ts=1509497798263")!,
        email: "cblish@stanford.edu",
        phoneNumbers: ["(650) 725-5132", "(650) 725-5143"],
        website: "https://sites.stanford.edu/blishlab/",
        title: "Associate Professor of Medicine (Infectious Diseases)",
        homePrograms: [
            "Biomedical Informatics",
            "Immunology",
        ],
        currentResearch: """
        Our goal is to develop new methods to prevent and control infectious diseases through better understanding of human immunology. We have several major areas of ongoing investigation.

        Understanding the diversity and biology of human natural killer (NK) cells.
        Our interest in NK cells stems from their ability to directly lyse infected and tumor cells and to mediate antibody-dependent cellular cytotoxicity, acting as a bridge between innate and adaptive immune responses. Our recent study demonstrated that human NK cells are much more diverse than previously appreciated, with both genetic and environmental determinants. We are currently examining how this diversity is regulated and its implications for viral immunity in both healthy and diseased states.

        Defining the role of NK cells in viral immunity.
        Vaccination is one of the most effective methods to prevent morbidity and mortality related to infectious diseases, yet there are many viral infections for which durable, broadly cross-protective vaccines remain desperately needed. Recent data indicating that NK cells may be capable of immunologic memory raises the possibility that we could harness NK cells to fight viruses. Current projects in the laboratory are focused on better understanding how human NK cells recognize and control infection with HIV-1, influenza, West Nile Virus, and Epstein Barr Virus.

        Immune signatures of human pregnancy.
        Pregnant women are at icreased risk of contracting viruses including HIV and influenza, and are more susceptible to severe complications once infected. A major focus of the laboratory is to define the immune mechanisms that contribute to viral susceptibility in pregnant women. These investigations focus broadly on T cell, antibody, and NK cell responses to viruses during pregnancy, and use infection and vaccination as models. In addition, we are also studying the role of immunity in preterm birth.
        """,
        recentPublications: [
            Publication(title: "Differential Induction of IFN-alpha and Modulation of CD112 and CD54 Expression Govern the Magnitude of NK Cell IFN-gamma Response to Influenza A Viruses"),
            Publication(title: "Zika Virus Infection Induces Cranial Neural Crest Cells to Produce Cytokines at Levels Detrimental for Neurogenesis"),
            Publication(title: "Human NK cell repertoire diversity reflects immune experience and correlates with viral susceptibility"),
            Publication(title: "Enhanced natural killer-cell and T-cell responses to influenza A virus during pregnancy"),
            Publication(title: "Genetic and environmental determinants of human NK cell diversity revealed by mass cytometry"),
        ],
        relatedAcademics: [
            "andrew".hashValue,
            "jonathan".hashValue,
            "hunter".hashValue,
            "sanjiv".hashValue,
        ]
    )
    
    public static let hunter = Academic(
        id: "hunter",
        firstName: "Hunter",
        lastName: "Fraser",
        profilePicture: URL(string: "https://cap.stanford.edu/profiles/viewImage?profileId=15112&type=bigger&ts=1509505656427")!,
        email: "hbfraser@stanford.edu",
        website: "http://www.stanford.edu/group/fraserlab/",
        title: "Associate Professor of Biology",
        homePrograms: [
            "Biology",
            "Biomedical Informatics",
        ],
        recentPublications: [
            Publication(title: "Fine-mapping cis-regulatory variants in diverse human populations"),
            Publication(title: "Tissue-Specific cis-Regulatory Divergence Implicates eloF in Inhibiting Interspecies Mating in Drosophila"),
            Publication(title: "Functional Genetic Variants Revealed by Massively Parallel Precise Genome Editing"),
            Publication(title: "Pooled ChIP-Seq Links Variation in Transcription Factor Binding to Complex Disease Risk"),
            Publication(title: "Dissecting the Genetic Basis of a Complex cis-Regulatory Adaptation"),
        ],
        relatedAcademics: [
            "andrew".hashValue,
            "jonathan".hashValue,
            "catherine".hashValue,
            "sanjiv".hashValue,
        ]
    )
    
    public static let jonathan = Academic(
        id: "jonathan",
        firstName: "Jonathan",
        lastName: "Palma",
        profilePicture: URL(string: "https://cap.stanford.edu/profiles/viewImage?profileId=8571&type=bigger&ts=1509533174814")!,
        website: "http://systemsmedicine.stanford.edu/education/CI-Fellowship.html",
        title: "Clinical Associate Professor, Pediatrics - Neonatal and Developmental Medicine Clinical Associate Professor, Medicine - Biomedical Informatics Research Clinical Associate Professor, Pediatrics - Systems Medicine",
        homePrograms: ["Biomedical Informatics"],
        currentResearch: """
        I'm a Clinical Associate Professor of Pediatrics in the Division of Neonatal and Developmental Medicine at Stanford University. In addition to my clinical role is in newborn intensive care, I have an administrative appointment as Medical Director of Clinical Informatics at Stanford Children's Health. I completed a Master's in Biomedical Informatics at Stanford, became board certified in Clinical Informatics with the inaugural class in 2013, and serve as Program Director for the Stanford Clinical Informatics Fellowship program.

        My clinical informatics efforts focus on optimizing electronic workflows for neonatology providers, and my academic interests include interventional informatics to achieve examples of a learning healthcare system. I also enjoy applying technologies such as text and predictive analytics to hospital data to enhance the quality and safety of healthcare.

        I attended Davidson College and graduated cum laude from the University of Florida College of Medicine, then completed clinical training in pediatrics and neonatal-perinatal medicine at Lucile Packard Children's Hospital Stanford. During residency and fellowship my scholarly work was optimizing EMRs for neonatal care, and my Master's research was mining clinical data to predict the development of disease.
        """,
        recentPublications: [
            Publication(title: "Neonatal Informatics: Transforming Neonatal Care Through Translational Bioinformatics"),
            Publication(title: "Impact of electronic medical record integration of a handoff tool on sign-out in a newborn intensive care unit"),
            Publication(title: "Neo-Bedside monitoring Device for Integrated Neonatal Intensive Care Unit (iNICU)"),
            Publication(title: "Prenatal treatment of ornithine transcarbamylase deficiency"),
            Publication(title: "Changing Management of the Patent Ductus Arteriosus: Effect on Neonatal Outcomes and Resource Utilization"),
        ],
        relatedAcademics: [
            "andrew".hashValue,
            "hunter".hashValue,
            "catherine".hashValue,
            "sanjiv".hashValue,
        ]
    )
    
    public static let mark = Academic(
        id: "mark",
        firstName: "Mark",
        lastName: "Musen",
        profilePicture: URL(string: "https://cap.stanford.edu/profiles/viewImage?profileId=4164&type=bigger&ts=1509520535923")!,
        email: "musen@stanford.edu",
        phoneNumbers: ["(650) 725-3390"],
        website: "http://metadatacenter.org/",
        title: "Professor of Medicine (Biomedical Informatics) and of Biomedical Data Science",
        homePrograms: [
            "Biomedical Informatics",
        ],
        currentResearch: """
        Semantic technology, which makes explicit the knowledge that drives computational systems, offers great opportunities to advance biomedical science and clinical medicine. Our laboratory studies the use of semantic technology in a range of application systems.

        The Center for Expanded Data Annotation and Retrieval (CEDAR) investigates new computational approaches that use semantic technology to ease the creation of metadata to describe scientific experiments. Metadata are data about data—machine-interpretable descriptions of experimental data, of the methods used to acquire the data, of the analyses that have been performed on the data, and of the provenance of all this information. Science suffers because much of the metadata that investigators create to annotate the datasets that they archive in public repositories are incomplete and nonstandardized. CEDAR studies new methods to assist the ahoring of high-quality metadata. The goal is to improve the dissemination of scientific data and to ensure that online datasets are "explained" by rich metadata that can be interpreted by both humans and computers. The long-term goal is to aid the dissemination of scientific knowledge in machine-processable form and to create intelligent agents that can help scientists to track experimental results online, to integrate datasets, and to use public data repositories to make new discoveries.

        We see CEDAR as the first step in the deveopment of a new kind of technology to change the way in which scientific knowledge is communicated—not as prose journal articles but as computer-interpretable data and metadata. Automated systems one day will access such online "publications" to augment the capabilities of human scientists as they seek information about relevant studies and as they attempt to relate their own results to those of other investigators.

        Our laboratory has pioneered methods for the development of intelligent systems. An important element of this work has involved the use of ontologies—formal descriptions of application areas that are created in a form that can be processed by both people and computers. CEDAR uses ontologies to ensure that scientific metadata are represented in a standardized way. Our Protégé system for ontology development—now with more than 300,000 registered users—allows us to continue to explore new methods for ontology engineering and for the construction of intelligent systems.
        """,
        recentPublications: [
            Publication(title: "Interpretation of biological experiments changes with evolution of the Gene Ontology and its annotations"),
            Publication(title: "The center for expanded data annotation and retrieval"),
            Publication(title: "The Protégé Project: A Look Back and a Look Forward"),
            Publication(title: "The National Center for Biomedical Ontology"),
            Publication(title: "The CAIRR Pipeline for Submitting Standards-Compliant B and T Cell Receptor Repertoire Sequencing Studies to the National Center for Biotechnology Information Repositories"),
        ],
        relatedAcademics: [
            "andrew".hashValue,
            "jonathan".hashValue,
            "hunter".hashValue,
            "catherine".hashValue,
            "sanjiv".hashValue,
        ]
    )
    
    public var firstName: String {
        var names = fullName.components(separatedBy: " ")
        return names.removeFirst()
    }
    
    public var lastName: String {
        var names = fullName.components(separatedBy: " ")
        names.removeFirst()
        return names.joined(separator: " ")
    }
    
    public func attributedFullName(fontSize: CGFloat) -> NSAttributedString {
        let font = UIFont.systemFont(ofSize: fontSize)
        let boldFont = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        let fullName = NSMutableAttributedString(string: lastName, attributes: [.font: boldFont])
        fullName.append(NSAttributedString(string: ", ", attributes: [.font: font]))
        fullName.append(NSAttributedString(string: firstName, attributes: [.font: font]))
        return fullName
    }
}
