from setuptools import find_packages, setup

tests_requirements = [
    'pytest',
    'pytest-cov',
    'pytest-flake8',
    'pytest-isort',
]

setup(
    name='babyte',
    author='Kozea',
    packages=find_packages(),
    include_package_data=True,
    scripts=['babyte/babyte.py'],
    install_requires=[
        'flask',
	    'oauth2client'
    ],
    tests_require=tests_requirements,
    extras_require={'test':tests_requirements}
)
