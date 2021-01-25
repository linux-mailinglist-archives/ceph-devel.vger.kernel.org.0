Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 495EB302915
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Jan 2021 18:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731081AbhAYRiM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Jan 2021 12:38:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730935AbhAYRhs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 25 Jan 2021 12:37:48 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E65DC061786
        for <ceph-devel@vger.kernel.org>; Mon, 25 Jan 2021 09:36:53 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id gx5so19228642ejb.7
        for <ceph-devel@vger.kernel.org>; Mon, 25 Jan 2021 09:36:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z5Dij0ACz7hyUk6mycqEVtLr6JjTNUjhKm0RHsZv4vo=;
        b=REEAk21WgRPkxaUY/WbOZ+HOD4ZXJzl3vdDy8qavMs0LrViEEJc9JF4oflUWU3FKRQ
         Aveb3CHq34m/WyLvhW1Y2KH1VxqaDzkVURiD4Aq+u18o6DY7WyznIKcfuO7ptptCD3J3
         MGUOwgwRDjMeZylUCpTa2h2kuN7mpklo/lrbH3D7Il0urI8D+G14sVJ5JMyuRTKf0Sk3
         pTns/EhSsbfcDlz4a9G0vD9hoIVMsNG1JkkiNpcho1Qep9tOxzvRAR/BOV8LEWAS+JSx
         UBlHzLzUI0yRyIvKRfwM2xDcw8sR9Xvmr5KERGSgfPVOg2fwWCUtGd0iEWEjwmyVeAxq
         FuTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z5Dij0ACz7hyUk6mycqEVtLr6JjTNUjhKm0RHsZv4vo=;
        b=AR/+rWTd/T/Un3zpMz73h3wOnTUermGWyoMKjHb/c1YeOrFGsfmC+k1z4J73GiIn1E
         8Fq+fbaUgD0o7OCXmFxQD6KfsV0IscT8k8dCJbBMRab1yDOpBTVdtDf4uu4EaeayJZbP
         BlTnxMGdJuEVD3sT/QiYNreWY23DLS/pMI2e5HTnopQo5lB2E8ikTelrHsxTjmCGH45p
         87FRLOSdMe5tA93GtmQhPr/p4dLJfWHXAjJqxHJTMUpsJBMQX3sJSUgzzjm70mPEWSyR
         fNNQGMrEHgNt55mdN45cGjlK4hb/69cIc6FD4VLluiyuaqxjgWDEbHqsX1+ex+tfPuRJ
         L1CQ==
X-Gm-Message-State: AOAM533ugTsl18SuppqIgkhGp+bqnyF08DKmjBT1rvhKubbl0Oue50Kk
        KAdZBRCsUJuOEtYuKkgVStNZzof4VDU=
X-Google-Smtp-Source: ABdhPJwqjj979RW+2Tuh7p5UAqF8s2QKQikPo4IznYxDnr3ARJWmJx4mkSDvuXlAw3pG4DbvsnazFw==
X-Received: by 2002:a17:906:c00c:: with SMTP id e12mr1031811ejz.103.1611596211930;
        Mon, 25 Jan 2021 09:36:51 -0800 (PST)
Received: from kwango.local (ip-94-112-132-16.net.upcbroadband.cz. [94.112.132.16])
        by smtp.gmail.com with ESMTPSA id s13sm1338627edi.92.2021.01.25.09.36.50
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 09:36:51 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH] libceph: remove osdtimeout option entirely
Date:   Mon, 25 Jan 2021 18:36:44 +0100
Message-Id: <20210125173644.10220-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Commit 83aff95eb9d6 ("libceph: remove 'osdtimeout' option") deprecated
osdtimeout over 8 years ago, but it is still recognized.  Let's remove
it entirely.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 net/ceph/ceph_common.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index bec181181d41..97d6ea763e32 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -252,7 +252,6 @@ static int parse_fsid(const char *str, struct ceph_fsid *fsid)
  * ceph options
  */
 enum {
-	Opt_osdtimeout,
 	Opt_osdkeepalivetimeout,
 	Opt_mount_timeout,
 	Opt_osd_idle_ttl,
@@ -320,8 +319,6 @@ static const struct fs_parameter_spec ceph_parameters[] = {
 	fsparam_u32	("osd_idle_ttl",		Opt_osd_idle_ttl),
 	fsparam_u32	("osd_request_timeout",		Opt_osd_request_timeout),
 	fsparam_u32	("osdkeepalive",		Opt_osdkeepalivetimeout),
-	__fsparam	(fs_param_is_s32, "osdtimeout", Opt_osdtimeout,
-			 fs_param_deprecated, NULL),
 	fsparam_enum	("read_from_replica",		Opt_read_from_replica,
 			 ceph_param_read_from_replica),
 	fsparam_enum	("ms_mode",			Opt_ms_mode,
@@ -553,9 +550,6 @@ int ceph_parse_param(struct fs_parameter *param, struct ceph_options *opt,
 		}
 		break;
 
-	case Opt_osdtimeout:
-		warn_plog(&log, "Ignoring osdtimeout");
-		break;
 	case Opt_osdkeepalivetimeout:
 		/* 0 isn't well defined right now, reject it */
 		if (result.uint_32 < 1 || result.uint_32 > INT_MAX / 1000)
-- 
2.19.2

