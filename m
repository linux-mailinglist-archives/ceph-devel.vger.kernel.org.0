Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83DAA4D4C54
	for <lists+ceph-devel@lfdr.de>; Thu, 10 Mar 2022 16:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244944AbiCJOzD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 10 Mar 2022 09:55:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344330AbiCJOkl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 10 Mar 2022 09:40:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AE9D9182BEB
        for <ceph-devel@vger.kernel.org>; Thu, 10 Mar 2022 06:34:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646922870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CN5BNqt5dWrHtULY6r3EZ5iyr46VFZX3QibKYE6HxEg=;
        b=M6wR3OC61Tc6FEeKOZQ8DSE1819e5gfXtwsMZzhscXgYjC4er5bYjG4HDjFq3GSCCSlUCL
        H/fsfqTjE9hOpeU2Ha+3q9uJYAWtWpwnUQvsOj5YGjQPgQKqx61MK8Rr+PxQ9Cy6YlZ3NJ
        z2Slfdx3bQQ36ZTJknq4sUcBKpYmlR0=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-171-PQ1WS5lfNMOc_DyrlYqJdQ-1; Thu, 10 Mar 2022 09:34:30 -0500
X-MC-Unique: PQ1WS5lfNMOc_DyrlYqJdQ-1
Received: by mail-pj1-f71.google.com with SMTP id b9-20020a17090aa58900b001b8b14b4aabso3392430pjq.9
        for <ceph-devel@vger.kernel.org>; Thu, 10 Mar 2022 06:34:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CN5BNqt5dWrHtULY6r3EZ5iyr46VFZX3QibKYE6HxEg=;
        b=FnHUjx8K7pvH+7uUm8R6n37S2U77JSqP35DwD1SDYaa7HSnkVf18nBCYAbdGUHfR5R
         DG2GqbGv1azcyYugN7YM+obCdhKfIgmeng+f72qYuibCBO4Hf0J8sFu+sGOSzx717gJ0
         9kSCmWa8Vum1cCWNVA2EkwyzQo1TGVcpr0vNddY0Z8OX/mDNzMn5EbQ9vi5qTzVIDoRz
         Ys+LKImv49rN+Q3g4oEP+pyXYZwSETK7Ga+c9t/CFqr2myifk1yZ9s2DL4d4fpGp0kT4
         MzYwu96wMkkOPRCxnVPSEs/WczGAlxwsk4dWS1Yjii7+gC91T1nHfHZwfp4Ml+1QGYmO
         hxOg==
X-Gm-Message-State: AOAM531EBcjMKEPMsAEoTdsXNrfJfxIEqL1gYtcn3uAVyJ4MR3ZhxeY7
        OvqQskAqfVug/tT3u+x1paJEgBXwi8TVgPxrJ6PCjVzeEeMfs/Wn65XlegWFYIoDhDxE0CxPR/G
        b+ZqNKJSz9VqiyGyqqjW1lQ==
X-Received: by 2002:a17:902:f686:b0:151:d866:f657 with SMTP id l6-20020a170902f68600b00151d866f657mr5211488plg.112.1646922868026;
        Thu, 10 Mar 2022 06:34:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx7CnAFvFFQtqrCqPGxiL8Rg12ZAwTjCSzjgt0omeUwOongIEEibfLqWRrBGwcmNjKZZmSWWQ==
X-Received: by 2002:a17:902:f686:b0:151:d866:f657 with SMTP id l6-20020a170902f68600b00151d866f657mr5211469plg.112.1646922867817;
        Thu, 10 Mar 2022 06:34:27 -0800 (PST)
Received: from localhost.localdomain ([124.123.80.180])
        by smtp.gmail.com with ESMTPSA id n24-20020a637218000000b0037ffc63b98csm5737904pgc.65.2022.03.10.06.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 06:34:27 -0800 (PST)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, idryomov@gmail.com
Cc:     xiubli@redhat.com, ceph-devel@vger.kernel.org,
        Venky Shankar <vshankar@redhat.com>
Subject: [PATCH] ceph: allow `ceph.dir.rctime' xattr to be updatable
Date:   Thu, 10 Mar 2022 09:34:19 -0500
Message-Id: <20220310143419.14284-1-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

`rctime' has been a pain point in cephfs due to its buggy
nature - inconsistent values reported and those sorts.
Fixing rctime is non-trivial needing an overall redesign
of the entire nested statistics infrastructure.

As a workaround, PR

     http://github.com/ceph/ceph/pull/37938

allows this extended attribute to be manually set. This allows
users to "fixup" inconsistency rctime values. While this sounds
messy, its probably the wisest approach allowing users/scripts
to workaround buggy rctime values.

The above PR enables Ceph MDS to allow manually setting
rctime extended attribute with the corresponding user-land
changes. We may as well allow the same to be done via kclient
for parity.

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 fs/ceph/xattr.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index afec84088471..8c2dc2c762a4 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -366,6 +366,14 @@ static ssize_t ceph_vxattrcb_auth_mds(struct ceph_inode_info *ci,
 	}
 #define XATTR_RSTAT_FIELD(_type, _name)			\
 	XATTR_NAME_CEPH(_type, _name, VXATTR_FLAG_RSTAT)
+#define XATTR_RSTAT_FIELD_UPDATABLE(_type, _name)			\
+	{								\
+		.name = CEPH_XATTR_NAME(_type, _name),			\
+		.name_size = sizeof (CEPH_XATTR_NAME(_type, _name)),	\
+		.getxattr_cb = ceph_vxattrcb_ ## _type ## _ ## _name,	\
+		.exists_cb = NULL,					\
+		.flags = VXATTR_FLAG_RSTAT,				\
+	}
 #define XATTR_LAYOUT_FIELD(_type, _name, _field)			\
 	{								\
 		.name = CEPH_XATTR_NAME2(_type, _name, _field),	\
@@ -404,7 +412,7 @@ static struct ceph_vxattr ceph_dir_vxattrs[] = {
 	XATTR_RSTAT_FIELD(dir, rsubdirs),
 	XATTR_RSTAT_FIELD(dir, rsnaps),
 	XATTR_RSTAT_FIELD(dir, rbytes),
-	XATTR_RSTAT_FIELD(dir, rctime),
+	XATTR_RSTAT_FIELD_UPDATABLE(dir, rctime),
 	{
 		.name = "ceph.dir.pin",
 		.name_size = sizeof("ceph.dir.pin"),
-- 
2.31.1

