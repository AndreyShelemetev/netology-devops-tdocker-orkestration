#Инструкция по созданию и запуску ansible playbook для создания docker на ВМ
# Если скрипт ещё не создан, создаём его
nano setup_ansible.sh
# (вставь туда содержимое скрипта)
# Сохрани: Ctrl+O → Enter → Ctrl+X

# Делаем скрипт исполняемым
chmod +x setup_ansible.sh

# Запускаем скрипт
./setup_ansible.sh

# Переходим в созданную папку проекта
cd ~/ansible_project

# Проверяем структуру
ls -R

# Запускаем плейбук для установки Docker
ansible-playbook playbooks/install_docker.yml
