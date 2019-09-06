Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2767DAB4A4
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Sep 2019 11:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391046AbfIFJLj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 6 Sep 2019 05:11:39 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39378 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730704AbfIFJLi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 6 Sep 2019 05:11:38 -0400
Received: by mail-pf1-f195.google.com with SMTP id s12so3978213pfe.6
        for <ceph-devel@vger.kernel.org>; Fri, 06 Sep 2019 02:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=xpWyvidJb806bbWYWtjk6Vg6zuCHey/RkGeEZ4ix2/U=;
        b=YXLOnMr3+aJTgnSlXjWVO2H5m0prE1Q2i+rnUexz/opc7nHZN69/npXveZnQTw25ug
         TKIIkdgs8TMYySoVvhgvioVfp1LyhObvaEYKWqlInxXVcZvsvzt+eDD07xRRKh/dvb+6
         BdfVG8SOUSMDYMlw/ucW57WrzehIZz5r4K2F/nKVrVJL8i5ES9kvV0j7wdsOxM3vNhOg
         HsPD10FXVCRQ3IsmHnZ1mf714rYf43n3FC0aIP5A6ICAH+w3+uKZxaMSEZaVViaQAXoV
         npSetLDR15JgrSrjnF/X92j9us52uR7WNTobGwkwte9OVy94ot9c/CMyh0MVSeQfuig8
         G/QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xpWyvidJb806bbWYWtjk6Vg6zuCHey/RkGeEZ4ix2/U=;
        b=S9R2Zmce7zdechjWFOhlEuIm0iPs/xd4PEoFC6ozpMWDTNNcHEUIfjkf/KVkoBuUNn
         zw7M/GjudPXHreVvFM4JRp0wJN48kkFiWxWb5dp08yLz488VAYN+zoQ2Jo7l9IaNImUp
         cnBuZayhlblyaKtHRnQvJopHPTUUYlhYuwpEIcbNMIA9EfUEAPR1bf5CIfGsxgejNf2z
         OtRFPX6wtzZbA+V0i46vNsqEZv9J1bHQoQS831o95PtvAfh5Cwslx/eLc1VabJDUgRhb
         uFOtZUybMZnkWIrO4/1ro4yVbCbXG4jIUjMJwKfgFcXh5CU8j9sDg7CHTk2Viz6SdTto
         ejDg==
X-Gm-Message-State: APjAAAVtCTx2t4BCJTRCuAQUbzwVzbxB5oNwLITr5vc+PQ4qp5VxTfGb
        sHQQvCyu3Z662iJXRB9FsyTgN8A96p4=
X-Google-Smtp-Source: APXvYqyZuEaA9B4xS25dFOh16pYCHVetW6rn1iJe7nCS8baB5N6TU/5ARJxJv7vnAtScau9Yvn6pwQ==
X-Received: by 2002:a17:90a:148:: with SMTP id z8mr8541163pje.96.1567761097946;
        Fri, 06 Sep 2019 02:11:37 -0700 (PDT)
Received: from centos7.localdomain ([103.112.79.192])
        by smtp.gmail.com with ESMTPSA id h186sm10666569pfb.63.2019.09.06.02.11.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 02:11:37 -0700 (PDT)
From:   simon gao <simon29rock@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     simon gao <simon29rock@gmail.com>
Subject: [PATCH] add mount opt, optoauth, to force to send req to auth mds In larger clusters (hundreds of millions of files). We have to pin the directory on a fixed mds now. Some op of client use USE_ANY_MDS mode to access mds, which may result in requests being sent to noauth mds and then forwarded to authmds. the opt is used to reduce forward op.
Date:   Fri,  6 Sep 2019 05:11:28 -0400
Message-Id: <1567761088-125167-1-git-send-email-simon29rock@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

---
 fs/ceph/mds_client.c | 7 ++++++-
 fs/ceph/super.c      | 7 +++++++
 fs/ceph/super.h      | 1 +
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 920e9f0..3574e8f 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -878,6 +878,7 @@ static struct inode *get_nonsnap_parent(struct dentry *dentry)
 static int __choose_mds(struct ceph_mds_client *mdsc,
 			struct ceph_mds_request *req)
 {
+	struct ceph_mount_options *ma = mdsc->fsc->mount_options;
 	struct inode *inode;
 	struct ceph_inode_info *ci;
 	struct ceph_cap *cap;
@@ -900,7 +901,11 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
 
 	if (mode == USE_RANDOM_MDS)
 		goto random;
-
+	// force to send the req to auth mds
+	if (ma->flags & CEPH_MOUNT_OPT_OPTOAUTH && mode != USE_AUTH_MDS){
+		dout("change mode %d => USE_AUTH_MDS", mode);
+		mode = USE_AUTH_MDS;
+	}
 	inode = NULL;
 	if (req->r_inode) {
 		if (ceph_snap(req->r_inode) != CEPH_SNAPDIR) {
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index ab4868c..fbe8e2f 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -169,6 +169,7 @@ enum {
 	Opt_noquotadf,
 	Opt_copyfrom,
 	Opt_nocopyfrom,
+	Opt_optoauth,
 };
 
 static match_table_t fsopt_tokens = {
@@ -210,6 +211,7 @@ enum {
 	{Opt_noquotadf, "noquotadf"},
 	{Opt_copyfrom, "copyfrom"},
 	{Opt_nocopyfrom, "nocopyfrom"},
+	{Opt_optoauth, "optoauth"},
 	{-1, NULL}
 };
 
@@ -381,6 +383,9 @@ static int parse_fsopt_token(char *c, void *private)
 	case Opt_noacl:
 		fsopt->sb_flags &= ~SB_POSIXACL;
 		break;
+	case Opt_optoauth:
+		fsopt->flags |= CEPH_MOUNT_OPT_OPTOAUTH;
+		break;
 	default:
 		BUG_ON(token);
 	}
@@ -563,6 +568,8 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
 		seq_puts(m, ",nopoolperm");
 	if (fsopt->flags & CEPH_MOUNT_OPT_NOQUOTADF)
 		seq_puts(m, ",noquotadf");
+	if (fsopt->flags & CEPH_MOUNT_OPT_OPTOAUTH)
+		seq_puts(m, ",optoauth");
 
 #ifdef CONFIG_CEPH_FS_POSIX_ACL
 	if (fsopt->sb_flags & SB_POSIXACL)
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 6b9f1ee..2710d5b 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -41,6 +41,7 @@
 #define CEPH_MOUNT_OPT_MOUNTWAIT       (1<<12) /* mount waits if no mds is up */
 #define CEPH_MOUNT_OPT_NOQUOTADF       (1<<13) /* no root dir quota in statfs */
 #define CEPH_MOUNT_OPT_NOCOPYFROM      (1<<14) /* don't use RADOS 'copy-from' op */
+#define CEPH_MOUNT_OPT_OPTOAUTH        (1<<15) /* send op to auth mds, not to replicative mds */
 
 #define CEPH_MOUNT_OPT_DEFAULT			\
 	(CEPH_MOUNT_OPT_DCACHE |		\
-- 
1.8.3.1

