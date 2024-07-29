import sys
import os
import subprocess
from PyQt5.QtWidgets import QApplication, QMainWindow, QPushButton, QTextEdit, QVBoxLayout, QWidget
from PyQt5.QtCore import QThread, pyqtSignal

class MiningThread(QThread):
    output = pyqtSignal(str)
    error = pyqtSignal(str)

    def __init__(self):
        super().__init__()
        self.process = None

    def run(self):
        self.process = subprocess.Popen(
            [sys.executable, "FACTOR.py"],  # Adjust this to the path of your mining script
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            universal_newlines=True
        )
        while True:
            output = self.process.stdout.readline()
            if output:
                self.output.emit(output)
            err = self.process.stderr.readline()
            if err:
                self.error.emit(err)
            if output == '' and self.process.poll() is not None:
                break

    def stop(self):
        if self.process:
            self.process.terminate()
            self.process.wait()

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Mining Application")
        self.setGeometry(100, 100, 800, 600)

        self.mining_thread = MiningThread()
        self.mining_thread.output.connect(self.update_log)
        self.mining_thread.error.connect(self.update_log)

        self.start_button = QPushButton("Start Mining")
        self.start_button.clicked.connect(self.start_mining)

        self.stop_button = QPushButton("Stop Mining")
        self.stop_button.clicked.connect(self.stop_mining)
        self.stop_button.setEnabled(False)

        self.log_area = QTextEdit()
        self.log_area.setReadOnly(True)

        layout = QVBoxLayout()
        layout.addWidget(self.start_button)
        layout.addWidget(self.stop_button)
        layout.addWidget(self.log_area)

        container = QWidget()
        container.setLayout(layout)
        self.setCentralWidget(container)

    def start_mining(self):
        self.log_area.append("Starting mining process...")
        self.mining_thread.start()
        self.start_button.setEnabled(False)
        self.stop_button.setEnabled(True)

    def stop_mining(self):
        self.log_area.append("Stopping mining process...")
        self.mining_thread.stop()
        self.start_button.setEnabled(True)
        self.stop_button.setEnabled(False)

    def update_log(self, message):
        self.log_area.append(message)

if __name__ == "__main__":
    app = QApplication(sys.argv)
    main_window = MainWindow()
    main_window.show()
    sys.exit(app.exec_())
