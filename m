Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7F4F177BCB
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Mar 2020 17:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730349AbgCCQVo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 3 Mar 2020 11:21:44 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38561 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730293AbgCCQVo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 3 Mar 2020 11:21:44 -0500
Received: by mail-pl1-f193.google.com with SMTP id p7so1525426pli.5;
        Tue, 03 Mar 2020 08:21:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YUcw1KG3qrvpleqzqQ7xyhNdpovGgPoy1w9JlReaGGk=;
        b=BC+IQYQA/hBOYJ9q/YG9kdpBsF9+tMbOpFAGLQ2bWvsY4KF4P8Q+dmAdfU78cGhWRP
         0Yxb8itlOvfnGtQaxf24HMBU0W14RPWxsokNwDs/dq76dyyJgqpvzw/D1xUxklvYK2we
         UsS7KyvnvsXHaryzWGaxrGsMMrMsuArNfDU0h2E5R/sSvDtC3mvWmFUgPefDylr8UM2H
         2cFqcrsibwblgR/8oYvQv+l7vIoaFxAfssROdh/0L9Icc0f6zwhhXRu0AkbmV5qw4RuL
         6/M0mmbl7EATwVYKzZKzISeWeoPWdR7ObS2z2FHaZU8Issvet4l7kGGWOWQ6w2xKeV+i
         GwwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YUcw1KG3qrvpleqzqQ7xyhNdpovGgPoy1w9JlReaGGk=;
        b=tfIzW6LnKwTjOAixXxjIrJLerLv7si7NgB6v3p5CoOxh1/Yur5ff5ysvy7hKa9PGFy
         5VJAo69JRopUW/ibKH6p++4I4djx3EfA1pcGQt+ocD57ucHoK14obbvwMhE2wocgNmuk
         y2YbabGQYexUDDBEYnNlQJWzYRlXmtNSF19D35+4x5wTBCrYq95UDeoMHx5IOgfhiEAc
         1qh3QeOCyHIh2v4eAeph2yBXctSnJdHlAtwVkD4piOQY9TWN6w72TcVNQbRar6x7KXMq
         C//WqAALBDrPz4+EtYcb7Ts+g+sPzdbmuwbMjos4Ou58rQKrOcvWA/lK0DAlnVFxvkF8
         Mt1A==
X-Gm-Message-State: ANhLgQ1JCtDsLoPVTbG77CHz9yzLp0Buai5oiRWx/lga7IRes1DnqIkx
        LZz95nO4RcdIy+7JEGUrWPg=
X-Google-Smtp-Source: ADFU+vuQE+daBK6NDgfu/5VCFw3gGgq2P1GTkZidJo5iBwRZDSbepe/pFLzyshwwWENLrs60uTEfdw==
X-Received: by 2002:a17:902:c086:: with SMTP id j6mr5071986pld.46.1583252503458;
        Tue, 03 Mar 2020 08:21:43 -0800 (PST)
Received: from VM_0_35_centos.localdomain ([150.109.62.251])
        by smtp.gmail.com with ESMTPSA id i5sm6833123pfo.173.2020.03.03.08.21.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Mar 2020 08:21:42 -0800 (PST)
From:   Qiujun Huang <hqjagain@gmail.com>
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>
Subject: [PATCH] fs/ceph/export: remove unused variable 'err'
Date:   Wed,  4 Mar 2020 00:21:39 +0800
Message-Id: <1583252499-16078-1-git-send-email-hqjagain@gmail.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

fix gcc '-Wunused-but-set-variable' warning:
fs/ceph/export.c: In function ‘__get_parent’:
fs/ceph/export.c:294:6: warning: variable ‘err’ set but not used [-Wunused-but-set-variable]
  int err;

and needn't use the return value of ceph_mdsc_create_request.

Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
---
 fs/ceph/export.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ceph/export.c b/fs/ceph/export.c
index b6bfa94..b7bb41c 100644
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -291,7 +291,6 @@ static struct dentry *__get_parent(struct super_block *sb,
 	struct ceph_mds_request *req;
 	struct inode *inode;
 	int mask;
-	int err;
 
 	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPPARENT,
 				       USE_ANY_MDS);
@@ -314,7 +313,7 @@ static struct dentry *__get_parent(struct super_block *sb,
 	req->r_args.getattr.mask = cpu_to_le32(mask);
 
 	req->r_num_caps = 1;
-	err = ceph_mdsc_do_request(mdsc, NULL, req);
+	ceph_mdsc_do_request(mdsc, NULL, req);
 	inode = req->r_target_inode;
 	if (inode)
 		ihold(inode);
-- 
1.8.3.1

