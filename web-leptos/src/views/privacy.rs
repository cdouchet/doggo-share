use leptos::*;
use leptos_dom::*;

#[component]
pub fn Privacy(cx: Scope) -> impl IntoView {
    view! {
        cx,
        <div id="privacy-wrapper">
            <h2>"Politique de confidentialité de Doggo Share"</h2>
            <p>"Dernière mise à jour : 02/02/2024\n

            Bienvenue dans Doggo Share (ci-après dénommée \"nous\", \"notre\", \"nos\" ou \"l'Application\"). La présente Politique de confidentialité régit la manière dont Doggo Share collecte, utilise, traite et partage les informations personnelles des utilisateurs de l'Application\n\n."</p>
            <h2>"Informations collectées"</h2>
            <p>"Nous ne collectons aucune information lorsque vous utilisez Doggo Share"</p>

            <h2>"Comment nous stockons vos fichiers"</h2>
            <p>"Depuis l'application vous pouvez partager des fichiers en partageant un lien unique. Vos fichiers sont cryptés pendant le tranfert (TLS). Une fois stockés, ils sont disponibles à toute personne possédant le lien associé. Au bout de 5 jours, vos fichiers sont automatiquement supprimés"</p>

            <h2>"Sécurité des informations"</h2>
            <p>"Nous mettons en place des mesures de sécurité appropriées pour protéger vos informations personnelles contre tout accès non autorisé, divulgation, altération ou destruction."</p>

            <h2>"Contactez-nous"</h2>
            <p>"Si vous avez des questions ou des préoccupations concernant cette politique de confidentialité, veuillez nous contacter à cyril.douchet@gmail.com.\n

            En utilisant Doggo Share, vous acceptez les termes de la présente Politique de confidentialité."
            </p>
        </div>
    }
}
