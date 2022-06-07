Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16F69540232
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Jun 2022 17:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343891AbiFGPOk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Jun 2022 11:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245009AbiFGPOg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Jun 2022 11:14:36 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2747C69725;
        Tue,  7 Jun 2022 08:14:35 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D1DD621C03;
        Tue,  7 Jun 2022 15:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654614873; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VknnvnSJSSYJR7uOjJIWJT5soubHTaHaLeV6HtZ95Kk=;
        b=FqJKyVxPcidm0ip36k9mTHPpleH4qwa7uBKmr6QcEMGN4ubAga8BiiVZD3E6LwO2oIt0q1
        yFcrZ+1t0Jo9uM/To+Zieqo6bsKWdhidZbO+7rYJ55aNnWmJo1l5s54Ut4o226tCgJF8Zf
        Cd7/1azJyBQ0Xe/5//IZDJmMjW3quKI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654614873;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VknnvnSJSSYJR7uOjJIWJT5soubHTaHaLeV6HtZ95Kk=;
        b=84trZDrKi1auM6YI2auDGGNfEfCKdXt/WCp08wstFYGY8vsESWNhFKh0ki6swYI8vzvGHX
        jQ65QWgMMRQbsKAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6E83313A88;
        Tue,  7 Jun 2022 15:14:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id EKvXF1lrn2JRWwAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 07 Jun 2022 15:14:33 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id d6e9c696;
        Tue, 7 Jun 2022 15:15:14 +0000 (UTC)
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     fstests@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        ceph-devel@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [PATCH 1/2] generic/020: adjust max_attrval_size for ceph
Date:   Tue,  7 Jun 2022 16:15:12 +0100
Message-Id: <20220607151513.26347-2-lhenriques@suse.de>
In-Reply-To: <20220607151513.26347-1-lhenriques@suse.de>
References: <20220607151513.26347-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

CephFS doesn't had a maximum xattr size.  Instead, it imposes a maximum
size for the full set of an inode's xattrs names+values, which by default
is 64K but it can be changed by a cluster admin.

Adjust max_attrval_size so that the test can be executed in this
filesystem.

Signed-off-by: Luís Henriques <lhenriques@suse.de>
---
 tests/generic/020 | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tests/generic/020 b/tests/generic/020
index d8648e96286e..cadfce5f45e3 100755
--- a/tests/generic/020
+++ b/tests/generic/020
@@ -128,15 +128,16 @@ _attr_get_max()
 	pvfs2)
 		max_attrval_size=8192
 		;;
-	xfs|udf|9p|ceph)
+	xfs|udf|9p)
 		max_attrval_size=65536
 		;;
 	bcachefs)
 		max_attrval_size=1024
 		;;
-	nfs)
-		# NFS doesn't provide a way to find out the max_attrval_size for
-		# the underlying filesystem, so just use the lowest value above.
+	nfs|ceph)
+		# NFS and CephFS don't provide a way to find out the
+		# max_attrval_size for the underlying filesystem, so just use
+		# the lowest value above.
 		max_attrval_size=1024
 		;;
 	*)
