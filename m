Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C250519D99
	for <lists+ceph-devel@lfdr.de>; Wed,  4 May 2022 13:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244275AbiEDLJQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 May 2022 07:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348515AbiEDLJP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 4 May 2022 07:09:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F04D1CB1E
        for <ceph-devel@vger.kernel.org>; Wed,  4 May 2022 04:05:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D089061A47
        for <ceph-devel@vger.kernel.org>; Wed,  4 May 2022 11:05:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80D9C385A4;
        Wed,  4 May 2022 11:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651662338;
        bh=KQ07ZoEr14+Hh6u9jmuj/ylWxekLix9QYsFviPtNHio=;
        h=From:To:Cc:Subject:Date:From;
        b=IEoMlZvH8j0aek+j26YuT1+SWe7gVSoOH9Zvp9ArPNg6DFsLrHlPIekQVKOwlTpP1
         ZMfX6bl7EAfJpX4ul+HN9JAds4cy2bI2RO7f/XHQZM+fhmGR21Q6JtOZlDIvOqdIhb
         sE7px4FAlfVBfzuhsDwa1YAVvR50sYu8mv1n+oj4DKtuRR6Gnu4AH8gSlQW5zfXcd3
         dUZHi4V29OF5X0ai4zhYGbyZZHqurJnDYeiGEgicK0RUhdtyDLJ5dUUeZkQ2+yTUwi
         IzbAlTbqfPOtSMs/5ANyiIPPeppaG9S+CfNJI9w1L0EerXoqH5tOmNkWQhi3DO3zom
         T/9C94EdMOJnQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     lhenriques@suse.de, xiubli@redhat.com, idryomov@gmail.com
Subject: [PATCH] ceph: report STATX_ATTR_ENCRYPTED on encrypted inodes
Date:   Wed,  4 May 2022 07:05:36 -0400
Message-Id: <20220504110536.13418-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

...another minor patch for the fscrypt pile.

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index ae9afc149da1..f7d56aaea27d 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2979,6 +2979,10 @@ int ceph_getattr(struct user_namespace *mnt_userns, const struct path *path,
 			stat->nlink = 1 + 1 + ci->i_subdirs;
 	}
 
+	if (IS_ENCRYPTED(inode))
+		stat->attributes |= STATX_ATTR_ENCRYPTED;
+	stat->attributes_mask |= STATX_ATTR_ENCRYPTED;
+
 	stat->result_mask = request_mask & valid_mask;
 	return err;
 }
-- 
2.35.1

