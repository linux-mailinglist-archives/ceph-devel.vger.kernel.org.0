Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F075676EB95
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Aug 2023 16:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236571AbjHCOBk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 3 Aug 2023 10:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236555AbjHCOBU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 3 Aug 2023 10:01:20 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486351BFA
        for <ceph-devel@vger.kernel.org>; Thu,  3 Aug 2023 07:00:42 -0700 (PDT)
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com [209.85.167.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 2006C413C5
        for <ceph-devel@vger.kernel.org>; Thu,  3 Aug 2023 14:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1691071227;
        bh=dbq6NgAMN4t7wxNwyddA+VrJjiC20GkONqywDZDeteI=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=hw3g/Zns/5itz8A/VvNbRb4bP8ld5EoG5tkka7lz1s8Wz1jhYUIgGUixWB2KdGpoQ
         9yA0Nu1eiKCoLXwGx7LKMLpXI0rn9koeVHSfrOUSw+lKbvxuzG7YR1nIrMsGS61ql1
         B6Dq8n5YsnnNR+ufExcakvOOP+5Ll3bdsGjrLlqY27KtB/P1AyrLSag05nAgGmvhZk
         kNdL2KXT99bOSQkJWKwLkJ1Rsof7x7PAbqFufA0H4ttOoXCQ2Ssq1cx4hdIa6OJLoi
         vaH9RreyDTYbRfq/A62tNCv2IJpT8jPqp7/xhyxwo8fNqFrQ+4ztBdNeEfFRy76vfX
         A48/Uvi4N6n3w==
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-4fe52cd62aaso982632e87.0
        for <ceph-devel@vger.kernel.org>; Thu, 03 Aug 2023 07:00:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691071225; x=1691676025;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dbq6NgAMN4t7wxNwyddA+VrJjiC20GkONqywDZDeteI=;
        b=hpxLy3b/2K8bxe/sUZ0fKf4ui8cIBhOw+Q3Z/1pM1lIEmgZxcBof/ErfZ9mbvqPvwZ
         Q64vGHjMw6r5VtF8gnz6S7pGVsmkKZMdTgGUTLOJkdN/Deo5c+g6BZjzidmlzKsk+Isi
         KUX/x0uz/bkk7J9dBEkUyrer6FoVsRAt+smrHhiHWaPz2JEHev/EOteyhMBXHLWQE4uS
         7KiRBfiSbEybr6ptk4tjkM6fBaSmeVyMTEIOKjlUDpXuuTOBgj8VHeSXiTcmYxIPiqUe
         KpK76nZmKWzIoZbF9uPVGcjcdOOUpGef5YiIlyG4sWl10Twsz7/DmpW4nFB+n5L/FbYC
         EbAA==
X-Gm-Message-State: ABy/qLYscHn97sZPqytQDVnI6aDKd+nP1IxSwToBwYbPOvGgdBneJTTi
        Bk+44q/z5W5Kxm/h0gQvgvGCLY2hKuA2t2eD/8xUsDXcJFYsK0fWUTGwOwTBM8jdsGrjvZBJjHn
        c8HITExQixbRHSrfG0Bgria2RTAvVwpZ2n2KR+vo=
X-Received: by 2002:a19:504a:0:b0:4fb:94fd:645f with SMTP id z10-20020a19504a000000b004fb94fd645fmr6531912lfj.68.1691071225618;
        Thu, 03 Aug 2023 07:00:25 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHGwj0wtDI8iNxIwzK1IOpeEx1Ty6UrtKDYlpyeVt4cmW1eycKEacTWhMO/37ZGK1a8a68Q6A==
X-Received: by 2002:a19:504a:0:b0:4fb:94fd:645f with SMTP id z10-20020a19504a000000b004fb94fd645fmr6531906lfj.68.1691071225425;
        Thu, 03 Aug 2023 07:00:25 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-066-182-192.088.066.pools.vodafone-ip.de. [88.66.182.192])
        by smtp.gmail.com with ESMTPSA id bc21-20020a056402205500b0052229882fb0sm10114822edb.71.2023.08.03.07.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 07:00:25 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v8 06/12] ceph: allow idmapped getattr inode op
Date:   Thu,  3 Aug 2023 15:59:49 +0200
Message-Id: <20230803135955.230449-7-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230803135955.230449-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230803135955.230449-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Christian Brauner <brauner@kernel.org>

Enable ceph_getattr() to handle idmapped mounts. This is just a matter
of passing down the mount's idmapping.

Cc: Xiubo Li <xiubli@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
 fs/ceph/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 3ff4f57f223f..136b68ccdbef 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -3034,7 +3034,7 @@ int ceph_getattr(struct mnt_idmap *idmap, const struct path *path,
 			return err;
 	}
 
-	generic_fillattr(&nop_mnt_idmap, inode, stat);
+	generic_fillattr(idmap, inode, stat);
 	stat->ino = ceph_present_inode(inode);
 
 	/*
-- 
2.34.1

