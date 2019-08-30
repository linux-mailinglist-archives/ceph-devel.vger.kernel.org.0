Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4B1A38CE
	for <lists+ceph-devel@lfdr.de>; Fri, 30 Aug 2019 16:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbfH3OIS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 30 Aug 2019 10:08:18 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50519 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727756AbfH3OIR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 30 Aug 2019 10:08:17 -0400
Received: by mail-wm1-f67.google.com with SMTP id v15so7504218wml.0;
        Fri, 30 Aug 2019 07:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bFUHC/+EATNzZGS6Qv9osJUqzQ4/Jabg74pmuJQG+ao=;
        b=orkgkJvizZDLkJHjRmYVCQyak58OJtxEFodoeD5wP4g5hcIRU2NClViYSeiCUDQVZ5
         kHZ+az6cSmiWVuvzqU86OO3nYF8+In07z4i8THkk0NFy7k7+j0ETGb6ibebuI+kltY4w
         nU036TNydz9tFvEG206ol/HQdvzDKEkRx1hZhXHx5PWLt+7nJCFEy+HLtpREtGYoq9dF
         d4sMK8QwdeshG9Y0GxpoTvxJDQqXZBLvAAbh1BoJkwDNK+NiDSnyCy9AQRazrpk/WUvX
         0Dw21sv2XjZXkRuqR3mv1sIZ7aBvhDwMRgzGDwh/tG5vpuGhfCnU4aLe7ovWKkDuFjqZ
         OG2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bFUHC/+EATNzZGS6Qv9osJUqzQ4/Jabg74pmuJQG+ao=;
        b=ZyfgLMaVMOej4Gfe9XmoRUMmXDElgSBv9T8x4eNUdUvuhWEDxehHU2h5ORv5aLDZUt
         hws6D/OEPCBZ9KfrjPGt8WOUFo3/kUHJ8wptuaHl91WQ2Po8+W5oID//dcqGzLv4QEgN
         b9P1mpbpyR1NEpnOcpCHfn6xvtu0U54vJuP0j6nXdtnVWLm3Fep4qzHTuy4m59sgQlS0
         TCdF5WEjIUufmfLuHuE9IZx3QXx5P+RRQFphN7Owj45lIMvxYFgBVsI4lXh6biKpY6Me
         EJWPc66s4KRmP5vpAug663FVbWxqfOEiMHvhJtENx6UVY3joAgl7UQESZjj8o36VqUcu
         K1RA==
X-Gm-Message-State: APjAAAV8p6L/sHQb8X9njWl1LAAsxqRgvzfx8n0OSzbP+/uhoyqm/p+c
        EqRSrqIAvkIb7SN8K34cLW7Pp0OQmCc=
X-Google-Smtp-Source: APXvYqwyFcHyRzTsY7Z+1TShzWkeVl765NQ9a6hgjs0odCoqrdfASrTPsCXgcMxa1532uD86QsG8kQ==
X-Received: by 2002:a1c:b342:: with SMTP id c63mr18699850wmf.84.1567174095533;
        Fri, 30 Aug 2019 07:08:15 -0700 (PDT)
Received: from kwango.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id a17sm7458822wmm.47.2019.08.30.07.08.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 07:08:15 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 5.3-rc7
Date:   Fri, 30 Aug 2019 16:11:15 +0200
Message-Id: <20190830141115.8049-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit a55aa89aab90fae7c815b0551b07be37db359d76:

  Linux 5.3-rc6 (2019-08-25 12:01:23 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.3-rc7

for you to fetch changes up to d435c9a7b85be1e820668d2f3718c2d9f24d5548:

  rbd: restore zeroing past the overlap when reading from parent (2019-08-28 12:34:11 +0200)

----------------------------------------------------------------
A fix for a -rc1 regression in rbd and a trivial static checker fix.

----------------------------------------------------------------
Ilya Dryomov (1):
      rbd: restore zeroing past the overlap when reading from parent

Jia-Ju Bai (1):
      libceph: don't call crypto_free_sync_skcipher() on a NULL tfm

 drivers/block/rbd.c | 11 +++++++++++
 net/ceph/crypto.c   |  6 ++++--
 2 files changed, 15 insertions(+), 2 deletions(-)
