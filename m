Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB6770FA75
	for <lists+ceph-devel@lfdr.de>; Wed, 24 May 2023 17:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237180AbjEXPhJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 May 2023 11:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237173AbjEXPgc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 24 May 2023 11:36:32 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D238CE46
        for <ceph-devel@vger.kernel.org>; Wed, 24 May 2023 08:35:12 -0700 (PDT)
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 603DD423A2
        for <ceph-devel@vger.kernel.org>; Wed, 24 May 2023 15:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1684942455;
        bh=Md8TLnFONebgQ4vC2/VtTKzXRXy8hQu8U3It9LdXrRE=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=bhC4YNeX35pSUHBPzJjqkYN07y71/FMuAMbEZfHv/nPaZqFTyAJm99sS2ujhe4vqo
         izO895S+AMYV8mlb5BQCYvN24FlHMIc4ChdUBPuxYIy6WC5O0MyjhUyNChh8UK88BL
         4DtYmjQmpUyJ1II2mbLgAwd2gpm4V/3xKVlQGtSZKiQpykWLdyQRKgxt1d5gJGTPDo
         ev7ObDM/R9sRgwLz+G/d+hd8GvDQAhAT1eI4oMgIjjIGDI1C0Sxj3RUQGw/E2ck9YE
         rpqHY9iCystR7jUm9xjCfl30DJ5YNKMh3npXB69yeaSMPAvBPK5VIE37Q6gQuMr2vG
         HE74JZEpPQneQ==
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-96f4f1bb838so105792466b.3
        for <ceph-devel@vger.kernel.org>; Wed, 24 May 2023 08:34:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684942455; x=1687534455;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Md8TLnFONebgQ4vC2/VtTKzXRXy8hQu8U3It9LdXrRE=;
        b=LC/IGvjhivK/dKzOKVN1WaOBCJVAAu43/qmHpXoK9OdUlcFGBKNgnG6p6lgZnDX8zD
         MNOme7no1wC7kfeeZUYwVzZkpA1kvaRKxK/nLwKAfVIxzIJ+p+nNHbTZmEcVYBppLw3q
         WyNOie6us2vTU55KU/sM/nOWV5NVw/CYFFjo3Umm/KYJBUEUcw4T1iBUAaKYVYeAjrIN
         RvRvEmbn8SVE+LpWhXYBAvS55N72TqrAKKk6jiei6j9Gh2Pi9zRh7ptFSVjInNBZak/D
         1U9+pHTZ8/BM1uCm+TWQrmxrJlmFlls1n5WSU82TlJNWxV4j+TN7i7DnwImUQqPBt3av
         z9Fw==
X-Gm-Message-State: AC+VfDwq5ELBEqSVuhKjppHFOrA7LV5V194RbDJTDGe4c4VJJVs+mAqh
        GFDKpnmnv7TyZMnEhBZ4oss88M94P/3WlJEa3ThvziZcC7t40Bxy9bqfmbsC3/0jD5YcOzJy2Tu
        ldoAG0f58N4WO1NFD+iVAT34GWK3n3QnVOjMV1OE=
X-Received: by 2002:a17:907:a42b:b0:96f:9cea:a346 with SMTP id sg43-20020a170907a42b00b0096f9ceaa346mr12483831ejc.1.1684942455178;
        Wed, 24 May 2023 08:34:15 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4wBfGopEZ/PbcB7gaSEiXxq8R0KVY7IbTh7GgeLo03JonIsvQba/f+t+zD7HunE0mybct/6w==
X-Received: by 2002:a17:907:a42b:b0:96f:9cea:a346 with SMTP id sg43-20020a170907a42b00b0096f9ceaa346mr12483820ejc.1.1684942454952;
        Wed, 24 May 2023 08:34:14 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-074-206-207.088.074.pools.vodafone-ip.de. [88.74.206.207])
        by smtp.gmail.com with ESMTPSA id p26-20020a17090664da00b0096f7105b3a6sm5986979ejn.189.2023.05.24.08.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 08:34:14 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 10/13] ceph: allow idmapped setattr inode op
Date:   Wed, 24 May 2023 17:33:12 +0200
Message-Id: <20230524153316.476973-11-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230524153316.476973-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230524153316.476973-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

Enable __ceph_setattr() to handle idmapped mounts. This is just a matter
of passing down the mount's idmapping.

Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
 fs/ceph/inode.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 37e1cbfc7c89..f1f934439be0 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2050,6 +2050,13 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr)
 
 	dout("setattr %p issued %s\n", inode, ceph_cap_string(issued));
 
+	/*
+	 * The attr->ia_{g,u}id members contain the target {g,u}id we're
+	 * sending over the wire. The mount idmapping only matters when we
+	 * create new filesystem objects based on the caller's mapped
+	 * fs{g,u}id.
+	 */
+	req->r_mnt_idmap = &nop_mnt_idmap;
 	if (ia_valid & ATTR_UID) {
 		dout("setattr %p uid %d -> %d\n", inode,
 		     from_kuid(&init_user_ns, inode->i_uid),
@@ -2240,7 +2247,7 @@ int ceph_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	if (ceph_inode_is_shutdown(inode))
 		return -ESTALE;
 
-	err = setattr_prepare(&nop_mnt_idmap, dentry, attr);
+	err = setattr_prepare(idmap, dentry, attr);
 	if (err != 0)
 		return err;
 
@@ -2255,7 +2262,7 @@ int ceph_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	err = __ceph_setattr(inode, attr);
 
 	if (err >= 0 && (attr->ia_valid & ATTR_MODE))
-		err = posix_acl_chmod(&nop_mnt_idmap, dentry, attr->ia_mode);
+		err = posix_acl_chmod(idmap, dentry, attr->ia_mode);
 
 	return err;
 }
-- 
2.34.1

