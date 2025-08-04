Return-Path: <ceph-devel+bounces-3349-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12C11B19F21
	for <lists+ceph-devel@lfdr.de>; Mon,  4 Aug 2025 12:00:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4BE01163918
	for <lists+ceph-devel@lfdr.de>; Mon,  4 Aug 2025 10:00:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75B292459D4;
	Mon,  4 Aug 2025 09:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bfI5WJ0v"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2941C6FF5
	for <ceph-devel@vger.kernel.org>; Mon,  4 Aug 2025 09:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754301595; cv=none; b=CsDaDIitT0ZIvlkoO4S2eaEcD3N2JpMxAZqGE40jYrGLt+0Gdag6nide/hgyHpBfomLP47TmEgLlDr0/vVXPoYRxREjNPX8c7ES6ep969F9gTsgM4vdm9ExIY9MndjrHLVgjnYAWN5VH7OKPH6Qtk8GxPvwmHPSVOb1DFcgIlg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754301595; c=relaxed/simple;
	bh=86xZu00+UDnBPH6MuEJGYfj4bcSnDnN94cUc+QXGuL8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Xn1+4U193EIGqijjbz/Y2bhLVrMifMUs/zas42eI25bcBsewU5vlTW8uB3yYz/CSToWkEhDYNTKitrl39YdDNnyHr3zwz64D/Zo5afowJszbzilVSgOZjV8WU2Ryc6LR5cjewXUQXnRSM6ENUt/U+RbMr1bKyI7EhKQj9vRK9Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bfI5WJ0v; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754301591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hNbEQ0dntB4TZw05j2S92XHQV8iXE8KzN/fVBin+25o=;
	b=bfI5WJ0vnSLQQjdIBc7CG7Yn54hav066w2wPoFPvGIdSKcsmZXb5Q6GUbTpAA3nFjbEHnh
	HwQR5MSffS8aadX5EJ1bJAKGqUz0bsjdcwZRGkZBdZ8W8HLrbp5StAEurjHRDldXjKFsn9
	b5AD4rVtAjEmlFTNbR1iqcjcJEVQRPw=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-282-V_1hn4HRMaaktKSQFF0MdQ-1; Mon, 04 Aug 2025 05:59:50 -0400
X-MC-Unique: V_1hn4HRMaaktKSQFF0MdQ-1
X-Mimecast-MFC-AGG-ID: V_1hn4HRMaaktKSQFF0MdQ_1754301589
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-af94c842282so171520466b.1
        for <ceph-devel@vger.kernel.org>; Mon, 04 Aug 2025 02:59:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754301589; x=1754906389;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hNbEQ0dntB4TZw05j2S92XHQV8iXE8KzN/fVBin+25o=;
        b=sJpvF9ZGsPChrvht7Knx/n2X/YIPumbA4G1Ohn81S9ZDAJZfeWfDsFV0bklUR3a7vF
         r0G2eKsx+q5DKcXoAgcH8HEcLk8tiV628r0+72cI20sQD1hHx78lS0lgPSunIvhPntgX
         SneT8rE97WZ5hfcmq2O+Va19V91h7RyQzvCVsVbB9LrcoUkd9dgDl0Uk+gCqQBtLg9+/
         eqypgPiiNMMjSDeH59TmPOn8WqjxDTauJE3kEVIehJarUnFFowSGxAT3CHdroi1/5C2a
         wcQL2mHJRwd+1hPS9JgBjSt5ZkJcVKDnRhJBbRksKOBJz+UW0vjwA//puOqkFw7XECxn
         XVcA==
X-Gm-Message-State: AOJu0Yy3Gjq1aSN/bEMm0kNY0/dM050ocxFpgxTaTeUvUmOsqrIy7rHW
	YunpaimfEq3pg+MfsxI4h4cDviaX1UG4W8b0XGdjmCS/bgPoK1ceGS+UoBxYz3how2xe4+ivBAd
	ktaBzO7HK5kdsnY2axu7WXGvKUGO45hL/FeSOOsZiC5AMd6bf9qHuhyQ5Od07DODSrQkWgeyMgA
	4PkyhcQgdb/U2EJP+Hqxt35+EmaR8XnojtP9btmRpQCEjeg1iL2A==
