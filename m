Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0EAA2FDAB2
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Jan 2021 21:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388946AbhATUWu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Jan 2021 15:22:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731437AbhATOAk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 20 Jan 2021 09:00:40 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABDDC0613ED
        for <ceph-devel@vger.kernel.org>; Wed, 20 Jan 2021 05:59:11 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id b21so17030457edy.6
        for <ceph-devel@vger.kernel.org>; Wed, 20 Jan 2021 05:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MXYDFfJfHtZNKaoHz8s5O+gYRG9oeb0oxVARio+bTw0=;
        b=FmL7upeQnkwnZBVDwIZAWlLFJwdd5D2vRhDdTMnX7qIEfIgpsg37eTiF4hGZu5rh7j
         mbRI8I8XCtRnxXd0La/i/ckfeTaXTmQfZlyQQNuZMUS8E1LugwdB5kQpwc+Pr5ZGWY3w
         246fzvPGA4CTxsuEuybyTtO/NJnUZNS5q/LoCMIR4wMRqGslv2NfKt0dEyKVjsTyi8Fh
         sOY5JprL6TAdkH1PusUPZitcz3gbkVvLsxTKUlvl3dGkfFhnecW0eN0cEex+LNweqT51
         N643a3dMXiZfRh0RiNPiKb38UjrBqkZUc15AJUTCKvaActLnSgiZN381JxjLo/JGH7L7
         ge3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MXYDFfJfHtZNKaoHz8s5O+gYRG9oeb0oxVARio+bTw0=;
        b=pXv9ZacPzzwt3L/1tLvDuwl0OkULNVJnWj+nZ+dY/2RIaEGCAv5oYFitYRxxoa6CMM
         3G3FArb42Ac0vzxcyWk/MRTqjsujWWTgCrsX4w5CRtnR33jScWh0a7B1EW8eNM71+uRz
         EGBWst5evZPIr3OpFaXaGkRPLs2x1H66tr2XU7IRAH5V7xcPxy96LGVSaR3suXvWmdZ4
         /z80xmgpI4T53vzIk8LDOZfyq2qgKGXg9CjDPazOzfmSK5LcnTrMzNe8FD+gmrulYqZ/
         +whH11yeLykhYK9yErKn52TFe3s0blZ0HFLP9VUuPjExnxq34kxW837J1cFtUGNWPo3w
         fvZg==
X-Gm-Message-State: AOAM533SIK3Ko7zrC6ptDhAKX1yBcXjtLGhyCkzg6eUd7urdIGXZcZIp
        IZ5qm8QRTuU/3DAMbZPrTW4QFO12Br4=
X-Google-Smtp-Source: ABdhPJxAA0hHwMo3q39LK+BM8bt3O5pLJvJppX1hHpA8aItK/9ciA85Wn94L44j3acKfYGrm2PJ7yg==
X-Received: by 2002:a50:fb97:: with SMTP id e23mr7672705edq.208.1611151150749;
        Wed, 20 Jan 2021 05:59:10 -0800 (PST)
Received: from kwango.local (ip-94-112-132-16.net.upcbroadband.cz. [94.112.132.16])
        by smtp.gmail.com with ESMTPSA id ko23sm951234ejc.35.2021.01.20.05.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 05:59:10 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] libceph: fix "Boolean result is used in bitwise operation" warning
Date:   Wed, 20 Jan 2021 14:59:25 +0100
Message-Id: <20210120135925.10119-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This line dates back to 2013, but cppcheck complained because commit
2f713615ddd9 ("libceph: move msgr1 protocol implementation to its own
file") moved it.  Add parenthesis to silence the warning.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 net/ceph/messenger_v1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
index 04f653b3c897..2cb5ffdf071a 100644
--- a/net/ceph/messenger_v1.c
+++ b/net/ceph/messenger_v1.c
@@ -1100,7 +1100,7 @@ static int read_partial_message(struct ceph_connection *con)
 		if (ret < 0)
 			return ret;
 
-		BUG_ON(!con->in_msg ^ skip);
+		BUG_ON((!con->in_msg) ^ skip);
 		if (skip) {
 			/* skip this message */
 			dout("alloc_msg said skip message\n");
-- 
2.19.2

