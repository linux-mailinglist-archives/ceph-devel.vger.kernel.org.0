Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A89E417B3D0
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Mar 2020 02:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgCFBe0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 Mar 2020 20:34:26 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38864 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbgCFBe0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 Mar 2020 20:34:26 -0500
Received: by mail-pf1-f195.google.com with SMTP id g21so274185pfb.5;
        Thu, 05 Mar 2020 17:34:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=POKsK2Sr9GyNeTFElca9dR7uYX4ViPPFrczK7S6aa5U=;
        b=RAlOMTuEDpcSmH4mA48Ys8JRgeW29/dLcFi8XwipfyaZazSxjQXkSQWWaaQgoUoVJb
         g+nh3sW2uE+G9sI90suZA0XCHohnVA4WmtJ/Z/aJ6ydpDTcef6jhTp0gK05J4LAQtPh8
         h0LrwQVrykgXh7rK90UoNVDO7EEIiquEAdcZVf9bo/qUXxy9OicyfJ4GcctiD4vm67pq
         dvDubxICLYXCZeexif1zjZ9UOg6OG20/EXaX6FGHUx1okT3dFX+FnS9+2JiFZ8UQNoSl
         vrpS7mc3O/9Hxjd+9EUrEkEtbHG+1Q0IivYeN0Ceq0oL+6svYbowHIg0p4h8UACKtLSD
         3ySQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=POKsK2Sr9GyNeTFElca9dR7uYX4ViPPFrczK7S6aa5U=;
        b=oBiIYcvTqpGPfqQNeC28TvefNQOxw87NZ8kP6ve00Fk8u8m7fyZ6S0IqC/DRGpR1fM
         7zkisgc0LcazRgYJpEK+Jjc1jPf6fNnhTvqGowJQEdUR3gHQPQgaRvO7tK3iRs5zaog9
         uMKeGoA4+F8+NM4UhvryvqK0DVpn3XMXlkY/ELplBkXDpeZr8N5fMcnuyXWhbs9NoQ0u
         o+5FF+Tx9kXqYksAmavRrf9ZC0j8NBz71Is4eoW6b9sQoyuOavfKNTJjss7lKYt+OkKX
         Hg6FZ+ENC1xv9tUscz3aDqu0s7h8Q0dQGJ1zcmOeiv/GyKM/jIWZVoJMF2qi6W/SCI5w
         kHRg==
X-Gm-Message-State: ANhLgQ3tKLXTBl2AsyNcvLndvdHm4EsmBRDMazd9WmeOcRlFFAYSnyex
        S5MONt3heVWT7jh8frqJz34=
X-Google-Smtp-Source: ADFU+vtfHGO7fe8MY0Sf8i1ebOzyUkWQy0VZIylh1JiwuOKOaEfsmdy4VdYfCog6rovza5nlxFHROg==
X-Received: by 2002:a63:34c8:: with SMTP id b191mr992562pga.220.1583458465328;
        Thu, 05 Mar 2020 17:34:25 -0800 (PST)
Received: from VM_0_35_centos.localdomain ([150.109.62.251])
        by smtp.gmail.com with ESMTPSA id u12sm27124952pgh.52.2020.03.05.17.34.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Mar 2020 17:34:24 -0800 (PST)
From:   Qiujun Huang <hqjagain@gmail.com>
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>
Subject: [PATCH] fs/ceph: return errcode in __get_parent().
Date:   Fri,  6 Mar 2020 09:34:20 +0800
Message-Id: <1583458460-31917-1-git-send-email-hqjagain@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

return real errcode when it's different from ENOENT.

Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
---
 fs/ceph/export.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ceph/export.c b/fs/ceph/export.c
index b6bfa94..79dc068 100644
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -315,6 +315,11 @@ static struct dentry *__get_parent(struct super_block *sb,
 
 	req->r_num_caps = 1;
 	err = ceph_mdsc_do_request(mdsc, NULL, req);
+	if (err) {
+		ceph_mdsc_put_request(req);
+		return ERR_PTR(err);
+	}
+
 	inode = req->r_target_inode;
 	if (inode)
 		ihold(inode);
-- 
1.8.3.1

