Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD1A4E9838
	for <lists+ceph-devel@lfdr.de>; Mon, 28 Mar 2022 15:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243217AbiC1Nen (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 28 Mar 2022 09:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241293AbiC1Nem (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 28 Mar 2022 09:34:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32168260B
        for <ceph-devel@vger.kernel.org>; Mon, 28 Mar 2022 06:33:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA7ABB80E01
        for <ceph-devel@vger.kernel.org>; Mon, 28 Mar 2022 13:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39182C004DD;
        Mon, 28 Mar 2022 13:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648474379;
        bh=hMRMp2+j31hhFxWyjnqQ9W9ayHzPb0GdhYOwt5nAwi0=;
        h=From:To:Cc:Subject:Date:From;
        b=qivOl7li2HlSY8lW7gTRHI6vklCvlpvir3TILO7y+CunYaFc29opzIxoiDcWtBbb5
         /ikDk+LuZrRnvYzNSM1KphiOG02XM5k9uFB5I1R9fURDxEC8YA7L5jOytX3ou7BZqX
         YRVmMR8pMi8pn/UTlyWxEgq5EI5vuFMTUco4XmbYmD52V9VR42XUvm3uVEYevBaAiu
         am2qDf+OfazE5dYBCRxnCu/nxujRgn3SyYncHnD4mSSAtkfNWkuq7HZ5zQMgKB+OqO
         eJ7rBe9VezYvoQn5toHW7hMGRoT/dvRAiOY0gJOOZ7+EpHWfb6Mrkgt04c1Ygwm4uc
         NLFYzZDVx+EUg==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, xiubli@redhat.com,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [PATCH] ceph: shrink dcache when adding a key
Date:   Mon, 28 Mar 2022 09:32:57 -0400
Message-Id: <20220328133257.28422-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Any extant dentries under a directory will be invalid once a key is
added to the directory. Prune any child dentries of the parent after
adding a key.

Cc: Luís Henriques <lhenriques@suse.de>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/ioctl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

This one is for the ceph+fscrypt series.

Luis, this seems to fix 580 and 593 for me. 595 still fails with it, but
that one is more related to file contents.

diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
index 9675ef3a6c47..12d5469c5df2 100644
--- a/fs/ceph/ioctl.c
+++ b/fs/ceph/ioctl.c
@@ -397,7 +397,10 @@ long ceph_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		ret = vet_mds_for_fscrypt(file);
 		if (ret)
 			return ret;
-		return fscrypt_ioctl_add_key(file, (void __user *)arg);
+		ret = fscrypt_ioctl_add_key(file, (void __user *)arg);
+		if (ret == 0)
+			shrink_dcache_parent(file_dentry(file));
+		return ret;
 
 	case FS_IOC_REMOVE_ENCRYPTION_KEY:
 		return fscrypt_ioctl_remove_key(file, (void __user *)arg);
-- 
2.35.1

