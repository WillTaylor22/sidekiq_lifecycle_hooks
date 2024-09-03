
### 1.3.0

- Move to after_commit

### 1.2.0

- Added a retry in Async job where record cannot be found, in case
attempt to find record occurred too early. This can happen when the initial record creation is delayed by e.g. after_create hooks and indexes.

### 1.1.0

- Add early return in Async Job for when record cannot be found

### 1.0.0

- Public launch; no changes to code
  
### 0.9.0

- Set up Gem
