Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 820613C9FC6
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Jul 2021 15:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238055AbhGONnp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 15 Jul 2021 09:43:45 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:59748 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237823AbhGONng (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 15 Jul 2021 09:43:36 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A356220305;
        Thu, 15 Jul 2021 13:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626356442; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=gyZhxHZioQnjZVdJUow5Mw2QUXHysMd4yxvDdw4DGwc=;
        b=0furoNcuZP5rAqEkjRYeMbZlOvha/jXVBqe3WnohXwO61ArjIXlszycv/AirHzRdvBxBFC
        lEtQkGiy50HntVcFKQ7JZqIyVTWeEP1qvcSenLoJ4TlfCnEsqn1dSFynzrB5PqKsa93JLY
        Al6YjAG8kBHvAYpNBNFbmAfVMbO8Ogs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626356442;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=gyZhxHZioQnjZVdJUow5Mw2QUXHysMd4yxvDdw4DGwc=;
        b=xKnyqSKJPZuDSl+zTIK1Gz+oDgi+gVCnrNaJscHgH4ZbSX2CHhE5WN/RaVVt5lqMMincJD
        2GMZVMbbRWJTrsDA==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 3848213D89;
        Thu, 15 Jul 2021 13:40:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id /sSiCto68GCUVwAAGKfGzw
        (envelope-from <lhenriques@suse.de>); Thu, 15 Jul 2021 13:40:42 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id aad06e43;
        Thu, 15 Jul 2021 13:40:41 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.de>
Subject: [PATCH] ceph: don't WARN if we're still opening a session to an MDS
Date:   Thu, 15 Jul 2021 14:40:39 +0100
Message-Id: <20210715134039.10466-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

If MDSs aren't available while mounting a filesystem, the session state will
transition from SESSION_OPENING to SESSION_CLOSING.  And in that scenario
check_session_state() will be called from delayed_work() and trigger this
WARN.

Avoid this by only WARNing after a session has already been established
(i.e., the s_ttl will be different from 0).

Fixes: 62575e270f66 ("ceph: check session state after bumping session->s_seq")
Signed-off-by: Luis Henriques <lhenriques@suse.de>
---
 fs/ceph/mds_client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index e5af591d3bd4..86f09b1110a2 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4468,7 +4468,7 @@ bool check_session_state(struct ceph_mds_session *s)
 		break;
 	case CEPH_MDS_SESSION_CLOSING:
 		/* Should never reach this when we're unmounting */
-		WARN_ON_ONCE(true);
+		WARN_ON_ONCE(s->s_ttl);
 		fallthrough;
 	case CEPH_MDS_SESSION_NEW:
 	case CEPH_MDS_SESSION_RESTARTING:
