/**
 * Cloud Functions Entry Point — Reimbursement Hexa
 * =================================================
 * Exports all Cloud Functions from one entry file.
 * firebase.json → functions.source points to this directory.
 */

'use strict';

const admin = require('firebase-admin');

// Initialise once — guard prevents re-initialisation when modules are
// required individually (e.g. during emulator hot-reload).
if (!admin.apps.length) {
  admin.initializeApp();
}

// ── Approval Engine (notification fanout + server-authoritative approval) ────
const approvalEngine  = require('./src/approval_engine');

// ── Custom Claims & User Management ──────────────────────────────────────────
const customClaims    = require('./src/set_custom_claims');

// ── Re-export all functions ───────────────────────────────────────────────────
module.exports = {
  // Approval Engine
  approvalNotificationFanout: approvalEngine.approvalNotificationFanout,
  validateApprovalRequest:    approvalEngine.validateApprovalRequest,

  // Custom Claims / User Management
  setUserRole:          customClaims.setUserRole,
  syncRoleOnCreate:     customClaims.syncRoleOnCreate,
  revokeUserSessions:   customClaims.revokeUserSessions,
  reactivateUser:       customClaims.reactivateUser,
};
