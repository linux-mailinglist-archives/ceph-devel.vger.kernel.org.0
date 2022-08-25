Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 740E25A1261
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Aug 2022 15:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242731AbiHYNcm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Aug 2022 09:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242734AbiHYNcK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 25 Aug 2022 09:32:10 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD88B5E5C
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 06:32:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C3E69CE286C
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 13:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC9FC433D7;
        Thu, 25 Aug 2022 13:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661434315;
        bh=QKyZlSYVXJV901AKws+FOZfC1urdl6SBflxd0EzDd10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rnv9B2SrTfk4s/+RIMKNmdlWqmJVBBxmKygBcypySQIl/7yeYaicEpLF7H+/4NO1Q
         r+Puh9aSNvMZ0ZmDYwsZKW1CiIW84/ohcKwZrddc0UYahHyJnBqSHnceqZJK43b3Xu
         w2FunP9h7ohO1f2cXfPfH6wWSLO/RpVddFNG+iSmHwDGif4vQ0PxS2SRx+J+bycuUM
         3yCFtpQ95Z57b6ekrtsYBsjMmsnCZGYVoR/MBhRyhRBOasTBKVE6MAxgqZOtjykHQB
         HRPoq/wTeLzDxVwanDH4gYQLPITOaOo3yq07XIHztggAXcvMKNOtKI6Z86cfLUUGiA
         VhJf+KjaYUxhw==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     lhenriques@suse.de, ceph-devel@vger.kernel.org
Subject: [PATCH v15 29/29] ceph: report STATX_ATTR_ENCRYPTED on encrypted inodes
Date:   Thu, 25 Aug 2022 09:31:32 -0400
Message-Id: <20220825133132.153657-30-jlayton@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220825133132.153657-1-jlayton@kernel.org>
References: <20220825133132.153657-1-jlayton@kernel.org>
MIME-Version: 1.0
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

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index a8a6e55252c0..fb507d57cb26 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -3000,6 +3000,10 @@ int ceph_getattr(struct user_namespace *mnt_userns, const struct path *path,
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
2.37.2

