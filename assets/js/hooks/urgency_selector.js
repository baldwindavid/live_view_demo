export default {
  mounted() {
    let inputTarget = this.el.querySelector('[data-target="input"]');
    let optionTargets = this.el.querySelectorAll('[data-target="option"]');

    this.getActiveOption(inputTarget, optionTargets);

    for (let i = 0; i < optionTargets.length; i++) {
      let optionTarget = optionTargets[i];

      optionTarget.addEventListener("click", function(e) {
        e.preventDefault();
        inputTarget.value = optionTarget.dataset.level;
        this.getActiveOption(inputTarget, optionTargets);
      }.bind(this))
    }
  },

  getActiveOption(inputTarget, optionTargets) {
    for (let i = 0; i < optionTargets.length; i++) {
      let optionTarget = optionTargets[i];

      if(inputTarget.value == optionTarget.dataset.level) {
        optionTarget.classList.add("urgency-active");
      } else {
        optionTarget.classList.remove("urgency-active");
      }
    }
  }
}
