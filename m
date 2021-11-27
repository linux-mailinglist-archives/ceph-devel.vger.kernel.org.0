Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B5846007A
	for <lists+ceph-devel@lfdr.de>; Sat, 27 Nov 2021 18:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235346AbhK0R1P (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 27 Nov 2021 12:27:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235413AbhK0RZP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 27 Nov 2021 12:25:15 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3785DC06175B;
        Sat, 27 Nov 2021 09:21:07 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id d9so5171152wrw.4;
        Sat, 27 Nov 2021 09:21:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uY2tL9qhFrzI8JAAY9tCjldOg3akMXRLK2477GuQImA=;
        b=H+NdGFnAvugCC8rNPmCbHvhKjbupanM/bZP25WuRkD4e8aY9HLoB8+6Bb8VZnlaa8A
         qwZB5mUSVcfWjdmr4R+lyJw6CKsi+rxwi44GsugDSI3VvnaYp42arO6kWZpISg4riLIb
         rRjYya0wjgqdvIsOPar9rdqgERtj/g+PLohKNs2D6Zf0uKt3ETgWMzG2abfu70H45GrC
         p9wKtF0iJusVRxiisTJIw/HnEDmpls8WIwJZ5cg7ddYuBdAajWBfxGYXwoEm0zNsLgbc
         dp1gJcqwbgCZOHqEaYRxcXfTodkrnrEh6xylg73nz1US6eXjDciv5Vmgk94XtnkbqefG
         zYlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uY2tL9qhFrzI8JAAY9tCjldOg3akMXRLK2477GuQImA=;
        b=fNaPiVn2XmqeSa+eHFMHJML7SriRtoxxq1irk1kdjbhysaC4/qRT71ldpfxJnLjxWR
         hYqM17gi64+blc54ZyHavF+ZRvEJpZ66M4lnzN3TI6jIY3G9GwUc4MyEbucjlLCMn9qU
         ToO5G1CNVETZEkXiuZYiRlEYn6oLNwXOlJ95LgwEgows4TCMP97H1SMRFvaXFMifSbPz
         CyrPRg5e8OLTcHAi/v2A4P60OI6RNZ/2q1ZfSfPFlpN/SjZLlR6mZufhPspyVFa1h/Ni
         iujbm47hL9ihHaN0vMaBio+0qoqPnHDXOqSM/tSQn6smRnxjnD7RLARfp0EXRnmYK/GM
         yy2A==
X-Gm-Message-State: AOAM532+zXKZABOnY93SA+vkdKPX3+eRPDQJFWqwrirs8eNgIGwXWOyg
        OnNVUppcrXkoeA==
X-Google-Smtp-Source: ABdhPJzCIXEHX9OSLEoedHwOkytNNervPV6S1X3Zig+KJ2ybnw6WLYz9rx8s4dr0p7t7Ujo/eCQTMQ==
X-Received: by 2002:a5d:66cd:: with SMTP id k13mr21821581wrw.517.1638033665798;
        Sat, 27 Nov 2021 09:21:05 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id l5sm15666441wms.16.2021.11.27.09.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Nov 2021 09:21:05 -0800 (PST)
From:   Colin Ian King <colin.i.king@googlemail.com>
X-Google-Original-From: Colin Ian King <colin.i.king@gmail.com>
To:     Ilya Dryomov <idryomov@gmail.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        Jens Axboe <axboe@kernel.dk>, ceph-devel@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rbd: make const pointer speaces a static const array
Date:   Sat, 27 Nov 2021 17:21:04 +0000
Message-Id: <20211127172104.102994-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Don't populate the const array spaces on the stack but make it static
const and make the pointer an array to remove a dereference. Shrinks
object code a little too.  Also clean up intent, currently it is spaces
and should be a tab.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/block/rbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 8f140da1efe3..de7ede6aa95a 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -6189,7 +6189,7 @@ static inline size_t next_token(const char **buf)
         * These are the characters that produce nonzero for
         * isspace() in the "C" and "POSIX" locales.
         */
-        const char *spaces = " \f\n\r\t\v";
+	static const char spaces[] = " \f\n\r\t\v";
 
         *buf += strspn(*buf, spaces);	/* Find start of token */
 
-- 
2.33.1

