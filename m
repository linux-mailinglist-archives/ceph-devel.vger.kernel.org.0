Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7015F59FB3A
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Aug 2022 15:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237051AbiHXNYv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Aug 2022 09:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237983AbiHXNYt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 24 Aug 2022 09:24:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5157A10BF
        for <ceph-devel@vger.kernel.org>; Wed, 24 Aug 2022 06:24:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAE34B8238B
        for <ceph-devel@vger.kernel.org>; Wed, 24 Aug 2022 13:24:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B854C433D6;
        Wed, 24 Aug 2022 13:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661347484;
        bh=PG5lfbg3TOCBmuiyPvFsbkZfQVYqZeycmTlg3ScmjoI=;
        h=From:To:Cc:Subject:Date:From;
        b=nOF3C0hmnYChpgh4b0BniSGTSQQ0+oeXRWyLDRwfQLjzgOvat5GGytD/g0zCjRnIp
         gqkMcKwmDx9dCFZK3aKWOAiCq/Z3lpv/OG6Rh78t3N5uD+BBssKVCU4Ih3eGphjy6K
         SYxEOpDNEJbKSlIXUH1DHywK1Qf0pLnwA/F2oDLETLRcS99RzWTudd8AKPUkYYJgfe
         /H3jUv9z6zHHQ/JTopxG9yoeTg6AaWkIKhJv6A+XxadBEr/ngzFSUTGfIHkjtsxt+i
         v29MaE/NpSnrXW+RzCN/NYTADdaATkfwGhjrcZkdqbUcfoNYisaPEPrdLx73VEXpQB
         amzKB3hG6zQSw==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Subject: [PATCH] ceph: increment i_version when doing a setattr with caps
Date:   Wed, 24 Aug 2022 09:24:42 -0400
Message-Id: <20220824132442.102062-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.37.2
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

When the client has enough caps to satisfy a setattr locally without
having to talk to the server, we currently do the setattr without
incrementing the change attribute.

Ensure that if the ctime changes locally, then the change attribute
does too.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index ccc926a7dcb0..65161296d449 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2192,6 +2192,7 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr)
 		inode_dirty_flags = __ceph_mark_dirty_caps(ci, dirtied,
 							   &prealloc_cf);
 		inode->i_ctime = attr->ia_ctime;
+		inode_inc_iversion_raw(inode);
 	}
 
 	release &= issued;
-- 
2.37.2

