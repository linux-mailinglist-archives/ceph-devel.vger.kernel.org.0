Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 285C010069D
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Nov 2019 14:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfKRNia (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Nov 2019 08:38:30 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34261 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbfKRNia (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 Nov 2019 08:38:30 -0500
Received: by mail-wm1-f68.google.com with SMTP id j18so15981210wmk.1
        for <ceph-devel@vger.kernel.org>; Mon, 18 Nov 2019 05:38:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gesLCMBuPmiyA/wE4MIe3Ytkk0ovihVOwFFwkjxL2Rc=;
        b=J8fdQ03vTZdf99fhzwmZN6gCDvct5ggA5O+uX55JDUx5IFG+B4xgf7NfRN/aYEMbgN
         YPXjVkgkkAGRwGmbkPGk47cEC+6+M5bcChfmnF3C1OgedYewP+jrn2qjsDLQdXJDMZwc
         ihVFn07a1s9KRlqkQ5rALhLULs4SSTNv0QCX242PCZvpDl2//+irGuG9v2CiknN6x/45
         SgfnDc/AT3mYk1U41T/a+gtbLmbq/X7c77XmCFhKjRx7Rf457o3zxFrHrolTx/LXvjV9
         SRGvq3HpVNW68+9sktKNxOtQ0pWfNuU18gLVgVEJkZETZniBcSO/P5yQ/vQNdIi+/abG
         VudA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gesLCMBuPmiyA/wE4MIe3Ytkk0ovihVOwFFwkjxL2Rc=;
        b=U8/meZgBTqyruVx15xKzP/UEzjnoHGe663LD+zcMwy4zYtPlS+weD6UzTL7fmIFEx5
         mfpRGrMUk8tngfvNdQBFYaEamS4KRyDq6LtsOGHQ4IB3bt7oL5g0qPYgPme9O4NUI0cm
         tB5EREaFpvpifaybjGwVGm14umTvDybeY2g55ouJ7GIJQ0vA2Byt4jFHqLIg9hbHNgjd
         fs0BwnTO9VX0vF143eHZG+dFDrDZnVdSqhLdH0EFpuq8VFpvo5SOV2G2cGB62PiaPA0T
         qL2m1rDRPv+lbP2agskkNLKTN7R08N6CqYf3jjFNwZqGajSKfQghtcRpzdgrGz45oYHU
         nOew==
X-Gm-Message-State: APjAAAUfoWgOi7jHe7WoJabnkXAEuFBtPxkiWtTWPc0sX4LxbS11sdxA
        H6u5LnV4Yu1thn+PQ3EByot2uMqv
X-Google-Smtp-Source: APXvYqwbB44VzWhTJ5GTyy9XoC6p63VW4CZqja80RzHKslqkkmaAH5Kk356eqzc36MsqThhRe2xcYQ==
X-Received: by 2002:a1c:9dd3:: with SMTP id g202mr30400815wme.43.1574084308385;
        Mon, 18 Nov 2019 05:38:28 -0800 (PST)
Received: from kwango.local (ip-94-112-128-92.net.upcbroadband.cz. [94.112.128.92])
        by smtp.gmail.com with ESMTPSA id t133sm24670242wmb.1.2019.11.18.05.38.27
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 05:38:27 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH 0/9] wip-krbd-readonly
Date:   Mon, 18 Nov 2019 14:38:07 +0100
Message-Id: <20191118133816.3963-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello,

This series makes read-only mappings compatible with read-only caps:
we no longer establish a watch, acquire header and object map locks,
etc.  In addition, because images mapped read-only can no longer be
flipped to read-write, we allow read-only mappings with unsupported
features, as long as the image is still readable.

Thanks,

                Ilya


Ilya Dryomov (9):
  rbd: introduce rbd_is_snap()
  rbd: introduce RBD_DEV_FLAG_READONLY
  rbd: treat images mapped read-only seriously
  rbd: disallow read-write partitions on images mapped read-only
  rbd: don't acquire exclusive lock for read-only mappings
  rbd: don't establish watch for read-only mappings
  rbd: remove snapshot existence validation code
  rbd: don't query snapshot features
  rbd: ask for a weaker incompat mask for read-only mappings

 drivers/block/rbd.c | 203 ++++++++++++++++++++------------------------
 1 file changed, 93 insertions(+), 110 deletions(-)

-- 
2.19.2