X-Gm-Gg: ASbGncuVXb2ErxEok6CxeAjkCfk4ZUfncLZyAyCcI4GNDx/iEQto7Hkx2y+T5EmPt39
	4WYbccyvZWA4NgMLq3JplEqNKjTQZ1hZF18htB0DyKBPTK/IqO8HlQuRJIvxCpx6/dSIaH/pRSO
	IalzI9ijOwsJoDf+Y0JoD7LmCoiOn/Zf8b/eZTRTapNyeKiLna1gTEZktApZ+pjtCX2vgad+8KR
	64UU26qi4XmWDvj0E+DlX44tmQWO3A0NwX59KZ0vblXEWTw1HqB3kfOLHITW2ZLYbfyZaiz61Du
	ux00V8qQZzHT1vns7vWt7+KdhGEOlYmX4jUdlMZAYbBlRwdiZBrzZkPtfv/oostw7wyPr6LApQ=
	=
X-Received: by 2002:a17:907:7fa8:b0:ae9:a1f1:2b7d with SMTP id a640c23a62f3a-af94000b3f2mr831448166b.17.1754301589223;
        Mon, 04 Aug 2025 02:59:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHb2HHPuXvQ2LMWAETW8wVTYltytg19lKiAeoJsOqTr346zSwvOEP8YFFHQOXGIR1fQ3Fgsnw==
X-Received: by 2002:a17:907:7fa8:b0:ae9:a1f1:2b7d with SMTP id a640c23a62f3a-af94000b3f2mr831445566b.17.1754301588728;
        Mon, 04 Aug 2025 02:59:48 -0700 (PDT)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a078bcbsm715458766b.13.2025.08.04.02.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 02:59:48 -0700 (PDT)
From: Alex Markuze <amarkuze@redhat.com>
To: ceph-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Slava.Dubeyko@ibm.com,
	idryomov@gmail.com,
	Alex Markuze <amarkuze@redhat.com>
Subject: [PATCH 0/2] ceph: Fix r_parent staleness race and related deadlock
Date: Mon,  4 Aug 2025 09:59:40 +0000
Message-Id: <20250804095942.2167541-1-amarkuze@redhat.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This patchset addresses two related issues in CephFS client request handling.

**Patch 1/2 ("ceph: fix client race condition where r_parent becomes stale before sending message")**

This patch fixes a race condition where the `req->r_parent` inode reference can become stale. Under specific conditions (e.g., expired dentry leases), the client can perform lockless lookups, creating a window where a concurrent `rename` operation can invalidate `req->r_parent` between initial VFS lookup and MDS request message creation. The MDS reply handler (`create_request_message`) previously trusted the cached `r_parent` without verification. This patch enhances path-building functions to track the full `ceph_vino` and adds a validation step in `create_request_message` to compare and correct `req->r_parent` if a mismatch is detected (when the parent wasn't locked).

**Patch 2/2 ("ceph: fix deadlock in ceph_readdir_prepopulate due to snap_rwsem")**

This patch fixes a deadlock in `ceph_readdir_prepopulate`. The function holds `mdsc->snap_rwsem` (read lock) while calling `ceph_get_inode`, which can potentially block on inode operations that might require the `snap_rwsem` write lock, leading to a classic reader/writer deadlock. This patch releases `mdsc->snap_rwsem` before calling `ceph_get_inode` and re-acquires it afterwards, breaking the deadlock cycle.

Together, these patches improve the robustness and stability of CephFS client request handling by fixing a correctness race and a critical deadlock.


Alex Markuze (2):
  ceph: fix client race condition validating r_parent before applying
    state
  ceph: fix client race condition where r_parent becomes stale before
    sending message

 fs/ceph/inode.c      | 44 +++++++++++++++++++++++++++--
 fs/ceph/mds_client.c | 67 +++++++++++++++++++++++++++++++-------------
 2 files changed, 89 insertions(+), 22 deletions(-)

-- 
2.34.1


