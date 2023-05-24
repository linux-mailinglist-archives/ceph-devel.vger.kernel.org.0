Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE9970FA5E
	for <lists+ceph-devel@lfdr.de>; Wed, 24 May 2023 17:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237010AbjEXPgE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 May 2023 11:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235582AbjEXPfK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 24 May 2023 11:35:10 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDCD210D8
        for <ceph-devel@vger.kernel.org>; Wed, 24 May 2023 08:34:47 -0700 (PDT)
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 8C0F74226F
        for <ceph-devel@vger.kernel.org>; Wed, 24 May 2023 15:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1684942451;
        bh=nUbgNVx3j+EjvX/3B5psKLPL9iW2vvt56NMjhT4BQS4=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=GEBmMagOvm4ju2xmzpQo8tW0sIDyZ57B04n09xDWXQO2Ne1ZXe714tPPuS64bPN8+
         FnQe90V5SrnvNXtTiCtHEo9YbNjhJP6dD4bKzbSI4WLt6q5kPVDPoQybailo4MD543
         tu1PrXJg6XCJjKc72NF28kH2fcX1WHulwh97jj6cjxAnyd7Lg54/merqix66wm6/CZ
         QrdJ0kyXg/MFMZ0nJVUhola4xpl54sict/R+Aj73sZsc/mVV5FA78tnDbYBX8fCPn/
         0Pr6H7mbFvSz9NK601XyqB1rbbQ7eUeQoNN3R8f6iSHNQlj2eB42g7Wo2Dy3wcg1ky
         DwI4Uw4fUvmvA==
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-513e9c14adbso1217801a12.3
        for <ceph-devel@vger.kernel.org>; Wed, 24 May 2023 08:34:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684942451; x=1687534451;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nUbgNVx3j+EjvX/3B5psKLPL9iW2vvt56NMjhT4BQS4=;
        b=TiGcGarltu81EU2SSF/aF0kFkiIkE+DvOiEI7EnVmjbzJd9m/5YYmsFhlY5hujGaJa
         HS/Eu6QvA1vzMQnmNeMxyorpde5U1LlNObO/ufKvnYiGW3trihnJcues7BetGdcJvqGi
         ybd6KmycqN2h+2laGtVFDp8TifVTVMBxfMiYqtjwOLOB89MdfSrI8Nbcxt8yQdl3s7qq
         tPQReEu1ARwTsG9xbu62VmhsVohQT03pWEr35AUmKxUL+fXsCGcDlanm6WJeT6oLByw5
         31s83gawZx2ufScNW9yodZlFsoyyRs0dQlhSnqyFWsZgK4JPH+yTwOWjxb9A5/d+K4ra
         Kqdg==
X-Gm-Message-State: AC+VfDyHJJ0B4XPlBvY+TzeSvhruNTMe3+jtwtP1Jl4hpfcoST1u/KNr
        x43xpHpNusy9ut5Ef9yd7HJQMpJJ0OOt4GP/3xN8ZjIQvVd+zwIJhQLL+VGUzVIcEvkzHSIIEWK
        SkHMce2h4W6PjUU8mhuQtXXyjO6kW3NR8tmj89mo=
X-Received: by 2002:a17:907:2cc7:b0:959:18b2:454a with SMTP id hg7-20020a1709072cc700b0095918b2454amr16847501ejc.76.1684942451058;
        Wed, 24 May 2023 08:34:11 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4agyA0tH+R6Uc7Qz229nwHWOixIWfcCKeLBdwkSFRUhR2KeRm98taylnAcoCXZTrZXUluskw==
X-Received: by 2002:a17:907:2cc7:b0:959:18b2:454a with SMTP id hg7-20020a1709072cc700b0095918b2454amr16847484ejc.76.1684942450831;
        Wed, 24 May 2023 08:34:10 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-074-206-207.088.074.pools.vodafone-ip.de. [88.74.206.207])
        by smtp.gmail.com with ESMTPSA id p26-20020a17090664da00b0096f7105b3a6sm5986979ejn.189.2023.05.24.08.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 08:34:10 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 08/13] ceph: allow idmapped getattr inode op
Date:   Wed, 24 May 2023 17:33:10 +0200
Message-Id: <20230524153316.476973-9-aleksandr.mikhalitsyn@canonical.com>
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

Enable ceph_getattr() to handle idmapped mounts. This is just a matter
of passing down the mount's idmapping.

Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
 fs/ceph/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 8e5f41d45283..2e988612ed6c 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2465,7 +2465,7 @@ int ceph_getattr(struct mnt_idmap *idmap, const struct path *path,
 			return err;
 	}
 
-	generic_fillattr(&nop_mnt_idmap, inode, stat);
+	generic_fillattr(idmap, inode, stat);
 	stat->ino = ceph_present_inode(inode);
 
 	/*
-- 
2.34.1

