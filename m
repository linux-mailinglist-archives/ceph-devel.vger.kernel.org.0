Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 197A660DBD0
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Oct 2022 09:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbiJZHEp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Oct 2022 03:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232877AbiJZHEn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Oct 2022 03:04:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BADF01E704
        for <ceph-devel@vger.kernel.org>; Wed, 26 Oct 2022 00:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666767881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SeJSPlggwLcEGuFn4uVOI2x1ghjxx298ul0WzaKRZHc=;
        b=WaMU/55t9ffVVY8ykS9iL7JJURgezEuDGaQUyTHQO2cZ6254SQXpWk8c1Q+pDkBhyrEoqx
        Fe+FULNLuzpIbJwhworEKDhPhAJuk0SNOcZRWtZuSB+u26ercdBeiFD9vI36y3ZcbmYw33
        tszbe7+jeED39D+jAxOzscq8YsEi04U=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-258-osDjOzsBMveWXr_tFGlVUw-1; Wed, 26 Oct 2022 03:04:35 -0400
X-MC-Unique: osDjOzsBMveWXr_tFGlVUw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD12D3C0F7EE;
        Wed, 26 Oct 2022 07:04:34 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AE0491415117;
        Wed, 26 Oct 2022 07:04:31 +0000 (UTC)
From:   xiubli@redhat.com
To:     fstests@vger.kernel.org
Cc:     david@fromorbit.com, djwong@kernel.org, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 1/2] encrypt: rename _scratch_mkfs_encrypted to _scratch_check_encrypted
Date:   Wed, 26 Oct 2022 15:04:17 +0800
Message-Id: <20221026070418.259351-2-xiubli@redhat.com>
In-Reply-To: <20221026070418.259351-1-xiubli@redhat.com>
References: <20221026070418.259351-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

For ceph we couldn't check the encryption feature by mkfs, we need
to mount it first and then check the 'get_encpolicy' ioctl cmd.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 common/encrypt | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/common/encrypt b/common/encrypt
index 45ce0954..fd620c41 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -29,7 +29,7 @@ _require_scratch_encryption()
 	# Make a filesystem on the scratch device with the encryption feature
 	# enabled.  If this fails then probably the userspace tools (e.g.
 	# e2fsprogs or f2fs-tools) are too old to understand encryption.
-	if ! _scratch_mkfs_encrypted &>>$seqres.full; then
+	if ! _scratch_check_encrypted &>>$seqres.full; then
 		_notrun "$FSTYP userspace tools do not support encryption"
 	fi
 
@@ -143,7 +143,7 @@ _require_encryption_policy_support()
 	rm -r $dir
 }
 
-_scratch_mkfs_encrypted()
+_scratch_check_encrypted()
 {
 	case $FSTYP in
 	ext4|f2fs)
@@ -171,7 +171,7 @@ _scratch_mkfs_sized_encrypted()
 	esac
 }
 
-# Like _scratch_mkfs_encrypted(), but add -O stable_inodes if applicable for the
+# Like _scratch_check_encrypted(), but add -O stable_inodes if applicable for the
 # filesystem type.  This is necessary for using encryption policies that include
 # the inode number in the IVs, e.g. policies with the IV_INO_LBLK_64 flag set.
 _scratch_mkfs_stable_inodes_encrypted()
@@ -183,7 +183,7 @@ _scratch_mkfs_stable_inodes_encrypted()
 		fi
 		;;
 	*)
-		_scratch_mkfs_encrypted
+		_scratch_check_encrypted
 		;;
 	esac
 }
@@ -923,7 +923,7 @@ _verify_ciphertext_for_encryption_policy()
 			      FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32) )); then
 		_scratch_mkfs_stable_inodes_encrypted &>> $seqres.full
 	else
-		_scratch_mkfs_encrypted &>> $seqres.full
+		_scratch_check_encrypted &>> $seqres.full
 	fi
 	_scratch_mount
 
-- 
2.31.1

